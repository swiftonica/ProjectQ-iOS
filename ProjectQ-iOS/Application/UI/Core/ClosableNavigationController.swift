//
//  ClosableNavigationController.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 20.02.2023.
//

import Foundation
import UIKit

class ClosableNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        let item = UIBarButtonItem(
            systemItem: .close,
            primaryAction: UIAction(handler: {
                [weak self] _ in
                self?.dismiss(animated: true)
            }),
            menu: nil)
        viewController.navigationItem.leftBarButtonItem = item
    }
}
