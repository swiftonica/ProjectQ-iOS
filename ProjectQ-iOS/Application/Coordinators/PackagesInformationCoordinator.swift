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
        case package(TaskPackage)
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
        case packageInfromation
        case components
    }
    
    private var keeper = ModuleKeeper<Modules>()
}

private extension PackagesInformationCoordinator {
    @objc func packageInfomartionDoneDidTap() {
        
    }
    
    func addTaskDidTap() {
        
    }
    
    @objc func doneDidTap() {
        
    }
    
    func addPackageInformationModule() {
        let assembler = PackageInformationModule(package: package)
        let module = assembler.module
        
        module.view.navigationItem.rightBarButtonItem = .init(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(self.doneDidTap)
        )
        
        module.view.rootView.completion = {
            event in
            switch event {
            case .addTask:
                var view = TaskInformationView()
                view.completion = {
                    event in
                    switch event {
                    case .addComponent:
                        let module = ComponentsModule().module
                        self.keeper.keepModule(module, forKey: .components)
                        self.navigationController.pushViewController(module.view, animated: true)
                        module.view.rootView.completion = {
                            event in
                            switch event {
                            case .didChooseComponent(let component):
                                let componentModule = Component.iOSModules
                            }
                        }
                        
                    default: break
                    }
                }
                
                self.navigationController.pushViewController(UIHostingController(rootView: view), animated: true)
                
            default: break
            }
        }
        navigationController.pushViewController(module.view, animated: false)
        navigationController.setToolbarHidden(false, animated: false)
    }
}
