//
//  TaskInformationCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 06.03.2023.
//

import Foundation
import ProjectQ_Components
import NavigationLayer
import UIKit
import ModuleAssembler
import SPAlert

class TaskInformationCoordinator: Coordinatable {
    typealias ReturnData = _ReturnType
    
    enum _ReturnType {
        case finsish(Task)
    }
    
    init(task: Task = .empty, navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        
        var view = TaskInformationView()
        view.completion = {
            event in
            switch event {
            case .selectedComponentIndex(let index):
                self.selectedComponentIndex = index // [!] <- set state
                
            case .addComponent:
                self.addComponentCoordinator()
                                            
            case .selectedComponent(let component):
                let module = component.module() {
                    component in
                    self.navigationController.popToViewController(
                        self.taskInformationModule.view,
                        animated: true
                    )
                    self.taskInformationModule.publicInterface?.updateComponent(component, at: self.selectedComponentIndex)
                }
                guard let module = module else {
                    SPAlert.present(title: "Error", message: "Screen doesn't exist", preset: .error)
                    break
                }
                self.navigationController.pushViewController(module.view, animated: true)
                
            case .finish(let task):
                self.completion?(.finsish(task))
            }
        }
        
        let module = TaskInformationModule(view: view, task: task).module
        let isMineController = navigationController == nil
        if isMineController {
            self.navigationController = UINavigationController()
            self.navigationController.pushViewController(module.view, animated: false)
        }
        else {
            self.navigationController.pushViewController(module.view, animated: true)
        }
        
        self.taskInformationModule = module
    }
    
    func start() {
            
    }
    
    var completion: ((_ReturnType) -> Void)?
    var childCoordinators: [NavigationLayer.CompletionlessCoordinatable] = []
    
    private var navigationController: UINavigationController!
    
    private var taskInformationModule: Module<
        AssemblableUIHostingViewController<TaskInformationView>,
        TaskInformationPresenter,
        TaskInformationPresenter
    >!
    
    // state
    private var selectedComponentIndex: Int = 0
}

private extension TaskInformationCoordinator {
    func addComponentCoordinator() {
        let componentCoordinator = ComponentsCoordinator(
            navigationController: self.navigationController,
            isAnimated: true
        )
        componentCoordinator.completion = {
            event in
            switch event {
            case .didChooseComponent(let component):
                self.navigationController.popToViewController(
                    self.taskInformationModule.view,
                    animated: true
                )
                self.taskInformationModule.publicInterface?.addComponent(component)
            }
        }
        self.add(coordinatable: componentCoordinator)
        componentCoordinator.start()
    }
}
