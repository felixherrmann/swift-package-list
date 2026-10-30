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

    @Test func preferredLicenseFileWins() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        for name in ["COPYING", "LICENSE-MIT", "LICENSE.md", "LICENSE"] {
            try name.write(to: directory.appendingPathComponent(name), atomically: true, encoding: .utf8)
        }

        try FileManager.default.createDirectory(
            at: directory.appendingPathComponent("LICENSE.txt"),
            withIntermediateDirectories: false
        )

        #expect(try PackageSource(url: directory).license?.content == "LICENSE")
    }

    @Test func comparableOrdersByFilenamePreference() {
        let names = ["PATENTS", "LICENSE-MIT", "COPYING", "LICENSE.md", "LICENSE"]
        let licenses = names.compactMap { License(uncheckedURL: URL(fileURLWithPath: "/test/\($0)")) }

        #expect(licenses.sorted().map(\.url.lastPathComponent) == ["LICENSE", "LICENSE.md", "COPYING", "LICENSE-MIT", "PATENTS"])
    }
}
