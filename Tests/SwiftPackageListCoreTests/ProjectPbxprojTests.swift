//
//  ProjectPbxprojTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct ProjectPbxprojTests {
    @Test(arguments: [
        ("organization_unquoted", "Swift Package List"),
        ("organization_quoted", "Swift Package List Inc."),
        ("organization_escaped", "Swift Package List \"Tools\""),
        ("organization_build_setting", "Swift Package List"),
        ("organization_missing", nil),
    ])
    func organizationName(resource: String, expectedName: String?) throws {
        let url = Bundle.module.url(forResource: resource, withExtension: "pbxproj", subdirectory: "Resources/ProjectPbxproj")
        let unwrappedURL = try #require(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)

        #expect(projectPbxproj.organizationName == expectedName)
    }
}
