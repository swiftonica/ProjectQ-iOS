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
import SwiftUI

class ComponentableHostingViewController<ViewType: View & ViewComponentReturnable>: UIHostingController<ViewType>, ViewComponentReturnable {
    var didReturnComponent: ((ProjectQ_Components.Component) -> Void)? {
        didSet {
            rootView.didReturnComponent = self.didReturnComponent
        }
    }
    
    func configureData(_ data: Data) {
        rootView.configureData(data)
    }
}

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
    func module(delegate: @escaping (Component) -> Void) -> Module<
        ViewComponentReturnable & UIViewController,
        AnyObject,
        Any
    >? {
        switch self {
        case .interval:
            let view = IntervalViewController()
            view.didReturnComponent = delegate
            if let data = self.input {
                view.configureData(data)
            }
            return Module(
                view: view,
                presenter: EmptyPresenter(),
                publicInterface: nil
            )
            
        case .description:
            let view = ComponentableHostingViewController(rootView: DescriptionComponentView())
            view.rootView.didReturnComponent = delegate
            if let data = self.input {
                view.rootView.configureData(data)
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

extension Component {
    var uiDescription: String {
        switch self.information.componentId {
        case .interval:
            guard
                let _input = self.input,
                let structInput = try? JSONDecoder().decode(IntervalComponentHandlerInput.self, from: _input)
            else {
                return ""
            }
            let date = structInput.time
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let time = "\(components.hour ?? 0):\(components.minute ?? 0)"
            return "Time: \(time), \(structInput.intervalType.uiDescription)"
            
        case .description:
            guard
                let _input = self.input,
                let structInput = try? JSONDecoder().decode(DescriptionComponentHandler.Input.self, from: _input)
            else {
                return ""
            }
            return structInput.description
            
        default: return ""
        }
    }
}

extension IntervalComponentHandlerInput.IntervalType {
    var uiDescription: String {
        switch self {
        case .interval(let interval):
            return "Each \(interval) days"
            
        case .byWeek(let days):
            let string = days.reduce("") {
                result, element in
                if result == "" {
                    return "\(element.name)"
                } else {
                    return "\(result), \(element.name)"
                }
            }
            return "Each " + string
        }
    }
}
