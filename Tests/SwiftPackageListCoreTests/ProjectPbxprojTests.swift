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
        ("organization_unquoted", "SwiftPackageList"),
        ("organization_quoted", "SwiftPackageList Inc."),
        ("organization_escaped", "SwiftPackageList \"Tools\""),
        ("organization_build_setting", "SwiftPackageList"),
        ("organization_missing", nil),
    ])
    func organizationName(resource: String, expectedName: String?) throws {
        let url = Bundle.module.url(forResource: resource, withExtension: "pbxproj", subdirectory: "Resources/ProjectPbxproj")
        let unwrappedURL = try #require(url)
        let projectPbxproj = ProjectPbxproj(url: unwrappedURL)

        #expect(projectPbxproj.organizationName == expectedName)
    }
}
