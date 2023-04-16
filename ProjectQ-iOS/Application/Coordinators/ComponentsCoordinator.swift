//
//  ComponentsCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 02.03.2023.
//

import Foundation
import NavigationLayer
import UIKit
import ProjectQ_Components2
import ModuleAssembler
import SPAlert

class ComponentsCoordinator: Coordinatable {
    enum _ReturnData {
        case didChooseComponent(Component)
    }
    
    var completion: ((_ReturnData) -> Void)?
    
    func start() {
        let componentsModule = ComponentsModule() {
            [unowned self] event in
            switch event {
            case .didChooseComponent(let component):
                let componentViewController = component.module(delegate: {
                    component in
                    self.completion?(.didChooseComponent(component))
                })
                
                guard let componentViewController = componentViewController else {
                    SPAlert.present(title: "Error", message: "Component Screen is not exist", preset: .error)
                    break
                }
                
                self.navigationController.pushViewController(componentViewController, animated: true)
            }

        }.module

        navigationController.setToolbarHidden(false, animated: false)
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
