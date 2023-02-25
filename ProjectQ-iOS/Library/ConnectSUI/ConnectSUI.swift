//
//  ConnectSUI.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 24.02.2023.
//

import Foundation
import UIKit
import Combine
import ModuleAssembler
import SwiftUI

public struct OutputEvents<OutputEventsEnumType> {
    var finishPublisher: PassthroughSubject<OutputEventsEnumType, Never>
}

public enum DatelessFinishEventEnum {
    case finished
}

public enum FinishEventEnum<FinishDateType> {
    case finished(FinishDateType)
}

public typealias FinishEvent<FinishDateType> = OutputEvents<FinishEventEnum<DatelessFinishEventEnum>>
public typealias DatelessFinishEvent = FinishEvent<Void>

public class AssemblableUIHostingViewController<
    ViewType: View & AssemblableView
>: UIHostingController<ViewType>, AssemblableView {
    public typealias InterfaceContractType = ViewType.InterfaceContractType
    public typealias EventOutputReturnType = ViewType.EventOutputReturnType
    
    public var eventOutput: ((ViewType.EventOutputReturnType) -> Void)? {
        didSet {
            self.rootView.eventOutput = eventOutput
        }
    }
}

public class SUIAssembler<
    _ViewType: AssemblableView & View,
    PresenterType: AssemblablePresenter,
    PublicInterfaceType
>: Assemblable {
    public typealias ViewType = AssemblableUIHostingViewController<_ViewType>
    
    public var currentView: ViewType!
    public var currentPresenter: PresenterType!
}

