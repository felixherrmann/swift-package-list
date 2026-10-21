//
//  SwiftPackageList.CustomPackages.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 17.02.25.
//

// swiftlint:disable identifier_name type_name

import Foundation
import SwiftPackageList

extension SwiftPackageList {
    struct CustomPackages {
        let url: URL
        let storage: Storage
    }
}

// MARK: - Loading

extension SwiftPackageList.CustomPackages {
    init(url: URL) throws {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true

        self.url = url
        self.storage = try decoder.decode(Storage.self, from: data)
    }
}

// MARK: - Storage

extension SwiftPackageList.CustomPackages {
    enum Storage {
        case v1(V1)
    }
}

extension SwiftPackageList.CustomPackages.Storage: Decodable {
    private enum VersionKeys: CodingKey {
        case version
    }

    init(from decoder: any Decoder) throws {
        guard let versionContainer = try? decoder.container(keyedBy: VersionKeys.self) else {
            self = .v1(try V1(from: decoder))
            return
        }
        let version = try versionContainer.decode(Int.self, forKey: .version)

        switch version {
        case let version:
            throw DecodingError.dataCorruptedError(
                forKey: .version,
                in: versionContainer,
                debugDescription: "Unsupported custom-packages version: \(version)"
            )
        }
    }
}

// MARK: - V1

extension SwiftPackageList.CustomPackages.Storage {
    typealias V1 = [Package]
}

// MARK: - Normalization

extension SwiftPackageList.CustomPackages {
    var packages: [Package] {
        switch storage {
        case .v1(let v1):
            return v1
        }
    }
}

// swiftlint:enable identifier_name type_name
