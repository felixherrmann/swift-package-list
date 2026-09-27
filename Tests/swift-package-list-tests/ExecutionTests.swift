//
//  ExecutionTests.swift
//  swift-package-list-tests
//
//  Created by Felix Herrmann on 18.05.22.
//

import Foundation
import Testing

struct ExecutionTests {
    private final class BundleMarker { }

    private var productsDirectory: URL {
        let bundle = Bundle(for: BundleMarker.self)
        return bundle.bundleURL.deletingLastPathComponent()
    }

    @Test func commandExecution() throws {
        let swiftPackageListBinary = productsDirectory.appendingPathComponent("swift-package-list")

        let process = Process()
        process.executableURL = swiftPackageListBinary
        process.arguments = ["--version"]

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)

        let versionNumbers = output.split(separator: ".")
        #expect(versionNumbers.count == 3)
        #expect(versionNumbers.allSatisfy { Int($0) != nil })
    }
}
