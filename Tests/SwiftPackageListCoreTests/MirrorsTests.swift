//
//  MirrorsTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 09.11.25.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct MirrorsTests {
    @Test func version1() throws {
        let url = Bundle.module.url(
            forResource: "mirrors_v1",
            withExtension: "json",
            subdirectory: "Resources/Mirrors"
        )
        let unwrappedURL = try #require(url)
        let mirrors = try Mirrors(url: unwrappedURL)

        guard case .v1(let storage) = mirrors.storage else {
            Issue.record("\(unwrappedURL.path) was not recognized as v1")
            return
        }

        #expect(storage.version == 1)
        #expect(storage.object.count == 2)
    }

    @Test func unsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "mirrors_v999",
            withExtension: "json",
            subdirectory: "Resources/Mirrors"
        )
        let unwrappedURL = try #require(url)

        let error = #expect(throws: RuntimeError.self) {
            try Mirrors(url: unwrappedURL)
        }
        #expect(error?.description == "Version 999 of mirrors.json is not supported")
    }

    @Test func mirror() throws {
        let url = Bundle.module.url(
            forResource: "mirrors_v1",
            withExtension: "json",
            subdirectory: "Resources/Mirrors"
        )
        let unwrappedURL = try #require(url)
        let mirrors = try Mirrors(url: unwrappedURL)

        #expect(mirrors.mirror(for: "https://github.com/felixherrmann/swift-package-list") == "https://github.com/example/swift-package-list")
        #expect(mirrors.mirror(for: "https://github.com/felixherrmann/test") == "/Users/example/test")
    }
}
