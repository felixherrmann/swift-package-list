//
//  ProjectPbxprojTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 26.12.23.
//

import XCTest
@testable import SwiftPackageListCore

final class ProjectPbxprojTests: XCTestCase {
    func testOrganizationName() throws {
        let url = Bundle.module.url(
            forResource: "organization_unquoted",
            withExtension: "pbxproj",
            subdirectory: "Resources/ProjectPbxproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)
        
        XCTAssertEqual(projectPbxproj.organizationName, "SwiftPackageList")
    }
    
    func testQuotedOrganizationName() throws {
        let url = Bundle.module.url(
            forResource: "organization_quoted",
            withExtension: "pbxproj",
            subdirectory: "Resources/ProjectPbxproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)
        
        XCTAssertEqual(projectPbxproj.organizationName, "SwiftPackageList Inc.")
    }
    
    func testEscapedOrganizationName() throws {
        let url = Bundle.module.url(
            forResource: "organization_escaped",
            withExtension: "pbxproj",
            subdirectory: "Resources/ProjectPbxproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)
        
        XCTAssertEqual(projectPbxproj.organizationName, "SwiftPackageList \"Tools\"")
    }
    
    func testOrganizationNameIgnoresBuildSettings() throws {
        let url = Bundle.module.url(
            forResource: "organization_build_setting",
            withExtension: "pbxproj",
            subdirectory: "Resources/ProjectPbxproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)
        
        XCTAssertEqual(projectPbxproj.organizationName, "SwiftPackageList")
    }
    
    func testMissingOrganizationName() throws {
        let url = Bundle.module.url(
            forResource: "organization_missing",
            withExtension: "pbxproj",
            subdirectory: "Resources/ProjectPbxproj"
        )
        let unwrappedURL = try XCTUnwrap(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)
        
        XCTAssertNil(projectPbxproj.organizationName)
    }
}
