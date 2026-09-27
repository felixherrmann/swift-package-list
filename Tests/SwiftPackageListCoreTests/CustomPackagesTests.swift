//
//  CustomPackagesTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 17.02.25.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct CustomPackagesTests {
    @Test func packageParsing() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages",
            withExtension: ".json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try #require(url)
        let customPackages = CustomPackages(url: unwrappedURL)
        let package = try #require(try customPackages.packages().first)

        #expect(package.branch == "branch-test")
        #expect(package.identity == "identity-test")
        #expect(package.kind == .remoteSourceControl)
        #expect(package.license == "license-test")
        #expect(package.location == "location-tes")
        #expect(package.name == "name-test")
        #expect(package.revision == "revision-test")
        #expect(package.version == "version-test")
    }
}
