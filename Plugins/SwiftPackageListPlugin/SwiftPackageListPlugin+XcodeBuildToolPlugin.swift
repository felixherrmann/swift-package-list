//
//  SwiftPackageListPlugin+XcodeBuildToolPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

#if canImport(XcodeProjectPlugin)
import PackagePlugin
import XcodeProjectPlugin

extension SwiftPackageListPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let executable = try context.tool(named: "swift-package-list").url

        let configurationURL = context.xcodeProject.directoryURL.appending(path: Configuration.fileName)
        let configuration = try Configuration(url: configurationURL)
        let targetConfiguration = configuration?.targetConfiguration(for: target.displayName)

        let relativeProjectPath = configuration?.projectPath ?? "\(context.xcodeProject.displayName).xcodeproj"
        let projectURL = context.xcodeProject.directoryURL.appending(path: relativeProjectPath)

        return try createBuildCommands(
            executable: executable,
            targetConfiguration: targetConfiguration,
            projectURL: projectURL,
            pluginWorkDirectoryURL: context.pluginWorkDirectoryURL
        )
    }
}
#endif
