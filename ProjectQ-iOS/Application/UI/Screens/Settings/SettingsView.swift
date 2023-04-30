//
//  SettingsView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 30.04.2023.
//

import Foundation
import SwiftUI
import SettingsIconGenerator

struct SettingsViewEvents {
    var didTapCase: (SettingsView.Cell) -> Void
}

struct SettingsView: View {
    
    var events: SettingsViewEvents = SettingsViewEvents(didTapCase: {_ in })
    
    enum Cell: Int {
        case aboutApp = 0
        case onboarding = 1
    }
    
    func cell(title: String, iconName: String, color: UIColor, cell: Cell) -> some View {
        ZStack {
            Button("", action: {
                events.didTapCase(cell)
            })
            HStack {
                if let image = UIImage.generateSettingsIcon(iconName, backgroundColor: color) {
                    Image(uiImage: image)
                }
                Text(title)
            }
        }
    }
    
    var body: some View {
        List {
            cell(title: "About App", iconName: "house.fill", color: .systemRed, cell: .aboutApp)
            cell(title: "Onboarding", iconName: "questionmark.circle.fill", color: .systemBlue, cell: .onboarding)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
