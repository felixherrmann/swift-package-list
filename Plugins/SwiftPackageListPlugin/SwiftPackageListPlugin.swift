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
    func createBuildCommands(
        executable: URL,
        targetConfiguration: Configuration.TargetConfiguration?,
        projectURL: URL,
        pluginWorkDirectoryURL: URL
    ) throws -> [Command] {
        let sourcePackagesPath = try sourcePackagesDirectory(pluginWorkDirectoryURL: pluginWorkDirectoryURL)
        let outputType = targetConfiguration?.outputType ?? .json
        let outputURL = pluginWorkDirectoryURL
        let packageOrder = targetConfiguration?.packageOrder ?? .source
        let requiresLicense = targetConfiguration?.requiresLicense ?? true

        let ignorePackageArguments: [String] = targetConfiguration?.ignorePackages?.flatMap { identity in
            return ["--ignore-package", identity]
        } ?? []

        let customPackagesFilePathArguments: [String] = targetConfiguration?.customPackagesFilePaths?.flatMap { filePath in
            return ["--custom-packages-file-path", filePath]
        } ?? []

        let outputFiles: [URL]
        if let fileName = outputType.fileName {
            outputFiles = [outputURL.appending(path: fileName)]
        } else {
            outputFiles = []
        }

        return [
            .buildCommand(
                displayName: "SwiftPackageListPlugin",
                executable: executable,
                arguments: [
                    projectURL.path,
                    "--custom-source-packages-path", sourcePackagesPath.path,
                    "--output-type", outputType.rawValue,
                    "--output-path", outputURL.path,
                    "--package-order", packageOrder.rawValue,
                    requiresLicense ? "--requires-license" : "",
                ] + ignorePackageArguments + customPackagesFilePathArguments,
                outputFiles: outputFiles
            )
        ]
    }

    private func sourcePackagesDirectory(pluginWorkDirectoryURL: URL) throws -> URL {
        var path = pluginWorkDirectoryURL
        while path.path != "/" {
            let potentialLocation = path.appending(path: "SourcePackages")
            if FileManager.default.fileExists(atPath: potentialLocation.path) {
                return potentialLocation
            }
            path = path.deletingLastPathComponent()
        }
        throw SwiftPackageListPlugin.Error.sourcePackagesNotFound(pluginWorkDirectoryURL: pluginWorkDirectoryURL)
    }
}
