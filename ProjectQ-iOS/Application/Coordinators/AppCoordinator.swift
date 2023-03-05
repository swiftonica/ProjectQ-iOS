//
//  AppCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 17.02.2023.
//

import Foundation
import NavigationLayer
import UIKit
import NativeSettingsViewController
import ProjectQ_Components
import ModuleAssembler
import SwiftUI
import SPAlert

class AppCoordinator: CompletionlessCoordinatable {
    var childCoordinators: [CompletionlessCoordinatable] = []
    var completion: (() -> Void)?
    
    func start() {
        configureNavigationController()
        navigationController.setViewControllers([packagesModule.view], animated: false)
        packagesModule.view.completion = { [unowned self] in
            switch $0 {
            case .didSelectPackage(let package):
                self.showPackagesInformationCoordinator(package: package)
                
            case .didSelectAtIndex(let index):
                self.selectedPackageIndex = index // [!] <- set state
                
            default: break
            }
        }
    }

    private var keeper = ModuleKeeper<String>()
    private let packagesModule = PackagesModule().module
    private(set) var navigationController = UINavigationController()
    
    // state
    private var selectedPackageIndex: Int = 0
}

private extension AppCoordinator {
    @objc func settingsDidtap() {
        let nativeSettingsViewController = NativeSettingsViewController(dataSource: self)
        nativeSettingsViewController.modalPresentationStyle = .overCurrentContext
        let nvc = ClosableNavigationController(rootViewController: nativeSettingsViewController)
        nvc.modalPresentationStyle = .overCurrentContext
        navigationController.present(
            nvc,
            animated: true
        )
    }
    
    @objc func plusDidTap() {
        let alertController = UIAlertController(
            title: "Enter Package Name",
            message: "Please enter your text below",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "For Example: Morning Routine"
            textField.keyboardType = .default
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard
                let textField = alertController.textFields?.first,
                let text = textField.text
            else {
                return
            }
            
            if text.isEmpty {
                return SPAlert.present(title: "Error", message: "Package name is empty", preset: .error)
            }
            
            self.packagesModule.publicInterface?.addPackage(TaskPackage(tasks: [], name: text))
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(.init(title: "Cancel", style: .cancel))
        self.navigationController.present(alertController, animated: true, completion: nil)
    }
    
    func configureNavigationController() {
        let settings = UIBarButtonItem(
            image: UIImage(systemName: "gearshape")!,
            style: .plain,
            target: self,
            action: #selector(settingsDidtap)
        )
        packagesModule.view.navigationItem.leftBarButtonItems = [settings]
        packagesModule.view.toolbarItems = [
            .init(title: "New Package", style: .done, target: self, action: #selector(plusDidTap)),
            .init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        ]
    }
    
    func showPackagesInformationCoordinator(package: TaskPackage) {
        let coordinator = PackagesInformationCoordinator(package: package)
        coordinator.completion = {
            event in
            switch event {
            case .finish(let package):
                coordinator.navigationController.dismiss(animated: true)
                self.packagesModule.publicInterface?.updatePackage(at: self.selectedPackageIndex, package: package)
            }
        }
        self.add(coordinatable: coordinator)
        navigationController.present(
            coordinator.navigationController,
            animated: true
        )
        coordinator.start()
    }
}

extension AppCoordinator: NativeSettingsViewControllerDataSource {
    func nativeSettingsViewController(
        _ viewController: NativeSettingsViewController
    ) -> [NativeSettingsSection] {
        return [
            .init(headerTitle: "", footerTitle: "", rows: [
                .aboutApp(), .support()
            ])
        ]
    }
    
    func nativeSettingsViewController(
        _ viewController: NativeSettingsViewController,
        shouldShowIndicator for: IndexPath
    ) -> Bool {
        return true
    }
}
