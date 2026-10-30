//
//  ProjectTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct ProjectTests {
    @Test(arguments: ["pbxproj", "xcproj"])
    func xcodeProject(format: String) throws {
        // Note: The project and workspace files in the Resources directory get's hidden by Xcode
        let url = Bundle.module.url(
            forResource: "Project",
            withExtension: "xcodeproj",
            subdirectory: "Resources/XcodeProject/\(format)"
        )
        let unwrappedURL = try #require(url)

        let projectType = try ProjectType(fileURL: unwrappedURL)
        #expect(projectType == .xcodeProject)

        let project = try projectType.project(fileURL: unwrappedURL)
        let xcodeProject = try #require(project as? XcodeProject)

        let expectedPackageResolvedFileURL = unwrappedURL
            .appendingPathComponent("project.xcworkspace")
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
        #expect(try xcodeProject.packageResolved.url == expectedPackageResolvedFileURL)

        let expectedConfigurationDirectoryURL = unwrappedURL
            .appendingPathComponent("project.xcworkspace")
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("configuration")
        #expect(xcodeProject.configuration?.url == expectedConfigurationDirectoryURL)

        #expect(xcodeProject.name == "Project")
        #expect(xcodeProject.organizationName == "Swift Package List")
    }

    @Test(arguments: ["pbxproj", "xcproj"])
    func testXcodeWorkspace(format: String) throws {
        // Note: The project and workspace files in the Resources directory get's hidden by Xcode
        let url = Bundle.module.url(
            forResource: "Workspace",
            withExtension: "xcworkspace",
            subdirectory: "Resources/XcodeWorkspace/\(format)"
        )
        let unwrappedURL = try #require(url)

        let projectType = try ProjectType(fileURL: unwrappedURL)
        #expect(projectType == .xcodeWorkspace)

        let project = try projectType.project(fileURL: unwrappedURL)
        let xcodeWorkspace = try #require(project as? XcodeWorkspace)

        let expectedPackageResolvedFileURL = unwrappedURL
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("Package.resolved")
        #expect(try xcodeWorkspace.packageResolved.url == expectedPackageResolvedFileURL)

        let expectedConfigurationDirectoryURL = unwrappedURL
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("configuration")
        #expect(xcodeWorkspace.configuration?.url == expectedConfigurationDirectoryURL)

        #expect(xcodeWorkspace.name == "Workspace")
        #expect(xcodeWorkspace.organizationName == "Swift Package List")
    }

    @Test func swiftPackage() throws {
        let url = Bundle.module.url(forResource: "Package", withExtension: "swift", subdirectory: "Resources/SwiftPackage")
        let unwrappedURL = try #require(url)

        let projectType = try ProjectType(fileURL: unwrappedURL)
        #expect(projectType == .swiftPackage)

        let project = try projectType.project(fileURL: unwrappedURL)
        let swiftPackage = try #require(project as? SwiftPackage)

        let expectedPackageResolvedFileURL = unwrappedURL
            .deletingLastPathComponent()
            .appendingPathComponent("Package.resolved")
        #expect(try swiftPackage.packageResolved.url == expectedPackageResolvedFileURL)

        let expectedConfigurationDirectoryURL = unwrappedURL
            .deletingLastPathComponent()
            .appendingPathComponent(".swiftpm")
            .appendingPathComponent("configuration")
        #expect(swiftPackage.configuration?.url == expectedConfigurationDirectoryURL)

        #expect(swiftPackage.name == "SwiftPackage")
        #expect(swiftPackage.organizationName == nil)
    }

    @Test(.enabled(if: hasTuist, "Tuist is unavailable"))
    func tuist() throws {
        let url = Bundle.module.url(forResource: "Project", withExtension: "swift", subdirectory: "Resources/Tuist")
        let unwrappedURL = try #require(url)

        let projectType = try ProjectType(fileURL: unwrappedURL)
        #expect(projectType == .tuist)

        let project = try projectType.project(fileURL: unwrappedURL)
        let tuist = try #require(project as? Tuist)

        let expectedPackageResolvedFileURL = unwrappedURL
            .deletingLastPathComponent()
            .appendingPathComponent(".package.resolved")
        #expect(try tuist.packageResolved.url == expectedPackageResolvedFileURL)

        #expect(tuist.name == "Tuist")
        #expect(tuist.organizationName == "Test Inc.")
    }

    private static var hasTuist: Bool {
        return (try? zsh("tuist version").exitCode) == 0
    }
}
