//
//  SwiftPackageListPlugin.Configuration.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation

extension SwiftPackageListPlugin {
    struct Configuration: Decodable {
        let projectPath: String?
        let project: TargetConfiguration?
        let targets: [String: TargetConfiguration]? // swiftlint:disable:this discouraged_optional_collection
    }
}

extension SwiftPackageListPlugin.Configuration {
    struct TargetConfiguration: Decodable {
        let outputType: OutputType?
        let packageOrder: PackageOrder?
        let requiresLicense: Bool? // swiftlint:disable:this discouraged_optional_boolean
        let ignorePackages: [String]? // swiftlint:disable:this discouraged_optional_collection
        let customPackagesFilePaths: [String]? // swiftlint:disable:this discouraged_optional_collection
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

extension SwiftPackageListPlugin.Configuration {
    static let fileName = "swift-package-list-config.json"
}

extension SwiftPackageListPlugin.Configuration {
    init?(url: URL) throws {
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw SwiftPackageListPlugin.Error.configurationUnavailable(url: url, underlyingError: error)
        }

        let decoder = JSONDecoder()
        decoder.allowsJSON5 = true
        do {
            self = try decoder.decode(SwiftPackageListPlugin.Configuration.self, from: data)
        } catch {
            throw SwiftPackageListPlugin.Error.configurationInvalid(url: url, underlyingError: error)
        }
    }
}
