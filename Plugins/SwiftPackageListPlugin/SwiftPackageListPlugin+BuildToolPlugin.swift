//
//  SwiftPackageListPlugin+BuildToolPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import Foundation
import PackagePlugin

extension SwiftPackageListPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let executable = try context.tool(named: "swift-package-list").url

        let configuration = try Configuration(in: context.package.directoryURL)
        let targetOptions = configuration?.targetOptions(for: target.name)
        let environmentOptions = Environment.current.flatMap { configuration?.environmentOptions(for: $0.rawValue) }

        let projectPath = configuration?.projectPath ?? "Package.swift"
        let projectURL = URL(filePath: projectPath, relativeTo: context.package.directoryURL)

        return try createBuildCommands(
            executable: executable,
            targetOptions: targetOptions,
            environmentOptions: environmentOptions,
            projectURL: projectURL,
            projectDirectoryURL: context.package.directoryURL,
            pluginWorkDirectoryURL: context.pluginWorkDirectoryURL
        )
    }
}
