//
//  TaskInformationPresenter.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 02.03.2023.
//

import Foundation
import ModuleAssembler
import ProjectQ_Components
import SPAlert

protocol TaskInformationModulePublicInterface {
    func addComponent(_ component: Component)
}

class TaskInformationPresenter: AssemblablePresenter {
    typealias ViewType = TaskInformationView
    
    var eventOutputHandler: ((TaskInformationView.EventOutputType) -> Void) {
        return {
            [unowned self] event in
            switch event {
            case .didTapDone:
                if components.isEmpty {
                    SPAlert.present(title: "Add at least one Appear Compnent", preset: .error)
                    break
                }
                
                if packageName.isEmpty {
                    SPAlert.present(title: "Enter task's name, please", preset: .error)
                    break
                }
                
            case .didChangeName(let newValue):
                self.packageName = newValue
                
            default: break
            }
        }
    }
    
    var interfaceContract: TaskInformationView.InterfaceContractType!
    
    func start() {
            
    }
    
    required init() {
        
    }
    
    private var packageName: String = ""
    private var components: Components = []
}

extension TaskInformationPresenter: TaskInformationModulePublicInterface {
    func addComponent(_ component: Component) {
        self.components.append(component)
        self.interfaceContract.addComponent(component)
        SPAlert.present(title: "Success", message: "Have added component to you task", preset: .done)
    }
}
