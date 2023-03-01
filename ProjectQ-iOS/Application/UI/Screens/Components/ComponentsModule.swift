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
    init() {
        let presenter = ComponentsPresenter()
        super.init(ComponentsView(), presenter, presenter)
    }
}
