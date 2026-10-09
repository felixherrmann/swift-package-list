//
//  XcodeWorkspaceTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 09.10.26.
//

import XCTest
@testable import SwiftPackageListCore

final class XcodeWorkspaceTests: XCTestCase {
    func testOrganizationNameWithPodsFirst() throws {
        let url = Bundle.module.url(
            forResource: "Workspace",
            withExtension: "xcworkspace",
            subdirectory: "Resources/XcodeWorkspace/pbxproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let workspace = XcodeWorkspace(fileURL: unwrappedURL, options: ProjectOptions())
        
        XCTAssertEqual(workspace.organizationName, "SwiftPackageList")
    }
}
