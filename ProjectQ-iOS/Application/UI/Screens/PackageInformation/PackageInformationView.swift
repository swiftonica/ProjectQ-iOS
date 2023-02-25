//
//  PackageInformationView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 24.02.2023.
//

import SwiftUI
import Combine
import ProjectQ_Components
import ModuleAssembler

enum PackageInformationViewState {
    case noResults
    case displaingPackages(Tasks)
}

protocol PackageInformationViewPublicInterface {
    func setState(_ state: PackageInformationViewState)
}

struct PackageInformationView: View, AssemblableView {
    typealias InterfaceContractType = PackageInformationViewPublicInterface
    
    enum EventOutputReturnType {
        case didDeleteTask(IndexPath)
        case didEnterName(String)
        
        case didShowNoResults
        case didShowContent(Tasks)
    }
    
    var eventOutput: ((EventOutputReturnType) -> Void)?
    var delegate = FinishEvent<TaskPackage>(finishPublisher: .init())
    lazy var publicInterface: PackageInformationViewPublicInterface = self
    
    @State
    private var username: String = ""
    
    @State
    private var tasks: Tasks = []
    
    var body: some View {
        List {
            Section1()
            Section2(tasks: tasks)
        }
    }
    
    private func Section1() -> some View {
        Section(
            header: Text("Package name")
        ) {
            TextField(
                "For example: Morning Routine",
                text: $username
            )
        }
    }
    
    private func Section2(tasks: Tasks) -> some View {
        Section(
            header: Text("Tasks")
        ) {
            if tasks.isEmpty {
                Text("No tasks")
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.secondary)
            }
            else {
                ForEach(0..<tasks.count, id: \.self) { each in
                    Text(tasks[each].name)
                }
            }
        }
    }
}

extension PackageInformationView: PackageInformationViewPublicInterface {
    func setState(_ state: PackageInformationViewState) {
        switch state {
        case .noResults: break
        case .displaingPackages(let tasks): break
        }
    }
}

struct PackageInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PackageInformationView()
    }
}
