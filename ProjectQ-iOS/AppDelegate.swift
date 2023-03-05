//
//  AppDelegate.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 16.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private let appCoordinator = AppCoordinator()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = .init(frame: UIScreen.main.bounds)
        window?.rootViewController = appCoordinator.navigationController
        window?.makeKeyAndVisible()
        appCoordinator.start()
        return true
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
