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
        targetOptions: Configuration.TargetOptions?,
        projectURL: URL,
        projectDirectoryURL: URL,
        pluginWorkDirectoryURL: URL
    ) throws -> [Command] {
        let sourcePackagesPath = try sourcePackagesDirectory(pluginWorkDirectoryURL: pluginWorkDirectoryURL)
        let outputType = targetOptions?.outputType ?? .json
        let outputURL = pluginWorkDirectoryURL
        let packageOrder = targetOptions?.packageOrder ?? .source
        let requiresLicense = targetOptions?.requiresLicense ?? true

        let ignorePackageArguments: [String] = targetOptions?.ignorePackages?.flatMap { identity in
            return ["--ignore-package", identity]
        } ?? []

        let customPackagesFilePathArguments: [String] = targetOptions?.customPackagesFilePaths?.flatMap { filePath in
            let url = URL(filePath: filePath, relativeTo: projectDirectoryURL)
            return ["--custom-packages-file-path", url.path(percentEncoded: false)]
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
                    projectURL.path(percentEncoded: false),
                    "--custom-source-packages-path", sourcePackagesPath.path(percentEncoded: false),
                    "--output-type", outputType.rawValue,
                    "--output-path", outputURL.path(percentEncoded: false),
                    "--package-order", packageOrder.rawValue,
                    requiresLicense ? "--requires-license" : "",
                ] + ignorePackageArguments + customPackagesFilePathArguments,
                outputFiles: outputFiles
            )
        ]
    }

    private func sourcePackagesDirectory(pluginWorkDirectoryURL: URL) throws -> URL {
        var url = pluginWorkDirectoryURL
        while url.path(percentEncoded: false) != "/" {
            let potentialLocation = url.appending(path: "SourcePackages")
            if FileManager.default.fileExists(atPath: potentialLocation.path(percentEncoded: false)) {
                return potentialLocation
            }
            url = url.deletingLastPathComponent()
        }
        throw SwiftPackageListPlugin.Error.sourcePackagesNotFound(pluginWorkDirectoryURL: pluginWorkDirectoryURL)
    }
}
