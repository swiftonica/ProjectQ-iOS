//
//  ComponentsCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 02.03.2023.
//

import Foundation
import NavigationLayer
import UIKit
import ProjectQ_Components
import ModuleAssembler
import SPAlert

class ComponentsCoordinator: Coordinatable {
    enum _ReturnData {
        case didChooseComponent(Component)
    }
    
    var completion: ((_ReturnData) -> Void)?
    
    func start() {
        let componentsModule = ComponentsModule().module
        componentsModule.view.rootView.completion = {
            [unowned self] event in
            switch event {
            case .didChooseComponent(let component):
                guard let module = component.module else {
                    SPAlert.present(title: "Error", message: "Component Screen is not exist", preset: .error)
                    break
                }
                self.navigationController.pushViewController(module.view, animated: true)
                self.keeper.keepModule(module, forKey: "temp")
                
                var view = module.view
                view.didReturnComponent = {
                    component in
                    self.completion?(.didChooseComponent(component))
                }
                
            default: break
            }
        }
        keeper.keepModule(componentsModule, forKey: "components")
        navigationController.pushViewController(componentsModule.view, animated: isAnimated)
    }
    
    var childCoordinators: [NavigationLayer.CompletionlessCoordinatable] = []
    
    init(
        navigationController: UINavigationController = UINavigationController(),
        isAnimated: Bool = true
    ) {
        self.isAnimated = isAnimated
        self.navigationController = navigationController
    }
    
    private let isAnimated: Bool
    private let navigationController: UINavigationController
    private var keeper = ModuleKeeper<String>()
}
