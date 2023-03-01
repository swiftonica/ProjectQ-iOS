//
//  TaskInformation.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 26.02.2023.
//

import SwiftUI
import Combine
import ProjectQ_Components
import ModuleAssembler
import NavigationLayer

enum TaskInformationViewState {
    case noResults
    case displaingPackages(Tasks)
}

protocol TaskInformationPublicInterface {
 
}

struct TaskInformationView: View, AssemblableView, Completionable {
    typealias InterfaceContractType = TaskInformationPublicInterface
    
    enum EventOutputReturnType {
        case didDeleteTask(IndexPath)
        case didEnterName(String)
        
        case didShowNoResults
        case didShowContent(Tasks)
    }
    
    enum DelegateEventType {
        case finish(TaskPackage)
        case addComponent
        case done
    }
    
    var eventOutput: ((EventOutputReturnType) -> Void)?
    var completion: ((DelegateEventType) -> Void)?
    
    lazy var publicInterface: TaskInformationPublicInterface = self
    
    @State
    private var username: String = ""
    
    @State
    private var tasks: Tasks = [
        
    ]
    
    var body: some View {
        List {
            Section1()
            Section2(tasks: tasks)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add Component", action: {
                    self.completion?(.addComponent)
                })
                    .font(.system(size: 16, weight: .medium))
                Spacer()
                Button("Done", action: {
                    self.completion?(.done)
                })
            }
        }
    }
    
    private func Section1() -> some View {
        Section(
            header: Text("Task's name")
        ) {
            TextField(
                "For example: Go to GYM",
                text: $username
            )
        }
    }
    
    private func Section2(tasks: Tasks) -> some View {
        Section(
            header: Text("Components")
        ) {
            if tasks.isEmpty {
                Text("No Components")
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

extension TaskInformationView: TaskInformationPublicInterface {    
}

struct TaskInformationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInformationView()
    }
}
