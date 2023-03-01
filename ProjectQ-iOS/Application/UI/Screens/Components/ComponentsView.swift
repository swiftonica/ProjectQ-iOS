//
//  ComponentsView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 27.02.2023.
//

import SwiftUI
import ModuleAssembler
import NavigationLayer
import ProjectQ_Components

class ComponentsViewModel: ObservableObject {
    @Published var components: Components = []
}

protocol ComponentsViewPublicInterface {}

protocol ComponentsViewInterfaceContract {
    func displayComponents(_ components: Components)
}

struct ComponentsView: View, AssemblableView, Completionable {
    typealias InterfaceContractType = ComponentsViewInterfaceContract
    
    var eventOutput: ((EventOutputEventType) -> Void)?
    var completion: ((DelegateEventType) -> Void)?
    
    enum DelegateEventType {
        case lol
    }
    
    enum EventOutputEventType {
        case listOnAppear
        case didTapClickMe
    }
    
    var body: some View {
        if _viewModel.components.isEmpty {
            EmptyView()
        }
        else {
            List()
        }
    }

    @ObservedObject private var _viewModel = ComponentsViewModel()
}

private extension ComponentsView {
    func ComponentCell(_ component: Component) -> some View {
        Text(component.information.name)
            .frame(height: 100)
    }
    
    func EmptyView() -> some View {
        Text("No Components")
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .center)
            .multilineTextAlignment(.center)
            .font(.system(size: 23, weight: .bold))
            .foregroundColor(.secondary)
    }
    
    func List() -> some View {
        SwiftUI.List {
            ForEach(0..<_viewModel.components.count, id: \.self) { each in
                ComponentCell(_viewModel.components[each])
            }
            
            Button("click me", action: {
                self.eventOutput?(.didTapClickMe)
            })
        }
        .onAppear() {
            self.eventOutput?(.listOnAppear)
        }
    }
}

extension ComponentsView: ComponentsViewInterfaceContract {
    func displayComponents(_ components: Components) {
        _viewModel.components.append(contentsOf: components)
    }
}

struct ComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsView()
    }
}
