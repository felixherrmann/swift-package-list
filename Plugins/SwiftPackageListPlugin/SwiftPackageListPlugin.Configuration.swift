//
//  SwiftPackageListPlugin.Configuration.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation

// swiftlint:disable identifier_name type_name discouraged_optional_collection discouraged_optional_boolean

extension SwiftPackageListPlugin {
    struct Configuration {
        private static let fileName = "swift-package-list-config.json"

        let url: URL
        let storage: Storage

        init?(in directory: URL) throws(SwiftPackageListPlugin.Error) {
            let url = directory.appending(path: Self.fileName)
            guard FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) else { return nil }

            let data: Data
            do {
                data = try Data(contentsOf: url)
            } catch {
                throw .configurationUnavailable(url: url, underlyingError: error)
            }

            let decoder = JSONDecoder()
            decoder.allowsJSON5 = true

            let storage: Storage
            do {
                storage = try decoder.decode(Storage.self, from: data)
            } catch {
                throw .configurationInvalid(url: url, underlyingError: error)
            }

            self.url = url
            self.storage = storage
        }
    }
}

// MARK: - Storage

extension SwiftPackageListPlugin.Configuration {
    enum Storage {
        case v1(V1)
        case v2(V2)
    }
}

extension SwiftPackageListPlugin.Configuration.Storage: Decodable {
    private enum VersionKeys: CodingKey {
        case version
    }

    init(from decoder: any Decoder) throws {
        let versionContainer = try decoder.container(keyedBy: VersionKeys.self)
        let version = try versionContainer.decodeIfPresent(Int.self, forKey: .version) ?? 1

        switch version {
        case 1:
            self = .v1(try V1(from: decoder))
        case 2:
            self = .v2(try V2(from: decoder))
        case let version:
            throw DecodingError.dataCorruptedError(
                forKey: .version,
                in: versionContainer,
                debugDescription: "Unsupported configuration version: \(version)"
            )
        }
    }
}

// MARK: - V1

extension SwiftPackageListPlugin.Configuration.Storage {
    struct V1: Decodable {
        let projectPath: String?
        let project: SwiftPackageListPlugin.Configuration.TargetOptions?
        let targets: [String: SwiftPackageListPlugin.Configuration.TargetOptions]?
    }
}

// MARK: - V2

extension SwiftPackageListPlugin.Configuration.Storage {
    struct V2: Decodable {
        let projectPath: String?
        let targets: [String: SwiftPackageListPlugin.Configuration.TargetOptions]?
    }
}

// MARK: - Options

extension SwiftPackageListPlugin.Configuration {
    struct TargetOptions: Decodable {
        let outputType: OutputType?
        let packageOrder: PackageOrder?
        let requiresLicense: Bool?
        let ignorePackages: [String]?
        let customPackagesFilePaths: [String]?
    }
}

extension SwiftPackageListPlugin.Configuration {
    enum OutputType: String, Decodable {
        case stdout
        case json
        case plist
        case settingsBundle = "settings-bundle"
        case pdf
    }

    enum PackageOrder: String, Decodable {
        case source
        case nameAscending = "name-ascending"
        case nameDescending = "name-descending"
        case identityAscending = "identity-ascending"
        case identityDescending = "identity-descending"
    }
}

extension SwiftPackageListPlugin.Configuration.OutputType {
    var fileName: String? {
        switch self {
        case .stdout:
            return nil
        case .json:
            return "package-list.json"
        case .plist:
            return "package-list.plist"
        case .settingsBundle:
            return "Settings.bundle"
        case .pdf:
            return "Acknowledgements.pdf"
        }
    }
}

// MARK: - Normalization

extension SwiftPackageListPlugin.Configuration {
    var projectPath: String? {
        switch storage {
        case .v1(let v1):
            return v1.projectPath
        case .v2(let v2):
            return v2.projectPath
        }
    }

    func targetOptions(for name: String) -> TargetOptions? {
        switch storage {
        case .v1(let v1):
            return v1.targets?[name] ?? v1.project
        case .v2(let v2):
            return v2.targets?[name] ?? v2.targets?["*"]
        }
    }
}

// swiftlint:enable identifier_name type_name discouraged_optional_collection discouraged_optional_boolean
