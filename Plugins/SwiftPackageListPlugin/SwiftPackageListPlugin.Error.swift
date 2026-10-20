//
//  SwiftPackageListPlugin.Error.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation

extension SwiftPackageListPlugin {
    enum Error: Swift.Error {
        case configurationUnavailable(url: URL, underlyingError: Swift.Error)
        case configurationInvalid(url: URL, underlyingError: Swift.Error)
        case sourcePackagesNotFound(pluginWorkDirectoryURL: URL)
    }
}

// MARK: - CustomStringConvertible

extension SwiftPackageListPlugin.Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .configurationUnavailable(url: let url, underlyingError: let error):
            return "The configuration at \(url.path(percentEncoded: false)) is unavailable: \(error)"
        case .configurationInvalid(url: let url, underlyingError: let error):
            return "The configuration at \(url.path(percentEncoded: false)) has an invalid format: \(error)"
        case .sourcePackagesNotFound(pluginWorkDirectoryURL: let url):
            return "SourcePackages directory not found from \(url.path(percentEncoded: false))"
        }
    }
}
