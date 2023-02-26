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
        return AssemblableUIHostingViewController(rootView: self.suiView)
    }
    
    public var suiView: _ViewType {
        return _ViewType()
    }
    
    func module(configurator: (ViewType) -> Void) -> Module<
        ViewType, PresenterType, PublicInterfaceType
    > {
        let _view = self.view
        let _presenter = self.presenter
        self.currentView = _view
        self.currentPresenter = _presenter
        configurator(currentView)
        if let eventOutput = _presenter.eventOutputHandler as? (ViewType.EventOutputReturnType) -> Void {
            _view.eventOutput = eventOutput
        }
        if let interfaceContract = _view as? PresenterType.ViewType.InterfaceContractType {
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

public class DynamicViewSUIAssembler<
    ViewType,
    PresenterType,
    PublicInterfaceType,
    RootAssembler: SUIAssembler<ViewType, PresenterType, PublicInterfaceType>,
    NewViewContent: View
> {
    private(set) var rootAssembler: RootAssembler
    private let content: (RootAssembler.ViewType) -> NewViewContent
    
    init(
        rootAssembler: RootAssembler,
        @ViewBuilder content: @escaping (RootAssembler.ViewType) -> NewViewContent
    ) {
        self.rootAssembler = rootAssembler
        self.content = content
    }
}

struct ConnectToolbarView<ViewType: View & AssemblableView, ToolbarContent: View>: AssemblableView, View {
    typealias EventOutputReturnType = ViewType.EventOutputReturnType
    typealias InterfaceContractType = ViewType.InterfaceContractType
    
    var eventOutput: ((ViewType.EventOutputReturnType) -> Void)?
    
    private(set) var rootView: ViewType
    private var toolbar: ToolbarContent
    
    var body: some View {
        rootView
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    toolbar
                }
            }
    }
    
    init(rootView: ViewType, @ViewBuilder content: @escaping () -> ToolbarContent) {
        self.rootView = rootView
        self.toolbar = content()
        self.eventOutput = rootView.eventOutput
    }
}
