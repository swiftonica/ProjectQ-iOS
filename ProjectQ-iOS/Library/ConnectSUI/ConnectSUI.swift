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
    public typealias EventOutputReturnType = ViewType.EventOutputType
    
    public var eventOutput: ((ViewType.EventOutputType) -> Void)? {
        didSet {
            self.rootView.eventOutput = eventOutput
        }
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isAppeared { return }
        isAppeared = true
        configurator?()
    }
    
    var configurator: (() -> Void)?
    
    private var isAppeared = false
}

public class SUIAssembler<
    _ViewType: AssemblableView & View,
    PresenterType: AssemblablePresenter,
    PublicInterfaceType
>: Assemblable {
    public typealias ViewType = AssemblableUIHostingViewController<_ViewType>
    
    public var currentView: ViewType!
    public var currentPresenter: PresenterType!
    
    public var view: AssemblableUIHostingViewController<_ViewType> {
        return AssemblableUIHostingViewController(rootView: _ViewType())
    }
    
    public var suiView: _ViewType {
        return _ViewType()
    }
    
    public var module: Module<AssemblableUIHostingViewController<_ViewType>, PresenterType, PublicInterfaceType> {
        let _view = self.view
        let _presenter = self.presenter
        self.currentView = _view
        self.currentPresenter = _presenter
        if let eventOutput = _presenter.eventOutputHandler as? (ViewType.EventOutputReturnType) -> Void {
            _view.eventOutput = eventOutput
        }
        if let interfaceContract = _view.rootView as? PresenterType.ViewType.InterfaceContractType {
            _presenter.interfaceContract = interfaceContract
        }
        _presenter.start()
        return Module(
            view: _view,
            presenter: _presenter,
            publicInterface: self.publicInterface
        )
    }
}

public class SUIAssembler2<
    _ViewType: AssemblableView & View,
    PresenterType: AssemblablePresenter,
    PublicInterfaceType
>: Assemblable {
    public typealias ViewType = AssemblableUIHostingViewController<_ViewType>
    
    public var currentView: ViewType!
    public var currentPresenter: PresenterType!
    
    private let _view: ViewType
    private let _presenter: PresenterType
    private let _publicInterface: PublicInterfaceType
    
    init(_ _view: _ViewType, _ _presenter: PresenterType, _ _publicInterface: PublicInterfaceType) {
        self._view = .init(rootView: _view)
        self._presenter = _presenter
        self._publicInterface = _publicInterface
    }
    
    public var module: Module<
        AssemblableUIHostingViewController<_ViewType>,
        PresenterType,
        PublicInterfaceType
    > {
        if let eventOutput = _presenter.eventOutputHandler as? (ViewType.EventOutputReturnType) -> Void {
            _view.eventOutput = eventOutput
        }
        if let interfaceContract = _view.rootView as? PresenterType.ViewType.InterfaceContractType {
            _presenter.interfaceContract = interfaceContract
        }
        _presenter.start()
        return Module(
            view: _view,
            presenter: _presenter,
            publicInterface: _publicInterface
        )
    }
}
