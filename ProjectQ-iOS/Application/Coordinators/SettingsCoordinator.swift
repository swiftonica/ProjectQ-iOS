//
//  SettingsCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 16.04.2023.
//

import Foundation
import NavigationLayer
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
        var settingsView = SettingsView()
        settingsView.events.didTapCase = settingsViewControllerDidTap
        let settingsViewController = UIHostingController(rootView: settingsView)
        navigationController.pushViewController(settingsViewController, animated: false)
    }
    
    private func settingsViewControllerDidTap(row: SettingsView.Cell) {
        switch row {
        case .aboutApp:
            navigationController.pushViewController(UIHostingController(rootView: AboutAppView()), animated: true)
            
        case .onboarding:
            let closableNavigationController = ClosableNavigationController(
                rootViewController: UIHostingController(rootView: OnboardingView())
            )
            navigationController.present(closableNavigationController, animated: true)
            
        default: break
        }
    }
}
