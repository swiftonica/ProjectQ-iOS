//
//  SettingsCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 16.04.2023.
//

import Foundation
import UIKit
import NavigationLayer
import NativeSettingsViewController
import SwiftUI

class SettingsCoordinator: Coordinatable {
    enum _ReturnData {
        case finish
    }

    var completion: ((_ReturnData) -> Void)?

    func start() {
        addSettings()
    }

    var childCoordinators: [CompletionlessCoordinatable] = []
    let navigationController = ClosableNavigationController().onlyFirst()
}

private extension SettingsCoordinator {
    func addSettings() {
        let nativeSettingsViewController = NativeSettingsViewController(dataSource: self)
        nativeSettingsViewController.delegate = self
        navigationController.pushViewController(nativeSettingsViewController, animated: false)
    }
}

extension SettingsCoordinator: NativeSettingsViewControllerDelegate, NativeSettingsViewControllerDataSource {
    func nativeSettingsViewController(
        _ viewController: NativeSettingsViewController
    ) -> [NativeSettingsSection] {
        return [
            .init(headerTitle: "", footerTitle: "", rows: [
                .aboutApp()
            ])
        ]
    }

    func nativeSettingsViewController(
        _ viewController: NativeSettingsViewController,
        shouldShowIndicator for: IndexPath
    ) -> Bool {
        return true
    }

    func nativeSettingsViewController(
        _ viewController: NativeSettingsViewController,
        didSelect row: NativeSettingsRow
    ) {
        switch row {
        case .aboutApp():
            navigationController.pushViewController(UIHostingController(rootView: AboutAppView()), animated: true)
            break
        default: break
        }
    }
}
