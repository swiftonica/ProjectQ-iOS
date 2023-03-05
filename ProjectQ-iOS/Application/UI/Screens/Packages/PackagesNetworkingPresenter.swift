//
//  PackagesNetworkingPresenter.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import ModuleAssembler
import ProjectQ_Components
import SPAlert

protocol PackagesModulePublicInterface {
    func addPackage(_ package: TaskPackage)
    func updatePackage(at index: Int, package: TaskPackage)
}

class PackageNetworkingPresenter: AssemblablePresenter {
    typealias ViewType = PackagesViewController
    
    var interfaceContract: PackagesViewController.InterfaceContractType!
    
    var eventOutputHandler: (PackagesViewController.EventOutputReturnType) -> Void {
        return { eventType in
            switch eventType {
            case .some: break 
            }
        }
    }
    
    required init() {

    }
    
    func start() {
        interfaceContract.setState(.loading)
        let result = service.getPackages()
        
        switch result {
        case .success(let packages):
            self.packages = packages
            interfaceContract.setState(.results(packages))
        case .failure(let failure):
            interfaceContract.setState(.noResults)
            NSLog(failure.rawValue)
        }
    }
    
    private let service = LocalPackagesService()
    private var packages: TaskPackages = []
}

extension PackageNetworkingPresenter: PackagesModulePublicInterface {
    func addPackage(_ package: TaskPackage) {
        self.packages.append(package)
        service.savePackages(self.packages) { error in
            SPAlert.present(title: error.rawValue, preset: .error)
            print(error)
        }
        SPAlert.present(title: "New package was created", preset: .done)
        interfaceContract.setState(.results(packages))
    }
    
    func updatePackage(at index: Int, package: TaskPackage) {
        self.packages.remove(at: index)
        self.packages.insert(package, at: index)
        service.savePackages(self.packages) { error in
            SPAlert.present(title: error.rawValue, preset: .error)
            print(error)
        }
        SPAlert.present(title: "Success!", message: "Package has been updated", preset: .done)
        interfaceContract.setState(.results(packages))
    }
}
