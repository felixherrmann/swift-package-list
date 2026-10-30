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

        let configuration = try Configuration(in: context.xcodeProject.directoryURL)
        let targetOptions = configuration?.targetOptions(for: target.displayName)

        let projectPath = configuration?.projectPath ?? "\(context.xcodeProject.displayName).xcodeproj"
        let projectURL = URL(filePath: projectPath, relativeTo: context.xcodeProject.directoryURL)

        return try createBuildCommands(
            executable: executable,
            targetOptions: targetOptions,
            projectURL: projectURL,
            projectDirectoryURL: context.xcodeProject.directoryURL,
            pluginWorkDirectoryURL: context.pluginWorkDirectoryURL
        )
    }
}
#endif
