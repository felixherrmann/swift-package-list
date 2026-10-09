//
//  ContentsXcworkspacedataTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 09.10.26.
//

import XCTest
@testable import SwiftPackageListCore

final class ContentsXcworkspacedataTests: XCTestCase {
    func testGroupReferences() throws {
        let url = Bundle.module.url(
            forResource: "group",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()
        
        XCTAssertEqual(try contents.projectURLs, [
            directoryURL.appendingPathComponent("Pods/Pods.xcodeproj"),
            directoryURL.appendingPathComponent("Workspace.xcodeproj"),
        ])
    }
    
    func testNestedGroups() throws {
        let url = Bundle.module.url(
            forResource: "nested_groups",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()
        
        XCTAssertEqual(try contents.projectURLs, [
            directoryURL.appendingPathComponent("Projects/Apps/App.xcodeproj"),
            directoryURL.appendingPathComponent("Projects/Library.xcodeproj"),
            directoryURL.appendingPathComponent("Other.xcodeproj"),
        ])
    }
    
    func testContainerLocations() throws {
        let url = Bundle.module.url(
            forResource: "container",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()
        
        XCTAssertEqual(try contents.projectURLs, [
            directoryURL.appendingPathComponent("App.xcodeproj"),
            directoryURL.appendingPathComponent("Library.xcodeproj"),
        ])
    }
    
    func testAbsoluteLocations() throws {
        let url = Bundle.module.url(
            forResource: "absolute",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        
        XCTAssertEqual(try contents.projectURLs, [
            URL(fileURLWithPath: "/Users/example/Projects/App.xcodeproj"),
            URL(fileURLWithPath: "/Users/example/Projects/Libraries/Library.xcodeproj"),
        ])
    }
    
    func testEscapedProjectName() throws {
        let url = Bundle.module.url(
            forResource: "escaped_name",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let directoryURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()
        
        XCTAssertEqual(try contents.projectURLs, [directoryURL.appendingPathComponent("App & Tools.xcodeproj")])
    }
    
    func testSelfReference() throws {
        let url = Bundle.module.url(
            forResource: "contents",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/XcodeWorkspace/pbxproj/Workspace.xcodeproj/project.xcworkspace"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        let projectURL = unwrappedURL.deletingLastPathComponent().deletingLastPathComponent()
        
        XCTAssertEqual(try contents.projectURLs, [projectURL])
    }
    
    func testEmptyWorkspace() throws {
        let url = Bundle.module.url(
            forResource: "empty",
            withExtension: "xcworkspacedata",
            subdirectory: "Resources/ContentsXcworkspacedata"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let contents = ContentsXcworkspacedata(url: unwrappedURL)
        
        XCTAssertTrue(try contents.projectURLs.isEmpty)
    }
}
