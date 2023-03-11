//
//  ProjectQ-Components+Extesnsion.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 01.03.2023.
//

import Foundation
import ProjectQ_Components
import UIKit
import ModuleAssembler

protocol ViewComponentReturnable {
    var didReturnComponent: ((Component) -> Void)? { get set }
    func configureData(_ data: Data)
}

struct HashableComponent: Hashable {
    var component: Component
    
    init(component: Component) {
        self.component = component
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    var identifier: String {
        return String(self.component.information.componentId.id)
    }
    
    public static func == (lhs: HashableComponent, rhs: HashableComponent) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension Component {
    var hashableComponent: HashableComponent {
        return HashableComponent(component: self)
    }
}

extension Array where Element: Component {
    var hashableCompnents: [HashableComponent] {
        return self.map { $0.hashableComponent }
    }
}
   
extension Component {
    var module: Module<ViewComponentReturnable & UIViewController, AnyObject, Any>? {
        switch self {
        case .interval:
            let view = IntervalViewController()
            if let data = self.input {
                view.configureData(data)
            }
            return Module(
                view: view,
                presenter: EmptyPresenter(),
                publicInterface: nil
            )
            
        default: return nil
        }
    }
}

extension Task {
    static let empty = Task(name: "", baseComponents: [])
}
