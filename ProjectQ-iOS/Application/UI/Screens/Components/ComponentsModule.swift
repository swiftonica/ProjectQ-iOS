//
//  ComponentsModule.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 27.02.2023.
//

import Foundation

class ComponentsModule: SUIAssembler2<
    ComponentsView, ComponentsPresenter, ComponentsModulePublicInterface
> {
    init(delegate: @escaping (ComponentsView.DelegateEventType) -> Void) {
        let presenter = ComponentsPresenter()
        var view = ComponentsView()
        view.completion = delegate
        super.init(view, presenter, presenter)
    }
}
