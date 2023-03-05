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
    @Published var selectedComponent: Component?
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
        case didChooseComponent(Component)
    }
    
    enum EventOutputEventType {
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
    @State private var selectedCompnent: HashableComponent? = nil
}

private extension ComponentsView {
    func ComponentCell(_ component: Component) -> some View {
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
        SwiftUI.List(selection: $selectedCompnent) {
            ForEach(_viewModel.components.hashableCompnents, id: \.self) {
                hashableComponent in
                ComponentCell(hashableComponent.component)
            }
        }
        .onChange(of: selectedCompnent) { s in
            completion?(.didChooseComponent(selectedCompnent!.component))
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
