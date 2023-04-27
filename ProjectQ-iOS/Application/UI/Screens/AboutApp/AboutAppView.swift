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
                HStack {
                    Image(uiImage: getAppIcon() ?? UIImage())
                        .cornerRadius(10)
                    VStack {
                        HStack {
                            Text("ProQ")
                                .font(.system(size: 29, weight: .semibold))
                            Spacer()
                        }
                        HStack {
                            Text("indev1")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        Spacer()
                    }
                }
            }
            
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
    
    
    private func getAppIcon() -> UIImage? {
        let bundle = Bundle.main
        if
            let icons = bundle.infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last
        {
            return UIImage(named: lastIcon)
        }
        return nil
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AboutAppView()
    }
}
