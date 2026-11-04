//
//  URLExtensionTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 14.02.24.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct URLExtensionTests {
    @Test func deletingGitExtensionNoExtension() throws {
        let url = try #require(URL(string: "https://github.com/test/test"))
            .deletingGitExtension()
            .absoluteString
        #expect(url == "https://github.com/test/test")
    }

    @Test func deletingGitExtensionGitExtension() throws {
        let url = try #require(URL(string: "https://github.com/test/test.git"))
            .deletingGitExtension()
            .absoluteString
        #expect(url == "https://github.com/test/test")
    }

    @Test func deletingGitExtensionOtherExtension() throws {
        let url = try #require(URL(string: "https://github.com/test/Test.swift"))
            .deletingGitExtension()
            .absoluteString
        #expect(url == "https://github.com/test/Test.swift")
    }

    @Test func deletingGitExtensionMixedExtensions() throws {
        let url = try #require(URL(string: "https://github.com/test/Test.swift.git"))
            .deletingGitExtension()
            .absoluteString
        #expect(url == "https://github.com/test/Test.swift")
    }
}
