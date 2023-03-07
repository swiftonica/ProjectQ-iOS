//
//  PackageInformationPresenter.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 24.02.2023.
//

import Foundation
import ModuleAssembler
import SwiftUI
import ProjectQ_Components
import SPAlert

class PackageInformationModule: SUIAssembler2<
    PackageInformationView,
    PackageInformationPresenter,
    PackageInformationPublicInterface
> {
    init(package: TaskPackage) {
        let view = PackageInformationView()
        let presenter = PackageInformationPresenter(package: package)
        super.init(view, presenter, presenter)
    }
}

protocol PackageInformationPublicInterface {
    func addTask(_ task: Task)
    func updateTask(at index: Int, task: Task)
}

class PackageInformationPresenter: AssemblablePresenter {
    typealias ViewType = PackageInformationView
    var interfaceContract: ViewType.InterfaceContractType!
    
    var eventOutputHandler: ((PackageInformationView.EventOutputType) -> Void) {
        return {
            event in
            switch event {
            case .didDeleteTask(let index):
                self.tasks.remove(at: index)
                self.interfaceContract.removeTask(at: index)
                
            default: break
            }
        }
    }
    
    required init() {
        package = .init(tasks: [], name: "")
    }
    
    init(package: TaskPackage) {
        self.package = package
        self.tasks = package.tasks
    }
    
    func start() {
        interfaceContract.setPackageName(package.name)
        interfaceContract.showTasks(package.tasks)
    }
    
    private let package: TaskPackage
    private var tasks: Tasks = []
}

extension PackageInformationPresenter: PackageInformationPublicInterface {
    func updateTask(at index: Int, task: ProjectQ_Components.Task) {
        tasks.remove(at: index)
        tasks.insert(task, at: index)
        SPAlert.present(
            title: "Success",
            message: "Has added your fresh-new task",
            preset: .done
        )
        interfaceContract.showTasks(tasks)
    }
    
    func addTask(_ task: Task) {
        tasks.append(task)
        SPAlert.present(
            title: "Success",
            message: "Has added your fresh-new task",
            preset: .done
        )
        interfaceContract.showTasks(tasks)
    }
}
