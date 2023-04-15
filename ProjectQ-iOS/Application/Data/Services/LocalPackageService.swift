//
//  LocalPackageService.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import ProjectQ_Components2

class LocalPackagesService {
    private let userDefaults = UserDefaults.standard
    private let key = "Packages.LocalPackagesService.key"
    
    enum ServiceError: String, Error {
        case wrongKey = "Worng Key"
        case decodingFailure = "Decoding Failure"
        case archiveFailure = "Archive Failure"
        case noResults = "No results"
    }
}

extension LocalPackagesService {
    func getPackages() -> Result<[Package], LocalPackagesService.ServiceError> {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return .failure(.wrongKey)
        }
        guard let codablePackages = try? JSONDecoder().decode([CodablePackage].self, from: data) else {
            return .failure(.decodingFailure)
        }
        
        if codablePackages.isEmpty {
            return .failure(.noResults)
        }
        
        return .success(codablePackages.packages)
    }

    func savePackages(
        _ packages: [Package],
        errorHandler: (
            (LocalPackagesService.ServiceError) -> Void
        )?
    ) {
        let codablePackage = packages.codablePackages
        guard let data = try? JSONEncoder().encode(codablePackage) else {
            errorHandler?(.archiveFailure)
            return
        }
        userDefaults.set(data, forKey: key)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
