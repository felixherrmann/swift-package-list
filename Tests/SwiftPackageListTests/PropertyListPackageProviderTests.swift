//
//  PropertyListPackageProvider.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import Testing

@testable import SwiftPackageList

struct PropertyListPackageProviderTests {
    @Test func output() throws {
        let packageProvider = PropertyListPackageProvider(bundle: .module, fileName: "example_2")
        let packages = try packageProvider.packages()

        let expectedIdentities = ["swift-algorithms", "swift-argument-parser", "swift-collections", "swift-numerics"]
        #expect(packages.map(\.identity) == expectedIdentities)

        let expectedNames = ["swift-algorithms", "swift-argument-parser", "swift-collections", "swift-numerics"]
        #expect(packages.map(\.name) == expectedNames)

        let expectedVersions = ["1.0.0", nil, nil, "1.0.2"]
        #expect(packages.map(\.version) == expectedVersions)

        let expectedBranches = [nil, nil, "main", nil]
        #expect(packages.map(\.branch) == expectedBranches)

        let expectedRevisions = [
            "b14b7f4c528c942f121c8b860b9410b2bf57825e",
            "060d52364cf2a3e06b7adf0b17dbb7c33c77e1d3",
            "108ac4fa4ef7f2622b97a1f5dd92a3e0c6857c60",
            "0a5bc04095a675662cf24757cc0640aa2204253b",
        ]
        #expect(packages.map(\.revision) == expectedRevisions)

        let expectedRepositoryURLs = [
            "https://github.com/apple/swift-algorithms",
            "https://github.com/apple/swift-argument-parser",
            "https://github.com/apple/swift-collections",
            "https://github.com/apple/swift-numerics",
        ]
        #expect(packages.map(\.location) == expectedRepositoryURLs)

        let expectedLicenseLengths = [11_751, 11_751, 11_751, 11_751]
        #expect(packages.map(\.license?.count) == expectedLicenseLengths)
    }

    @Test func errors() {
        let packageProvider = PropertyListPackageProvider(bundle: .module, fileName: "test")
        let error = #expect(throws: CocoaError.self) {
            try packageProvider.packages()
        }
        #expect(error?.code == .fileNoSuchFile)
        #expect(error?.userInfo["file_name"] as? String == "test")
        #expect(error?.userInfo["file_type"] as? String == "plist")
    }
}
