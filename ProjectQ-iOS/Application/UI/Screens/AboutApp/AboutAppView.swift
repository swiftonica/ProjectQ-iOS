//
//  SettingsView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 16.04.2023.
//

import SwiftUI

struct AboutAppView: View {
    var body: some View {
        Form {
            Section {
                infoCell(title1: "Version", title2: "indev1", disclosureIndicator: false) {}
                infoCell(title1: "Developer", title2: "Jeytery", disclosureIndicator: true) {
                    guard let url = URL(string: "https://telegram.im/@Jeytery") else { return }
                    UIApplication.shared.open(url)
                }
            }
            Section {
                smallInfoCell("Support") {
                    guard let url = URL(string: "https://telegram.im/@Jeytery") else { return }
                    UIApplication.shared.open(url)
                }
                smallInfoCell("Privacy Policy") {
                    guard let url = URL(string: "https://docs.google.com/document/d/1qgy4I3-xpSlmr-EOibehwvu42UdZGJnuIqcuaZsqqvo/edit?usp=sharing") else { return }
                    UIApplication.shared.open(url)
                }
            }
            Section(footer: Text("Like Mafia? Shuffle cards for your games for free")) {
                smallInfoCell("RoleCards") {
                    guard let url = URL(string: "https://apps.apple.com/ua/app/rolecards/id1589786089") else { return }
                    UIApplication.shared.open(url)
                }
            }
            Section(footer: Text("Store and learn words in app for free")) {
                smallInfoCell("Words!") {
                    guard let url = URL(string: "https://apps.apple.com/ua/app/words-store-and-learn-words/id6443968798") else { return }
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func smallInfoCell(_ title: String, didTap: @escaping () -> Void) -> some View {
        ZStack {
            HStack {
                Text(title)
                Spacer()
                Image(systemName: "chevron.forward")
                    .font(Font.system(.caption).weight(.bold))
                    .foregroundColor(Color(UIColor.tertiaryLabel))
            }
            Button("", action: {
                didTap()
            })
        }
    }
    
    func infoCell(title1: String, title2: String, disclosureIndicator: Bool, didTap: @escaping () -> Void) -> some View {
        ZStack {
            HStack {
                Text(title1)
                Spacer()
                Text(title2)
                    .foregroundColor(.secondary)
                if disclosureIndicator {
                    Image(systemName: "chevron.forward")
                        .font(Font.system(.caption).weight(.bold))
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                }
            }
            Button("", action: {
                didTap()
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
