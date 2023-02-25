//
//  PackagesModule.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import ModuleAssembler

class PackagesModule: Assemblable {
    typealias ViewType = PackagesViewController
    typealias PresenterType = PackageNetworkingPresenter
    typealias PublicInterfaceType = PackagesModulePublicInterface
    
    var currentPresenter: PackageNetworkingPresenter!
    var currentView: PackagesViewController!
    
    var publicInterface: PublicInterfaceType? {
        return self.currentPresenter
    }
}
