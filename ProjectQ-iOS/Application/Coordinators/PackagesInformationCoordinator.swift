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
    private(set) var navigationController = ClosableNavigationController().all()
    private let package: TaskPackage
    
    private enum Modules {
        case packageInfromation
    }
    
    private var keeper = ModuleKeeper<Modules>()
}


extension View {
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

private extension PackagesInformationCoordinator {
    @objc func packageInfomartionDoneDidTap() {
        
    }
    
    @objc func addComponentDidTap() {
        
    }
    
    func addPackageInformationModule() {
        let assembler = PackageInformationModule()
        let module = assembler.module
        module.view.configurator = {
            module.view.navigationItem.rightBarButtonItem = .init(
                barButtonSystemItem: .done,
                target: self,
                action: #selector(self.addComponentDidTap)
            )
            
            module.view.setToolbarItems([
                .init(
                    title: "Add Task",
                    style: .plain,
                    target: self,
                    action: #selector(self.addComponentDidTap)
                ),
                .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                .init(
                    title: "Edit",
                    style: .plain,
                    target: self,
                    action: #selector(self.addComponentDidTap)
                ),
            ], animated: false)
        }
        navigationController.pushViewController(module.view, animated: false)
        navigationController.setToolbarHidden(false, animated: false)
    }
}

struct Test2: View {
    var body: some View {
        List {
            Text("Hello")
            Text("Hello")
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("hello from button", action: {
                    // Your button action goes here
                }) 
            }
        }
    }
}

class Test: UIViewController {
    @objc func addComponentDidTap() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
