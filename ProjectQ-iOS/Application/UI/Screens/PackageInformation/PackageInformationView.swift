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
import NavigationLayer

fileprivate class PackageInformationViewViewModel: ObservableObject {
    @Published var packageName: String = ""
    @Published var tasks: Tasks = []
}

protocol PackageInformationViewInterfaceContract {
    func setPackageName(_ name: String)
    func showTasks(_ tasks: Tasks)
}

struct PackageInformationView: View, AssemblableView, Completionable {
    
    typealias InterfaceContractType = PackageInformationViewInterfaceContract
    typealias EventOutputType = OutputEventType
    
    enum OutputEventType {
        case didDeleteTask(IndexPath)
        case didEnterName(String)
        
        case didShowNoResults
        case didShowContent(Tasks)
    }
    
    enum DelegateEventType {
        case finish(TaskPackage)
        case addTask
    }
    
    var completion: ((DelegateEventType) -> Void)?
    var eventOutput: ((OutputEventType) -> Void)?
        
    var body: some View {
        List {
            Section1()
            Section2(tasks: viewModel.tasks)
        }
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Add Task", action: {
                    self.completion?(.addTask)
                })
                .font(.system(size: 17, weight: .bold))
                
                Spacer()
                
                Button("Done", action: {
                    let package = TaskPackage(tasks: viewModel.tasks, name: viewModel.packageName)
                    self.completion?(.finish(package))
                })
            }
        }
    }
    
    @ObservedObject
    private var viewModel = PackageInformationViewViewModel()
}

private extension PackageInformationView {
    func Section1() -> some View {
        Section(
            header: Text("Package name")
        ) {
            TextField(
                "For example: Morning Routine",
                text: $viewModel.packageName
            )
        }
    }
    
    func Section2(tasks: Tasks) -> some View {
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
                ForEach(0..<tasks.count, id: \.self) { index in
                    TaskCell(tasks[index])
                }
            }
        }
    }
    
    func TaskCell(_ task: Task) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(task.name)
                    .font(.headline)
                Text("Components: \(task.components.count)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

extension PackageInformationView: PackageInformationViewInterfaceContract {
    func setPackageName(_ name: String) {
        viewModel.packageName = name
    }
    
    func showTasks(_ tasks: Tasks) {
        viewModel.tasks.removeAll()
        viewModel.tasks = tasks
    }
}

struct PackageInformationView_Previews: PreviewProvider {
    static var previews: some View {
        PackageInformationView()
    }
}
