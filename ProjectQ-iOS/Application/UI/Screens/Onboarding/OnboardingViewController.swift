//
//  OnboardingViewController.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 27.04.2023.
//

import SwiftUI
import SwiftyGif
import SnapKit
import UIKit

struct PageViewController: UIViewControllerRepresentable {
    let gifName: String
    let title1: String
    let title2: String
    
    func makeUIViewController(context: Context) -> OnboardingPageViewController {
        return OnboardingPageViewController(gifName: gifName, title1: title1, title2: title2)
    }
    
    func updateUIViewController(_ pageViewController: OnboardingPageViewController, context: Context) {}
}

struct OnboardingView: View {
    init() {
        UIPageControl.appearance().backgroundColor = .secondarySystemFill
    }
    
    var body: some View {
        TabView {
            PageViewController(gifName: "onboarding1_1-pic", title1: "Connect package", title2: "Long press to call menu")
            PageViewController(gifName: "onboarding1_2-pic", title1: "Send package", title2: "To Notification Bot")
            PageViewController(gifName: "onboarding2-pic", title1: "Type add", title2: "As a reply. Type help to show all commands")
            PageViewController(gifName: "onboarding3", title1: "Receive notifications", title2: "Bot sends you a message with task information")
        }
        .tabViewStyle(
            .page
        )
    }
}

