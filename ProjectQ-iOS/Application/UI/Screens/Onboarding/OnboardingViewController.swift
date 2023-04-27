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
import AVKit

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
    var body: some View {
        TabView {
            PageViewController(gifName: "walker", title1: "Connect package", title2: "Send file to Notification Bot")
            PageViewController(gifName: "walker2", title1: "adffqfqwf", title2: "wdwerfwefrdafggrfqwefrge")
            PageViewController(gifName: "walker3", title1: "adfjefgsfwefrk;adf", title2: "wdadfafdaffwefwefrwefggrrge")
        }
        .tabViewStyle(
            PageTabViewStyle(indexDisplayMode: .automatic)
        )
    }
}

class OnboardingPageViewController: UIViewController {
    init(gifName: String, title1: String, title2: String) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .systemBackground
        
        guard let gifImage = try? UIImage(gifName: gifName) else {
            return
        }
        
        let imageView = UIImageView(gifImage: gifImage)
        view.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(UIScreen.main.bounds.width - 40)
            $0.height.equalTo((UIScreen.main.bounds.width - 40) * 1.5)
            $0.centerX.equalToSuperview()
        }
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 13
        
        let title1Label = UILabel()
        let title2Label = UILabel()
        
        title1Label.font = .systemFont(ofSize: 34, weight: .semibold)
        title1Label.textAlignment = .center
        title1Label.numberOfLines = 0
        
        title2Label.font = .systemFont(ofSize: 20, weight: .regular)
        title2Label.textColor = .secondaryLabel
        title2Label.textAlignment = .center
        title2Label.numberOfLines = 0
        
        title1Label.text = title1
        title2Label.text = title2
    
        view.addSubview(title1Label)
        title1Label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
        
        view.addSubview(title2Label)
        title2Label.snp.makeConstraints {
            $0.top.equalTo(title1Label.snp.bottom).offset(15)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
