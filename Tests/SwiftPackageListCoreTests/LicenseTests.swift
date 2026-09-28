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
    @Test(arguments: [
        "TEST", "license.spdx", "license.header", "LICENSED", "LICENSE-MIT.sh", "COPYING-MIT.xml",
    ])
    func initUncheckedURLDisallowed(filename: String) {
        let url = URL(fileURLWithPath: "/test/\(filename)")
        #expect(License(uncheckedURL: url) == nil)
    }

    @Test(arguments: [
        "LICENSE", "Licence", "copying", "UNLICENSE", "LICENSE-MIT", "MIT-LICENSE.md", "COPYING.txt", "LICENSE.2.0", "OFL.md",
        "COPYRIGHT", "PATENTS",
    ])
    func initUncheckedURLAllowed(filename: String) {
        let url = URL(fileURLWithPath: "/test/\(filename)")
        #expect(License(uncheckedURL: url) != nil)
    }
}
