//
//  PackageInformationPresenter.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 24.02.2023.
//

import Foundation
import ModuleAssembler
import SwiftUI

protocol PackageInformationPublicInterface {}

class PackageInformationPresenter: AssemblablePresenter {
    typealias ViewType = PackageInformationView
    var interfaceContract: ViewType.InterfaceContractType!
    
    var eventOutputHandler: ((PackageInformationView.EventOutputReturnType) -> Void) {
        return {
            _ in
        }
    }
    
    func start() {
            
    }
    
    required init() {
        
    }
}
