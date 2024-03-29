//
//  TaskInformation.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 26.02.2023.
//

import SwiftUI
import Combine
import ProjectQ_Components2
import ModuleAssembler
import NavigationLayer

protocol TaskInformationInterfaceContract {
    func addComponent(_ component: Component)
    func displayTaskName(_ name: String)
    func displayCompnents(_ components: [Component])
    func endModule(task: Task)
}

fileprivate class TaskInformationViewViewModel: ObservableObject {
    @Published var components: [Component] = []
    @Published var taskName: String = ""
}

struct TaskInformationView: View, AssemblableView, Completionable {
    typealias InterfaceContractType = TaskInformationInterfaceContract
    
    enum EventOutputType {
        case didTapDone
        case didChangeName(String)
        
        case didDeleteComponentAtIndex(Int)
    }
    
    enum DelegateEventType {
        case finish(Task)
        case addComponent
        
        case selectedComponent(Component)
        case selectedComponentIndex(Int)
    }
    
    var eventOutput: ((EventOutputType) -> Void)?
    var completion: ((DelegateEventType) -> Void)?
    
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
            Button("Add Component", action: {
                self.completion?(.addComponent)
            }).font(.system(size: 16, weight: .medium))
            Spacer()
            Button("Done", action: {
                self.eventOutput?(.didTapDone)
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
    
    func Section2(components: [Component]) -> some View {
        Section(
            header: Text("Components")
        ) {
            if components.isEmpty {
                EmptyView()
            }
            else {
                ForEach(0 ..< components.count, id: \.self) { each in
                    ComponentCell(components[each], index: each)
                }
                .onDelete(perform: deleteAction)
            }
        }
    }
    
    func EmptyView() -> some View {
        Text("No Components")
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .font(.system(size: 23, weight: .bold))
            .foregroundColor(.secondary)
    }
    
    func ComponentCell(_ component: Component, index: Int) -> some View {
        ZStack {
            Button("") {
                completion?(.selectedComponent(component))
                completion?(.selectedComponentIndex(index))
            }
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(component.information.name)
                        .font(.headline)
                    Text(component.uiDescription)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
        }
    }
    
    func deleteAction(_ indexSet: IndexSet) {
        let index = Int(indexSet.first!)
        eventOutput?(.didDeleteComponentAtIndex(index))
    }
}

extension TaskInformationView: TaskInformationInterfaceContract {
    func displayTaskName(_ name: String) {
        viewModel.taskName = name
    }
    
    func displayCompnents(_ components: Components) {
        viewModel.components.removeAll()
        viewModel.components = components
    }
    
    func addComponent(_ component: Component) {
        viewModel.components.append(component)
    }
    
    func endModule(task: Task) {
        self.completion?(
            .finish(task)
        )
    }
}

struct TaskInformationView_Previews: PreviewProvider {
    static var previews: some View {
        TaskInformationView()
    }
}
