//
//  CustomPackagesTests.swift
//  swift-package-list-tests
//
//  Created by Felix Herrmann on 17.02.25.
//

import Foundation
import Testing

@testable import swift_package_list

struct CustomPackagesTests {
    @Test func version1() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages_v1",
            withExtension: ".json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try #require(url)
        let customPackages = try SwiftPackageList.CustomPackages(url: unwrappedURL)
        let package = try #require(customPackages.packages.first)

        #expect(package.branch == "branch-test")
        #expect(package.identity == "identity-test")
        #expect(package.kind == .remoteSourceControl)
        #expect(package.license == "license-test")
        #expect(package.location == "location-tes")
        #expect(package.name == "name-test")
        #expect(package.revision == "revision-test")
        #expect(package.version == "version-test")
    }

    @Test func unsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages_v999",
            withExtension: ".json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try #require(url)

        #expect {
            try SwiftPackageList.CustomPackages(url: unwrappedURL)
        } throws: { error in
            guard case DecodingError.dataCorrupted(let context) = error else { return false }
            guard context.codingPath.last?.stringValue == "version" else { return false }
            guard context.debugDescription == "Unsupported custom-packages version: 999" else { return false }
            return true
        }
    }
}
