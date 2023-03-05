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
}

class PackageInformationPresenter: AssemblablePresenter, PackageInformationPublicInterface {
    typealias ViewType = PackageInformationView
    var interfaceContract: ViewType.InterfaceContractType!
    
    var eventOutputHandler: ((PackageInformationView.EventOutputType) -> Void) {
        return {
            _ in
        }
    }
    
    required init() {
        package = .init(tasks: [], name: "")
    }
    
    init(package: TaskPackage) {
        self.package = package
    }
    
    func start() {
        interfaceContract.setPackageName(package.name)
        interfaceContract.showTasks(package.tasks)
    }
    
    private let package: TaskPackage
    
    private var tasks: Tasks = []
    
    func addTask(_ task: Task) {
        tasks.append(task)
        SPAlert.present(title: "Success", message: "Has added your fresh-new task", preset: .done)
        interfaceContract.showTasks(tasks)
    }
}


