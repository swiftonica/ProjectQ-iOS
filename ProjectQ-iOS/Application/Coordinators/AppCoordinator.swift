//
//  AppCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 17.02.2023.
//

import Foundation
import NavigationLayer
import UIKit
import ProjectQ_Components2
import ModuleAssembler
import SwiftUI
import SPAlert
import BackupService

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
                
            case .didSelectIndex(let index):
                self.selectedPackageIndex = index // [!] <- set state
                
            case .didEditPackage(let package):
                self.showPackagesInformationCoordinator(package: package)
                
            case .didConnect(let package):
                let backupService = BackupService(for: package.codablePackage)
                switch backupService.backup() {
                case .success(let url):
                    self.showActivityController(url) {
                        if let error = backupService.removeFile() {
                            SPAlert.present(message: error.localizedDescription, haptic: .error)
                        }
                    }
                case .failure(let error):
                    SPAlert.present(message: error.localizedDescription, haptic: .error)
                    break
                }
                
            default: break
            }
        }
    }

    private var keeper = ModuleKeeper<String>()
    private let packagesModule = PackagesModule().module
    private(set) var navigationController = UINavigationController()
    private let isNotFirstOnboaringKey = "is_first_onboarding_key"
    
    // state
    private var selectedPackageIndex: Int = 0
}

private extension AppCoordinator {
    func showActivityController(_ url: URL, completion: @escaping () -> Void) {
        let files: [URL] = [url]
        
        let activityViewController = UIActivityViewController(
            activityItems: files,
            applicationActivities: nil)

        activityViewController.completionWithItemsHandler = {
            activityType, completed, returnedItems, error in
            completion()
        }
        
        navigationController.present(activityViewController, animated: true)
    }
    
    @objc func settingsDidtap() {
        let settingsCoordinator = SettingsCoordinator()
        settingsCoordinator.navigationController.modalPresentationStyle = .overCurrentContext
        self.add(coordinatable: settingsCoordinator)
        navigationController.present(
            settingsCoordinator.navigationController,
            animated: true
        )
        settingsCoordinator.start()
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
                return SPAlert.present(
                    title: "Error",
                    message: "Package name is empty",
                    preset: .error
                )
            }
            
            self.packagesModule.publicInterface?.addPackage(Package(name: text, tasks: []))
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
    
    func showPackagesInformationCoordinator(package: Package) {
        let coordinator = PackagesInformationCoordinator(package: package)
        coordinator.completion = {
            event in
            switch event {
            case .finish(let package):
                coordinator.navigationController.dismiss(animated: true, completion: {
                    let isFirstOnboarding = UserDefaults.standard.bool(forKey: self.isNotFirstOnboaringKey)
                    if !isFirstOnboarding {
                        let vc = UIHostingController(rootView: OnboardingView())
                        self.navigationController.present(ClosableNavigationController(rootViewController: vc), animated: true)
                        UserDefaults.standard.set(true, forKey: self.isNotFirstOnboaringKey)
                    }
                })
                self.packagesModule.publicInterface?.updatePackage(
                    at: self.selectedPackageIndex,
                    package: package
                )
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
