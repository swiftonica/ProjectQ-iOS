//
//  PackagesInformationCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import NavigationLayer
import ProjectQ_Components
import UIKit
import SwiftUI
import ModuleAssembler

class PackagesInformationCoordinator: Coordinatable {
    enum _ReturnData {
        case finish(TaskPackage)
    }
    
    var completion: ((_ReturnData) -> Void)?
    
    func start() {
        addPackageInformationModule()
    }
    
    init(package: TaskPackage) {
        self.package = package
    }
    
    // private
    var childCoordinators: [CompletionlessCoordinatable] = []
    private(set) var navigationController = ClosableNavigationController().onlyFirst()
    private let package: TaskPackage
    
    private enum Modules {
        case components
    }
    
    private var keeper = ModuleKeeper<Modules>()
    
    private var packageInformationModule: Module<AssemblableUIHostingViewController<PackageInformationView>, PackageInformationPresenter, PackageInformationPublicInterface>!
    private var taskInformationModule: Module<AssemblableUIHostingViewController<TaskInformationView>, TaskInformationPresenter, TaskInformationPresenter>!
}

private extension PackagesInformationCoordinator {
    func addPackageInformationModule() {
        let assembler = PackageInformationModule(package: package)
        packageInformationModule = assembler.module
  
        packageInformationModule.view.rootView.completion = {
            event in
            switch event {
            case .addTask:
                let presenter = TaskInformationPresenter()
                let module = SUIAssembler2(TaskInformationView(), presenter, presenter).module
                
                module.view.rootView.completion = {
                    event in
                    switch event {
                    case .addComponent:
                        let componentCoordinator = ComponentsCoordinator(
                            navigationController: self.navigationController,
                            isAnimated: true
                        )
                        self.add(coordinatable: componentCoordinator)
                        componentCoordinator.start()
                        componentCoordinator.completion = {
                            event in
                            switch event {
                            case .didChooseComponent(let component):
                                self.navigationController.popToViewController(
                                    self.taskInformationModule.view,
                                    animated: true
                                )
                                self.taskInformationModule.publicInterface?.addComponent(component)
                            }
                        }
                        
                    case .finish(let task):
                        self.navigationController.popViewController(animated: true)
                        self.packageInformationModule.publicInterface?.addTask(task)
                        break
                        
                    default: break
                    }
                }
                
                self.navigationController.pushViewController(module.view, animated: true)
                self.taskInformationModule = module
                
            case .finish(let package):
                self.completion?(.finish(package))
                
            default: break
            }
        }
        navigationController.pushViewController(packageInformationModule.view, animated: false)
        navigationController.setToolbarHidden(false, animated: false)
    }
}
