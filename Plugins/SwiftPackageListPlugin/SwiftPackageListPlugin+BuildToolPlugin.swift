//
//  SwiftPackageListPlugin+BuildToolPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

import PackagePlugin

extension SwiftPackageListPlugin: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let executable = try context.tool(named: "swift-package-list").url

        let configurationURL = context.package.directoryURL.appending(path: Configuration.fileName)
        let configuration = try Configuration(url: configurationURL)
        let targetOptions = configuration?.targetOptions(for: target.name)

        let relativeProjectPath = configuration?.projectPath ?? "Package.swift"
        let projectURL = context.package.directoryURL.appending(path: relativeProjectPath)

        return try createBuildCommands(
            executable: executable,
            targetOptions: targetOptions,
            projectURL: projectURL,
            pluginWorkDirectoryURL: context.pluginWorkDirectoryURL
        )
    }
}
