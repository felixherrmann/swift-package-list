//
//  CSVGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import Testing
import SwiftPackageList

@testable import SwiftPackageListCore

struct CSVGeneratorTests {
    @Test func output() throws {
        let packages = [
            Package(
                kind: .remoteSourceControl,
                identity: "z-package",
                name: "Z Package",
                version: "1.0.0",
                branch: nil,
                revision: "abcd",
                location: "https://example.com/z-package",
                license: "MIT"
            ),
            Package(
                kind: .registry,
                identity: "scope.a-package",
                name: "A Package",
                version: "2.0.0",
                branch: nil,
                revision: nil,
                location: "",
                license: nil
            ),
        ]
        let csv = try output(packages: packages)

        #expect(csv == "kind,identity,name,version,branch,revision,location,hasLicense\r\n"
            + "remoteSourceControl,z-package,Z Package,1.0.0,,abcd,https://example.com/z-package,true\r\n"
            + "registry,scope.a-package,A Package,2.0.0,,,,false\r\n")
    }

    @Test(arguments: [",", "\"", "\n", "\r", "\r\n", "comma, and \"quotes\"\r\nCopyright © 2026 🦉"])
    func escapesFields(value: String) throws {
        let package = Package(
            kind: Package.Kind(rawValue: value),
            identity: value,
            name: value,
            version: value,
            branch: value,
            revision: value,
            location: value,
            license: value
        )
        let csv = try output(packages: [package])
        let escaped: String
        switch value {
        case ",": escaped = "\",\""
        case "\"": escaped = "\"\"\"\""
        case "\n": escaped = "\"\n\""
        case "\r": escaped = "\"\r\""
        case "\r\n": escaped = "\"\r\n\""
        default: escaped = "\"comma, and \"\"quotes\"\"\r\nCopyright © 2026 🦉\""
        }

        #expect(csv == "kind,identity,name,version,branch,revision,location,hasLicense\r\n"
            + Array(repeating: escaped, count: 7).joined(separator: ",") + ",true\r\n")
    }

    @Test func emptyValues() throws {
        let package = Package(
            kind: .custom,
            identity: "custom-package",
            name: "Paquet français 🦉",
            version: nil,
            branch: "main",
            revision: nil,
            location: "",
            license: ""
        )
        let csv = try output(packages: [package])

        #expect(csv == "kind,identity,name,version,branch,revision,location,hasLicense\r\n"
            + "custom,custom-package,Paquet français 🦉,,main,,,false\r\n")
    }

    @Test func emptyPackages() throws {
        #expect(try output(packages: []) == "kind,identity,name,version,branch,revision,location,hasLicense\r\n")
    }

    private func output(packages: [Package]) throws -> String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("package-list-\(UUID()).csv")
        defer { try? FileManager.default.removeItem(at: url) }

        let generator = CSVGenerator(outputDestination: .file(url: url), packages: packages)
        try generator.generateOutput()
        return try String(contentsOf: url, encoding: .utf8)
    }
}
