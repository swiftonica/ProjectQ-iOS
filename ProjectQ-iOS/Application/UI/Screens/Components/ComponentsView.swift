//
//  ComponentsView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 27.02.2023.
//

import ModuleAssembler
import NavigationLayer
import ProjectQ_Components2
import SwiftUI

class ComponentsViewModel: ObservableObject {
    @Published var components: [Component] = []
    @Published var selectedComponent: Component?
}

protocol ComponentsViewPublicInterface {}

protocol ComponentsViewInterfaceContract {
    func displayComponents(_ components: [Component])
}

struct ComponentsView: View, AssemblableView, Completionable {
    typealias InterfaceContractType = ComponentsViewInterfaceContract
    
    var eventOutput: ((EventOutputEventType) -> Void)?
    var completion: ((DelegateEventType) -> Void)?
    
    enum DelegateEventType {
        case didChooseComponent(Component)
    }
    
    enum EventOutputEventType {
        case didTapClickMe
    }
    
    var body: some View {
        if _viewModel.components.isEmpty {
            EmptyView()
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("", action: {})
                    }
                }
        }
        else {
            ComponentList()
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Button("", action: {})
                    }
                }
        }
    }

    @ObservedObject private var _viewModel = ComponentsViewModel()
}

private extension ComponentsView {
    func ComponentCell(_ component: Component, onTapGesture: @escaping () -> Void) -> some View {
        ZStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(component.information.name)
                        .font(.headline)
                    Text(component.handlerType.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            Button("") {
                onTapGesture()
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
    
    func ComponentList() -> some View {
        List(
            _viewModel.components.hashableCompnents,
            id: \.self
        ) {
            hashableComponent in
            ComponentCell(hashableComponent.component) {
                completion?(
                    .didChooseComponent(hashableComponent.component)
                )
            }
        }
    }
}

extension ComponentsView: ComponentsViewInterfaceContract {
    func displayComponents(_ components: [Component]) {
        _viewModel.components.append(contentsOf: components)
    }
}

struct ComponentsView_Previews: PreviewProvider {
    static var previews: some View {
        ComponentsView()
    }
}
