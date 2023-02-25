//
//  LocalPackageService.swift
//  ProjectQ-iOS
//
//  Created by Jeytery on 18.02.2023.
//

import Foundation
import ProjectQ_Components

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
    func getPackages() -> Result<TaskPackages, LocalPackagesService.ServiceError> {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return .failure(.wrongKey)
        }
        guard let packages = try? JSONDecoder().decode(TaskPackages.self, from: data) else {
            return .failure(.decodingFailure)
        }
        
        if packages.isEmpty {
            return .failure(.noResults)
        }
        
        return .success(packages)
    }

    func savePackages(
        _ packages: TaskPackages,
        errorHandler: (
            (LocalPackagesService.ServiceError) -> Void
        )?
    ) {
        guard let data = try? JSONEncoder().encode(packages) else {
            errorHandler?(.archiveFailure)
            return
        }
        userDefaults.set(data, forKey: key)
    }
    
    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
