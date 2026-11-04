//
//  SwiftPackageList.CustomPackages.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 17.02.25.
//

// swiftlint:disable identifier_name type_name

import Foundation
import SwiftPackageList
import SwiftPackageListCore

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
        if #available(macOS 12.0, *) {
            decoder.allowsJSON5 = true
        }

        self.url = url
        self.storage = try decoder.decode(Storage.self, from: data)
    }
}

// MARK: - Storage

extension SwiftPackageList.CustomPackages {
    enum Storage {
        case v1(V1)
        case v2(V2)
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
        case 2:
            self = .v2(try V2(from: decoder))
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

// MARK: - V2

extension SwiftPackageList.CustomPackages.Storage {
    struct V2: Decodable {
        struct CustomPackage: Decodable {
            enum License {
                case raw(content: String)
                case file(path: String)
                case directory(path: String)
            }

            let identity: String
            let name: String
            let version: String?
            let location: String?
            let license: License?
        }

        let packages: [CustomPackage]
    }
}

extension SwiftPackageList.CustomPackages.Storage.V2.CustomPackage.License: Decodable {
    private enum CodingKeys: CodingKey {
        case raw
        case file
        case directory
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard container.allKeys.count == 1 else {
            let context = DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "A custom package license must contain exactly one of raw, file or directory"
            )
            throw DecodingError.dataCorrupted(context)
        }

        switch container.allKeys[0] {
        case .raw:
            self = .raw(content: try container.decode(String.self, forKey: .raw))
        case .file:
            self = .file(path: try container.decode(String.self, forKey: .file))
        case .directory:
            self = .directory(path: try container.decode(String.self, forKey: .directory))
        }
    }
}

extension SwiftPackageList.CustomPackages.Storage.V2.CustomPackage {
    func licenseContent(baseURL: URL) throws -> String? {
        switch license {
        case .raw(content: let content):
            return content
        case .file(path: let path):
            let licenseURL = URL(fileURLWithPath: path, relativeTo: baseURL)
            let license = SwiftPackageListCore.License(url: licenseURL)
            return try license.content
        case .directory(path: let path):
            let directoryURL = URL(fileURLWithPath: path, relativeTo: baseURL)
            let license = try FileManager.default
                .contentsOfDirectory(
                    at: directoryURL,
                    includingPropertiesForKeys: [.isRegularFileKey],
                    options: .skipsHiddenFiles
                )
                .filter { (try? $0.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true }
                .compactMap(SwiftPackageListCore.License.init(uncheckedURL:))
                .min()
            return try license?.content
        case nil:
            return nil
        }
    }
}

// MARK: - Normalization

extension SwiftPackageList.CustomPackages {
    func packages() throws -> [Package] {
        switch storage {
        case .v1(let v1):
            return v1
        case .v2(let v2):
            let baseURL = url.deletingLastPathComponent()
            return try v2.packages.map { package in
                return Package(
                    kind: .custom,
                    identity: package.identity,
                    name: package.name,
                    version: package.version,
                    branch: nil,
                    revision: nil,
                    location: package.location ?? "",
                    license: try package.licenseContent(baseURL: baseURL)
                )
            }
        }
    }
}

// swiftlint:enable identifier_name type_name
