//
//  HelperSUI.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 06.03.2023.
//

import Foundation
import SwiftUI

public struct DismissingKeyboard: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
            }
    }
}
