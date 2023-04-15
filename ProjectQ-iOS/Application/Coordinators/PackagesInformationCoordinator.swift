//
//  PackagesInformationCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import NavigationLayer
import ProjectQ_Components2
import UIKit
import SwiftUI
import ModuleAssembler

class PackagesInformationCoordinator: Coordinatable {
    enum _ReturnData {
        case finish(Package)
    }
    
    var completion: ((_ReturnData) -> Void)?
    
    func start() {
        addPackageInformationModule()
    }
    
    init(package: Package) {
        self.package = package
    }
    
    // private
    var childCoordinators: [CompletionlessCoordinatable] = []
    private(set) var navigationController = ClosableNavigationController().onlyFirst()
    private let package: Package
    
    private enum Modules {
        case components
    }
    
    private var keeper = ModuleKeeper<Modules>()
    private var packageInformationModule: Module<
        AssemblableUIHostingViewController<PackageInformationView>,
        PackageInformationPresenter,
        PackageInformationPublicInterface
    >!
    
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
                        self.navigationController.popViewController(animated: true)
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
                
                
            case .finish(let Package):
                self.completion?(.finish(Package))
                
            case .didSelectIndex(let index):
                self.selectedTaskIndex = index // [!] <- set state
                
            }
        }
        navigationController.pushViewController(packageInformationModule.view, animated: false)
        navigationController.setToolbarHidden(false, animated: false)
    }
}
