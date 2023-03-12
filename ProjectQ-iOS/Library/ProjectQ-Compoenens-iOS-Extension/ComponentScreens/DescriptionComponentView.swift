//
//  DescriptionComponentView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 12.03.2023.
//

import SwiftUI
import ProjectQ_Components

struct DescriptionComponentView: View, ViewComponentReturnable {
  
    var didReturnComponent: ((ProjectQ_Components.Component) -> Void)?
    
    func configureData(_ data: Data) {
            
    }

    @State private var descriptionValue: String = ""
    
    var body: some View {
        List {
            Section(
                header: Text("Enter description")
            ) {
                TextField("", text: $descriptionValue)
                    .frame(height: 300)
            }
        }
    }
}

struct DescriptionComponentView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionComponentView()
    }
}
