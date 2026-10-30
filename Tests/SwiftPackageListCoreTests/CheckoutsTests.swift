//
//  CheckoutsTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct CheckoutsTests {
    @Test func packageSourceInvalidURL() {
        let checkouts = Checkouts(url: URL(fileURLWithPath: "/test/checkouts"))
        let packageSource = checkouts.packageSource(location: "")
        #expect(packageSource == nil)
    }

    @Test func packageSourceValidURL() throws {
        let checkouts = Checkouts(url: URL(fileURLWithPath: "/test/checkouts"))
        let packageSource = try #require(checkouts.packageSource(location: "https://github.com/test/test-Test.git"))
        #expect(packageSource.url.path() == "/test/checkouts/test-Test")
    }
}
