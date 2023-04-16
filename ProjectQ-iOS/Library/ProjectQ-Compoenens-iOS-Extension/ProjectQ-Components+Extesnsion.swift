//
//  ProjectQ-Components+Extesnsion.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 01.03.2023.
//

import Foundation
import ProjectQ_Components2
import UIKit
import ModuleAssembler
import SwiftUI

class ComponentableHostingViewController<ViewType: View & ViewComponentReturnable>: UIHostingController<ViewType>, ViewComponentReturnable {
    var didReturnComponent: ((Component) -> Void)? {
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
        return String(self.component.id.pureNumber)
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
    func module(delegate: @escaping (Component) -> Void) -> UIViewController? {
        switch self {
        case .interval:
            let view = IntervalViewController()
            view.didReturnComponent = delegate
            view.configureData(self.handler.input)
            return view
            
        case .description:
            let view = ComponentableHostingViewController(rootView: DescriptionComponentView())
            view.rootView.didReturnComponent = delegate
            view.rootView.configureData(self.handler.input)
            return view
            
        case .smallInterval:
            let view = ComponentableHostingViewController(rootView: SmallIntervalView())
            view.rootView.didReturnComponent = delegate
            view.rootView.configureData(self.handler.input)
            return view
            
        default: return nil
        }
    }
}

extension Component {
    var uiDescription: String {
        switch self.id {
        case .interval:
            guard
                let structInput = try? JSONDecoder().decode(
                    IntervalComponentHandlerInput.self,
                    from: self.handler.input
                )
            else {
                return ""
            }
            let date = structInput.time
            let calendar = Calendar.current
            let components = calendar.dateComponents([.hour, .minute], from: date)
            let time = "\(components.hour ?? 0):\(components.minute ?? 0)"
            return "Time: \(time), \(structInput.intervalType.uiDescription)"
            
        case .description:
            guard let structInput = try? JSONDecoder().decode(DescriptionComponentHandlerInput.self, from: self.handler.input) else {
                return ""
            }
            return structInput.description
            
        case .smallInterval:
            guard let structInput = try? JSONDecoder().decode(SmallIntervalComponentHandlerInput.self, from: self.handler.input) else {
                return ""
            }
            return "Each \(structInput.interval) \(structInput.intervalType)"
            
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
            
        default: return "No data..."
        }
    }
}
