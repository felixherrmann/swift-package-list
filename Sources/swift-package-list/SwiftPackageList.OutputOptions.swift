//
//  SwiftPackageList.OutputOptions.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 27.12.23.
//

import Foundation
import ArgumentParser
import SwiftPackageList
import SwiftPackageListCore

extension SwiftPackageList {
    struct OutputOptions: ParsableArguments {
        @Option(help: "The type of output for the package-list.")
        var outputType: OutputType = .json

        @Option(
            help: "The path where the file will be written. If omitted, the content is sent to stdout.",
            completion: .directory
        )
        var outputPath: String?

        @Option(help: "A custom filename to be used instead of the default ones.")
        var customFileName: String?

        @Option(help: "The order in which the packages will be listed.")
        var packageOrder: PackageOrder = .source

        @Flag(help: "Will skip the packages without a license-file.")
        var requiresLicense = false

        @Option(
            name: .customLong("ignore-package"),
            help: ArgumentHelp(
                "Will skip a package with the specified identity; glob patterns are supported. (This option may be repeated multiple times)", // swiftlint:disable:this line_length
                valueName: "package-identity-pattern"
            )
        )
        var ignoredPackageIdentities: [Pattern] = []
    }
}

extension SwiftPackageList.OutputOptions {
    enum PackageOrder: String, CaseIterable, ExpressibleByArgument {
        case source
        case nameAscending = "name-ascending"
        case nameDescending = "name-descending"
        case identityAscending = "identity-ascending"
        case identityDescending = "identity-descending"
    }
}

extension SwiftPackageList.OutputOptions {
    var outputGeneratorOptions: OutputGeneratorOptions {
        let outputURL = outputPath.map { URL(fileURLWithPath: $0) }
        return OutputGeneratorOptions(outputURL: outputURL, customFileName: customFileName)
    }
}

extension SwiftPackageList.OutputOptions {
    func filter(package: Package) -> Bool {
        if requiresLicense && !package.hasLicense { return false }
        return !ignoredPackageIdentities.contains { $0.matches(package.identity) }
    }

    func sort(lhs: Package, rhs: Package) -> Bool {
        switch packageOrder {
        case .source:
            return false
        case .nameAscending:
            return lhs.name.lowercased() < rhs.name.lowercased()
        case .nameDescending:
            return lhs.name.lowercased() > rhs.name.lowercased()
        case .identityAscending:
            return lhs.identity.lowercased() < rhs.identity.lowercased()
        case .identityDescending:
            return lhs.identity.lowercased() > rhs.identity.lowercased()
        }
    }
}
