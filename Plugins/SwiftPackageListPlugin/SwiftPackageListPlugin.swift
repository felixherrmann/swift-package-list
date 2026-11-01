//
//  SwiftPackageListPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation
import PackagePlugin

@main
struct SwiftPackageListPlugin: Plugin {
    struct Locations {
        let executable: URL
        let projectDirectory: URL
        let pluginWorkDirectory: URL
        let project: URL
    }

    func createBuildCommands(
        targetOptions: Configuration.TargetOptions?,
        environmentOptions: Configuration.EnvironmentOptions?,
        locations: Locations
    ) throws(SwiftPackageListPlugin.Error) -> [Command] {
        let outputType = targetOptions?.outputType ?? .json
        let outputURL = locations.pluginWorkDirectory
        let packageOrder = targetOptions?.packageOrder ?? .source

        let sourcePackagesPath: URL
        if let customSourcePackagesPath = environmentOptions?.customSourcePackagesPath {
            sourcePackagesPath = URL(filePath: customSourcePackagesPath, relativeTo: locations.projectDirectory)
        } else {
            sourcePackagesPath = try locateSourcePackagesDirectory(from: locations.pluginWorkDirectory)
        }

        var arguments = [
            locations.project.path(percentEncoded: false),
            "--custom-source-packages-path", sourcePackagesPath.path(percentEncoded: false),
            "--output-type", outputType.rawValue,
            "--output-path", outputURL.path(percentEncoded: false),
            "--package-order", packageOrder.rawValue,
        ]

        if targetOptions?.requiresLicense ?? true {
            arguments.append("--requires-license")
        }

        for identity in targetOptions?.ignorePackages ?? [] {
            arguments.append(contentsOf: ["--ignore-package", identity])
        }

        for identity in targetOptions?.includePackages ?? [] {
            arguments.append(contentsOf: ["--include-package", identity])
        }

        for filePath in targetOptions?.customPackagesFilePaths ?? [] {
            let url = URL(filePath: filePath, relativeTo: locations.projectDirectory)
            arguments.append(contentsOf: ["--custom-packages-file-path", url.path(percentEncoded: false)])
        }

        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: locations.executable,
                arguments: arguments,
                outputFiles: [outputURL.appending(path: outputType.filename)]
            )
        ]
    }

    private func locateSourcePackagesDirectory(from pluginWorkDirectoryURL: URL) throws(SwiftPackageListPlugin.Error) -> URL {
        var url = pluginWorkDirectoryURL
        while url.path(percentEncoded: false) != "/" {
            let potentialLocation = url.appending(path: "SourcePackages")
            if FileManager.default.fileExists(atPath: potentialLocation.path(percentEncoded: false)) {
                return potentialLocation
            }
            url = url.deletingLastPathComponent()
        }
        throw .sourcePackagesNotFound(pluginWorkDirectoryURL: pluginWorkDirectoryURL)
    }
}
