//
//  DescriptionComponentView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 12.03.2023.
//

import SwiftUI
import ProjectQ_Components
import SPAlert
import UIKit

fileprivate class DescriptionComponentViewViewModel: ObservableObject {
    @Published var descriptionValue: String = ""
}


struct DescriptionComponentView: View, ViewComponentReturnable {
  
    var didReturnComponent: ((ProjectQ_Components.Component) -> Void)?
    
    func configureData(_ data: Data) {
        guard let inputStruct = try? JSONDecoder().decode(DescriptionComponentHandler.Input.self, from: data) else {
            isAlertPresentet = true
            return
        }
        self.viewModel.descriptionValue = inputStruct.description
    }

    @State private var isAlertPresentet: Bool = false
    @ObservedObject private var viewModel = DescriptionComponentViewViewModel()
    
    var body: some View {
        List {
            Section(
                header: Text("Enter description")
            ) {
                MultilineTextField("Enter text", text: $viewModel.descriptionValue)
            }
        }
        .SPAlert(
            isPresent: $isAlertPresentet,
            alertView: .init(
                title: "Error",
                message: "Failed to parse component data",
                preset: .error)
        )
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Done", action: {
                    guard let data = try? JSONEncoder().encode(
                        DescriptionComponentHandler.Input(description: self.viewModel.descriptionValue)
                    ) else {
                        isAlertPresentet = true
                        return
                    }
                    didReturnComponent?(
                        .description.inputed(data)
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
