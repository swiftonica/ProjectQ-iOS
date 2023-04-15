//
//  ComponentsPresenter.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 27.02.2023.
//

import Foundation
import ModuleAssembler
import ProjectQ_Components2

protocol ComponentsModulePublicInterface {}

class ComponentsPresenter: AssemblablePresenter {
    typealias ViewType = ComponentsView
    
    var interfaceContract: ComponentsView.InterfaceContractType!
    
    var eventOutputHandler: ((ComponentsView.EventOutputEventType) -> Void) {
        return { [unowned self] event in
            switch event {
            default: break
            }
        }
    }
    
    func start() {
        let components = Component.allComponents
        interfaceContract.displayComponents(components)
    }
    
    required init() {}
}

extension ComponentsPresenter: ComponentsModulePublicInterface {}
