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
    //private var taskInformationModule: Module<AssemblableUIHostingViewController<TaskInformationView>, TaskInformationPresenter, TaskInformationPresenter>!
    
    // state
    private var selectedTaskIndex: Int!
}

private extension PackagesInformationCoordinator {
    func addPackageInformationModule() {
        let assembler = PackageInformationModule(package: package)
        packageInformationModule = assembler.module
  
        packageInformationModule.view.rootView.completion = {
            event in
            switch event {
                
            case .didSelectTask(let task):
                let taskInformationCoordinator = TaskInformationCoordinator(
                    task: task,
                    navigationController: self.navigationController
                )
                taskInformationCoordinator.completion = {
                    [unowned self] event in
                    switch event {
                    case .finsish(let _task):
                        self.remove(coordinatable: taskInformationCoordinator)
                        self.packageInformationModule.publicInterface?.updateTask(
                            at: self.selectedTaskIndex,
                            task: _task
                        )
                    }
                }
                self.add(coordinatable: taskInformationCoordinator)

            case .addTask:
                let taskInformationCoordinator = TaskInformationCoordinator(navigationController: self.navigationController)
                taskInformationCoordinator.completion = {
                    [unowned self] event in
                    switch event {
                    case .finsish(let task):
                        self.remove(coordinatable: taskInformationCoordinator)
                        self.packageInformationModule.publicInterface?.addTask(task)
                        self.navigationController.popViewController(animated: true)
                    }
                }
                self.add(coordinatable: taskInformationCoordinator)
                
                
            case .finish(let taskPackage):
                self.completion?(.finish(taskPackage))
                
            case .didSelectIndex(let index):
                self.selectedTaskIndex = index // [!] <- set state

                
//                let presenter = TaskInformationPresenter()
//                let module = SUIAssembler2(TaskInformationView(), presenter, presenter).module
//
//                module.view.rootView.completion = {
//                    event in
//                    switch event {
//                    case .addComponent:
//                        let componentCoordinator = ComponentsCoordinator(
//                            navigationController: self.navigationController,
//                            isAnimated: true
//                        )
//                        self.add(coordinatable: componentCoordinator)
//                        componentCoordinator.start()
//                        componentCoordinator.completion = {
//                            event in
//                            switch event {
//                            case .didChooseComponent(let component):
//                                self.navigationController.popToViewController(
//                                    self.taskInformationModule.view,
//                                    animated: true
//                                )
//                                self.taskInformationModule.publicInterface?.addComponent(component)
//                            }
//                        }
//
//                    case .finish(let task):
//                        self.navigationController.popViewController(animated: true)
//                        self.packageInformationModule.publicInterface?.addTask(task)
//                        break
//
//                    default: break
//                    }
//                }
//
//                self.navigationController.pushViewController(module.view, animated: true)
//                self.taskInformationModule = module
                
//            case .finish(let package):
//                self.completion?(.finish(package))
                
          
            }
        }
        navigationController.pushViewController(packageInformationModule.view, animated: false)
        navigationController.setToolbarHidden(false, animated: false)
    }
}
