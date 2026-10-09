//
//  ProjectXcprojTests.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 08.10.26.
//

import XCTest
@testable import SwiftPackageListCore

final class ProjectXcprojTests: XCTestCase {
    func testOrganizationName() throws {
        let url = Bundle.module.url(
            forResource: "project",
            withExtension: "xcproj",
            subdirectory: "Resources/XcodeProject/xcproj/Project.xcodeproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectXcproj(url: unwrappedURL)
        
        XCTAssertEqual(projectPbxproj.organizationName, "SwiftPackageList")
    }
}
