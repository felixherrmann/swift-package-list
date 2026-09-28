//
//  XcodeWorkspaceTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 09.10.26.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct XcodeWorkspaceTests {
    @Test func organizationNameWithPodsFirst() throws {
        let url = Bundle.module.url(
            forResource: "Workspace",
            withExtension: "xcworkspace",
            subdirectory: "Resources/XcodeWorkspace/pbxproj"
        )
        let unwrappedURL = try #require(url)
        let workspace = XcodeWorkspace(fileURL: unwrappedURL, options: ProjectOptions())

        #expect(workspace.organizationName == "Swift Package List")
    }
}
