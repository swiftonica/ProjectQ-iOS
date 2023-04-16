//
//  DescriptionComponentView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 12.03.2023.
//

import SwiftUI
import ProjectQ_Components2
import SPAlert
import UIKit

fileprivate class DescriptionComponentViewViewModel: ObservableObject {
    @Published var descriptionValue: String = ""
}

struct DescriptionComponentView: View, ViewComponentReturnable {
  
    var didReturnComponent: ((Component) -> Void)?
    
    func configureData(_ data: Data) {
        guard let inputStruct = try? JSONDecoder().decode(DescriptionComponentHandlerInput.self, from: data) else {
            isAlertPresentet = true
            return
        }
        self.viewModel.descriptionValue = inputStruct.description
    }

    @State private var isAlertPresentet: Bool = false
    @ObservedObject private var viewModel = DescriptionComponentViewViewModel()
    
    var body: some View {
        Form {
            MultilineTextField("Enter description", text: $viewModel.descriptionValue)
                .frame(height: 50)
        }
        .SPAlert(
            isPresent: $isAlertPresentet,
            alertView: .init(
                title: "Error",
                message: "Failed to parse component data",
                preset: .error)
        )
        .toolbar {
            ToolbarItemGroup {
                Button("Done", action: {
                    guard let data = try? JSONEncoder().encode(
                        DescriptionComponentHandlerInput(description: self.viewModel.descriptionValue)
                    ) else {
                        isAlertPresentet = true
                        return
                    }
                    didReturnComponent?(
                        .description(input: data)
                    )
                })
                .font(.system(size: 17, weight: .bold))
                Spacer()
            }
        }
    }
}

struct DescriptionComponentView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionComponentView()
    }
}
