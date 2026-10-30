//
//  JSONGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import Foundation
import Testing
import SwiftPackageList

@testable import SwiftPackageListCore

final class JSONGeneratorTests {
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("package-list-\(UUID()).json")

    init() throws {
        let package = Package(
            kind: .remoteSourceControl,
            identity: "test",
            name: "test",
            version: "1.0.0",
            branch: nil,
            revision: "xxxx",
            location: "https://github.com/test/test",
            license: "MIT"
        )

        let jsonGenerator = JSONGenerator(outputDestination: .file(url: outputURL), packages: [package])
        try jsonGenerator.generateOutput()
    }

    deinit {
        try? FileManager.default.removeItem(at: outputURL)
    }

    @Test func output() throws {
        let output = try String(contentsOf: outputURL)
        // swiftlint:disable indentation_width
        let expectedOutput = """
        [
          {
            "identity" : "test",
            "kind" : "remoteSourceControl",
            "license" : "MIT",
            "location" : "https:\\/\\/github.com\\/test\\/test",
            "name" : "test",
            "revision" : "xxxx",
            "version" : "1.0.0"
          }
        ]
        """
        // swiftlint:enable indentation_width
        #expect(output == expectedOutput)
    }
}
