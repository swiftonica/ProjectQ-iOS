//
//  PackagesInformationCoordinator.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import NavigationLayer
import ProjectQ_Components
import UIKit
import SwiftUI

class PackagesInformationCoordinator: Coordinatable {
    enum _ReturnData {
        case package(TaskPackage)
    }
    
    var completion: ((_ReturnData) -> Void)?
    
    func start() {
        let vc = UIViewController()
        vc.view.backgroundColor = .red
        navigationController.setViewControllers([vc], animated: false)
        
        let view = UIHostingController(rootView: PackageInformationView())
    }
    
    var childCoordinators: [CompletionlessCoordinatable] = []
    private(set) var navigationController = UINavigationController()
}
