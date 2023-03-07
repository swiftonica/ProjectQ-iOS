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

class TaskInformationCoordinator: Coordinatable {
    typealias ReturnData = _ReturnType
    
    enum _ReturnType {
        case finsish(Task)
    }
    
    init(task: Task = .empty, navigationController: UINavigationController? = nil) {
        self.navigationController = navigationController
        let module = TaskInformationModule(task: task).module
        
        module.view.rootView.completion = {
            event in
            switch event {
            case .addComponent:
                self.addComponentCoordinator()
                
            case .finish(let task):
                self.completion?(.finsish(task))
            }
        }
        
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
