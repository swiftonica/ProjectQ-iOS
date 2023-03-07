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

protocol TaskInformationPublicInterface {
    func addComponent(_ component: Component)
    func displayTaskName(_ name: String)
    func displayCompnents(_ components: Components)
}

fileprivate class TaskInformationViewViewModel: ObservableObject {
    @Published var components: Components = []
    @Published var taskName: String = ""
}

struct TaskInformationView: View, AssemblableView, Completionable {
    typealias InterfaceContractType = TaskInformationPublicInterface
    
    enum EventOutputType {
        case didTapDone
        case didChangeName(String)
        
        case didDeleteComponentAtIndex(Int)
    }
    
    enum DelegateEventType {
        case finish(Task)
        case addComponent
    }
    
    var eventOutput: ((EventOutputType) -> Void)?
    var completion: ((DelegateEventType) -> Void)?
    
    lazy var publicInterface: TaskInformationPublicInterface = self
  
    var body: some View {
        List {
            Section1()
            Section2(components: viewModel.components)
        }
        .toolbar {
            ToolBar()
        }
    }
    
    @ObservedObject private var viewModel = TaskInformationViewViewModel()
}

private extension TaskInformationView {
    func ToolBar() -> some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button("Add Component", action: { self.completion?(.addComponent) })
                .font(.system(size: 16, weight: .medium))
            Spacer()
            Button("Done", action: {
                self.eventOutput?(.didTapDone)
                self.completion?(
                    .finish(
                        .init(
                            name: self.viewModel.taskName,
                            baseComponents: viewModel.components.baseComponents
                        )
                    )
                )
            })
        }
    }
    
    func Section1() -> some View {
        Section(
            header: Text("Task's name")
        ) {
            TextField(
                "For example: Go to GYM",
                text: $viewModel.taskName
            )
            .onChange(of: viewModel.taskName) { newValue in
                self.eventOutput?(.didChangeName(newValue))
            }
        }
    }
    
    func Section2(components: Components) -> some View {
        Section(
            header: Text("Components")
        ) {
            if components.isEmpty {
                Text("No Components")
                    .frame(height: 100)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 23, weight: .bold))
                    .foregroundColor(.secondary)
            }
            else {
                ForEach(0..<components.count, id: \.self) { each in
                    Text(components[each].information.name)
                }
                .onDelete(perform: deleteAction)
            }
        }
    }
    
    func deleteAction(_ indexSet: IndexSet) {
        let index = Int(indexSet.first!)
        eventOutput?(.didDeleteComponentAtIndex(index))
    }
}

extension TaskInformationView: TaskInformationPublicInterface {
    func displayTaskName(_ name: String) {
        viewModel.taskName = name
    }
    
    func displayCompnents(_ components: ProjectQ_Components.Components) {
        viewModel.components.removeAll()
        viewModel.components = components
    }
    
    func addComponent(_ component: ProjectQ_Components.Component) {
        viewModel.components.append(component)
    }
}

struct TaskInformationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInformationView()
    }
}
