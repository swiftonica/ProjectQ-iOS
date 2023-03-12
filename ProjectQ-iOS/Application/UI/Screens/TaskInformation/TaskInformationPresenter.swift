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
    
    init(view: TaskInformationView, task: Task) {
        let presenter = TaskInformationPresenter(task: task)
        super.init(view, presenter, presenter)
    }
}

protocol TaskInformationModulePublicInterface {
    func addComponent(_ component: Component)
    func updateComponent(_ component: Component, at index: Int)
    
    func setComponents(_ components: Components)
}

class TaskInformationPresenter: AssemblablePresenter {
    typealias ViewType = TaskInformationView
    
    var eventOutputHandler: ((TaskInformationView.EventOutputType) -> Void) {
        return {
            [self] event in
            switch event {
            case .didTapDone:
                if components.isEmpty {
                    SPAlert.present(title: "Add at least one Appear Compnent", preset: .error)
                    break
                }
                
                if taskName.isEmpty {
                    SPAlert.present(title: "Enter task's name, please", preset: .error)
                    break
                }
                
                let task = Task(name: self.taskName, baseComponents: self.components.baseComponents)
                interfaceContract.endModule(task: task)
                
            case .didChangeName(let newValue):
                self.taskName = newValue
                
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
        interfaceContract.displayTaskName(taskName)
    }
    
    required init() {}
            
    init(task: Task) {
        self.taskName = task.name
        self.components = task.components
    }
    
    private var taskName: String = ""
    private var components: Components = []
}

extension TaskInformationPresenter: TaskInformationModulePublicInterface {
    func addComponent(_ component: Component) {
        self.components.append(component)
        self.interfaceContract.displayCompnents(components)
        SPAlert.present(title: "Success", message: "Have added component to you task", preset: .done)
    }
    
    func updateComponent(_ component: Component, at index: Int) {
        self.components.remove(at: index)
        self.components.insert(component, at: index)
        self.interfaceContract.displayCompnents(components)
        SPAlert.present(title: "Success", message: "Have added component to you task", preset: .done)
    }
    
    func setComponents(_ components: Components) {
        self.components.removeAll()
        self.components = components
        self.interfaceContract.displayCompnents(components)
    }
}
