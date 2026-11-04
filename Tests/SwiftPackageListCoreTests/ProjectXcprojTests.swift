//
//  ProjectXcprojTests.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 08.10.26.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct ProjectXcprojTests {
    @Test func organizationName() throws {
        let url = Bundle.module.url(
            forResource: "project",
            withExtension: "xcproj",
            subdirectory: "Resources/XcodeProject/xcproj/Project.xcodeproj"
        )
        let unwrappedURL = try #require(url)
        let projectPbxproj = ProjectXcproj(url: unwrappedURL)

        #expect(projectPbxproj.organizationName == "Swift Package List")
    }
}
