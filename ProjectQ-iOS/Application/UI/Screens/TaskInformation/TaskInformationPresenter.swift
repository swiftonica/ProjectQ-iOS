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

class TaskInformationModule: SUIAssembler2<
    TaskInformationView, TaskInformationPresenter, TaskInformationPresenter
> {
    init(task: Task) {
        let presenter = TaskInformationPresenter(task: task)
        super.init(TaskInformationView(), presenter, presenter)
    }
}

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
                
            case .didDeleteComponentAtIndex(let index):
                self.components.remove(at: index)
                self.interfaceContract.displayCompnents(self.components)
                
            default: break
            }
        }
    }
    
    var interfaceContract: TaskInformationView.InterfaceContractType!
    
    func start() {
        interfaceContract.displayCompnents(components)
        interfaceContract.displayTaskName(packageName)
    }
    
    required init() {}
            
    init(task: Task) {
        self.packageName = task.name
        self.components = task.components
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
