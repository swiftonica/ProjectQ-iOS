//
//  SmallIntervalView.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 15.04.2023.
//

import SwiftUI
import ProjectQ_Components2
import SPAlert

fileprivate class SmallIntervalViewViewModel: ObservableObject {
    @Published var intervalValue: String = "0"
    @Published var selectedIntervalType: IntervalType = .seconds
}

fileprivate struct IntervalType: Hashable {
    static func == (
        lhs: IntervalType,
        rhs: IntervalType
    ) -> Bool {
        return lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    let name: String
    let type: SmallIntervalComponentHandlerInput.IntervalType
    
    static let hours = IntervalType(name: "Hours", type: .hours)
    static let minutes = IntervalType(name: "Minutes", type: .minutes)
    static let seconds = IntervalType(name: "Seconds", type: .seconds)
     
    static let allCases: [IntervalType] = [
        .seconds, .minutes, .hours
    ]
    
    init(name: String, type: SmallIntervalComponentHandlerInput.IntervalType) {
        self.name = name
        self.type = type
    }
    
    init(type: SmallIntervalComponentHandlerInput.IntervalType) {
        self = IntervalType.allCases.first(where: {
            $0.type == type
        }) ?? .seconds
    }
}

struct SmallIntervalView: View, ViewComponentReturnable {
    var didReturnComponent: ((Component) -> Void)?
    
    func configureData(_ data: Data) {
        guard let inputStruct = try? JSONDecoder().decode(SmallIntervalComponentHandlerInput.self, from: data) else {
            isAlertPresentet = true
            return
        }
        self.viewModel.selectedIntervalType = .init(type: inputStruct.intervalType)
        self.viewModel.intervalValue = String(inputStruct.interval)
    }
    
    @State private var isAlertPresentet: Bool = false
    @ObservedObject private var viewModel = SmallIntervalViewViewModel()

    var body: some View {
        Form {
            Section(header: Text("Value")) {
                TextField("Enter a value", text: $viewModel.intervalValue)
            }
            Section(header: Text("Type")) {
                Picker("Please choose a interval type", selection: $viewModel.selectedIntervalType) {
                    ForEach(IntervalType.allCases, id: \.self) {
                        Text($0.name)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItemGroup {
                Button("Done", action: {
                    guard let data = try? JSONEncoder().encode(
                        SmallIntervalComponentHandlerInput(
                            intervalType: self.viewModel.selectedIntervalType.type,
                            interval: Int(viewModel.intervalValue)!
                        )
                    ) else {
                        isAlertPresentet = true
                        return
                    }
                    didReturnComponent?(
                        .smallInterval(input: data)
                    )
                })
                .font(.system(size: 17, weight: .bold))
                Spacer()
            }
        }
    }
}

struct SmailIntervalView_Previews: PreviewProvider {
    static var previews: some View {
        SmallIntervalView()
    }
}
