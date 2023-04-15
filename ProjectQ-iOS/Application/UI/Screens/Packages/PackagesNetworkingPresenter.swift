//
//  PackagesNetworkingPresenter.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import ModuleAssembler
import ProjectQ_Components2
import SPAlert

protocol PackagesModulePublicInterface {
    func addPackage(_ package: Package)
    func updatePackage(at index: Int, package: Package)
}

class PackageNetworkingPresenter: AssemblablePresenter {
    typealias ViewType = PackagesViewController
    
    var interfaceContract: PackagesViewController.InterfaceContractType!
    
    var eventOutputHandler: (PackagesViewController.EventOutputReturnType) -> Void {
        return { eventType in
            switch eventType {
            case .didDeletePackageAt(let index):
                self.removePackage(at: index)
                if self.packages.isEmpty {
                    self.interfaceContract.setState(.noResults)
                }
                
            default: break
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
    private var packages: Packages = []
}

private extension PackageNetworkingPresenter {
    func savePackages() {
        service.savePackages(self.packages) { error in
            SPAlert.present(title: error.rawValue, preset: .error)
            print(error)
        }
    }
    
    func removePackage(at index: Int) {
        self.packages.remove(at: index)
        savePackages()
        SPAlert.present(title: "Success!", message: "Package has been removed", preset: .done)
        interfaceContract.setState(.results(self.packages))
    }
}

extension PackageNetworkingPresenter: PackagesModulePublicInterface {
    func addPackage(_ package: Package) {
        self.packages.append(package)
        savePackages()
        SPAlert.present(title: "New package was created", preset: .done)
        interfaceContract.setState(.results(packages))
    }
    
    func updatePackage(at index: Int, package: Package) {
        self.packages.remove(at: index)
        self.packages.insert(package, at: index)
        savePackages()
        
        SPAlert.present(title: "Success!", message: "Package has been updated", preset: .done)
        interfaceContract.setState(.results(packages))
    }
}
