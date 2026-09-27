//
//  LicenseTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct LicenseTests {
    @Test func initUncheckedURLDisallowed() {
        #expect(License(uncheckedURL: URL(fileURLWithPath: "/test/TEST")) == nil)
    }

    @Test func initUncheckedURLAllowed() {
        #expect(License(uncheckedURL: URL(fileURLWithPath: "/test/LICENSE")) != nil)
        #expect(License(uncheckedURL: URL(fileURLWithPath: "/test/Licence")) != nil)
        #expect(License(uncheckedURL: URL(fileURLWithPath: "/test/copying")) != nil)
        #expect(License(uncheckedURL: URL(fileURLWithPath: "/test/UNLICENSE")) != nil)
    }
}
