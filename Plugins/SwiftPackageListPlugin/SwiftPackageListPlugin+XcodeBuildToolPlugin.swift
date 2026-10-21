//
//  SwiftPackageListPlugin+XcodeBuildToolPlugin.swift
//  SwiftPackageListPlugin
//
//  Created by Felix Herrmann on 03.02.24.
//

#if canImport(XcodeProjectPlugin)
import Foundation
import PackagePlugin
import XcodeProjectPlugin

extension SwiftPackageListPlugin: XcodeBuildToolPlugin {
    func createBuildCommands(context: XcodePluginContext, target: XcodeTarget) throws -> [Command] {
        let executable = try context.tool(named: "swift-package-list").url
        let projectDirectory = context.xcodeProject.directoryURL
        let pluginWorkDirectory = context.pluginWorkDirectoryURL

        let configuration = try Configuration(in: projectDirectory)
        let targetOptions = configuration?.targetOptions(for: target.displayName)
        let environmentOptions = Environment.current.flatMap { configuration?.environmentOptions(for: $0.rawValue) }

        let projectPath = configuration?.projectPath ?? "\(context.xcodeProject.displayName).xcodeproj"
        let project = URL(filePath: projectPath, relativeTo: projectDirectory)

        return try createBuildCommands(
            targetOptions: targetOptions,
            environmentOptions: environmentOptions,
            locations: Locations(
                executable: executable,
                projectDirectory: projectDirectory,
                pluginWorkDirectory: pluginWorkDirectory,
                project: project
            )
        )
    }
}
#endif
