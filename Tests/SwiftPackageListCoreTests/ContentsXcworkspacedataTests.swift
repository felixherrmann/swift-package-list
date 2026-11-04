//
//  ContentsXcworkspacedataTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 09.10.26.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct ContentsXcworkspacedataTests {
    @Test func groupReferences() throws {
        let url = Bundle.module.url(
            forResource: "group",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()

        #expect(try contents.projectURLs == [
            directoryURL.appendingPathComponent("Pods/Pods.xcodeproj"),
            directoryURL.appendingPathComponent("Workspace.xcodeproj"),
        ])
    }

    @Test func nestedGroups() throws {
        let url = Bundle.module.url(
            forResource: "nested_groups",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()

        #expect(try contents.projectURLs == [
            directoryURL.appendingPathComponent("Projects/Apps/App.xcodeproj"),
            directoryURL.appendingPathComponent("Projects/Library.xcodeproj"),
            directoryURL.appendingPathComponent("Other.xcodeproj"),
        ])
    }

    @Test func containerLocations() throws {
        let url = Bundle.module.url(
            forResource: "container",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()

        #expect(try contents.projectURLs == [
            directoryURL.appendingPathComponent("App.xcodeproj"),
            directoryURL.appendingPathComponent("Library.xcodeproj"),
        ])
    }

    @Test func absoluteLocations() throws {
        let url = Bundle.module.url(
            forResource: "absolute",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)

        #expect(try contents.projectURLs == [
            URL(fileURLWithPath: "/Users/example/Projects/App.xcodeproj"),
            URL(fileURLWithPath: "/Users/example/Projects/Libraries/Library.xcodeproj"),
        ])
    }

    @Test func escapedProjectName() throws {
        let url = Bundle.module.url(
            forResource: "escaped_name",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()

        #expect(try contents.projectURLs == [directoryURL.appendingPathComponent("App & Tools.xcodeproj")])
    }

    @Test func selfReference() throws {
        let url = Bundle.module.url(
            forResource: "contents",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/XcodeWorkspace/pbxproj/Workspace.xcodeproj/project.xcworkspace"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let projectURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()

        #expect(try contents.projectURLs == [projectURL])
    }

    @Test func emptyWorkspace() throws {
        let url = Bundle.module.url(
            forResource: "empty",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try #require(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)

        #expect(try contents.projectURLs.isEmpty)
    }
}
