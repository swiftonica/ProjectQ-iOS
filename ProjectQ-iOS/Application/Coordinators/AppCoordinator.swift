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

class AppCoordinator: CompletionlessCoordinatable {
    var childCoordinators: [CompletionlessCoordinatable] = []
    var completion: (() -> Void)?
    
    func start() {
        configureNavigationController()
        navigationController.setViewControllers([packagesModule.view], animated: false)
        packagesModule.view.completion = {
            switch $0 {
            case .didSelectPackage(let package):
                let _module = SUIAssembler<
                    PackageInformationView,
                    PackageInformationPresenter,
                    PackageInformationPublicInterface
                >().module
                self.navigationController.pushViewController(_module.view, animated: true)
                    
            default: break
            }
        }
    }

    private var packageInformationModule: Module.void!
    private let packagesModule = PackagesModule().module
    
    private(set) var navigationController = UINavigationController()
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
            title: "jeytery Text",
            message: "Please enter your text below",
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = "Text"
            textField.keyboardType = .default
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard
                let textField = alertController.textFields?.first,
                let text = textField.text
            else {
                return
            }
            self.packagesModule.publicInterface?.addPackage(TaskPackage(tasks: [], name: text))
        }
        
        alertController.addAction(saveAction)
        self.navigationController.present(alertController, animated: true, completion: nil)
    }
    
    func configureNavigationController() {
        let settings = UIBarButtonItem(
            image: UIImage(systemName: "gearshape")!,
            style: .plain,
            target: self,
            action: #selector(settingsDidtap)
        )
        let plus = UIBarButtonItem(
            image: UIImage(systemName: "plus")!,
            style: .plain,
            target: self,
            action: #selector(plusDidTap)
        )
        packagesModule.view.navigationItem.leftBarButtonItems = [settings, plus]
    }
    
    func showPackagesInformationCoordinator() {
        let coordinator = PackagesInformationCoordinator()
        coordinator.completion = {
            event in
            switch event {
            case .package(let package):
                break
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
