//
//  TableGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import Testing
import SwiftPackageList

@testable import SwiftPackageListCore

struct TableGeneratorTests {
    @Test func output() throws {
        let packages = [
            package(
                name: "Z Package",
                kind: .remoteSourceControl,
                version: "1.0.0",
                branch: "main",
                revision: "abcdef012345",
                license: "MIT"
            ),
            package(name: "A Package", kind: .registry, branch: "develop", revision: "abcdef012345"),
            package(name: "Commit", kind: .localSourceControl, revision: "abcdef012345", license: ""),
            package(name: "Custom"),
        ]

        #expect(try output(packages: packages) == """
        PACKAGE    VERSION/REF  LICENSE
        Z Package  1.0.0        Found
        A Package  develop      Missing
        Commit     abcdef0      Missing
        Custom     —            Missing

        """)
    }

    @Test func emptyPackages() throws {
        #expect(try output(packages: []) == "PACKAGE  VERSION/REF  LICENSE\n")
    }

    @Test func preservesUnicode() throws {
        let packages = [
            package(name: "工具"),
            package(name: "Cafe\u{301}"),
            package(name: "👩🏽‍💻"),
            package(name: "🇩🇪"),
            package(name: "❤️"),
        ]

        let table = try output(packages: packages)
        for package in packages {
            #expect(table.contains(package.name))
        }
    }

    @Test func sanitizesControlCharacters() throws {
        let packages = [package(name: "A\nB\tC\rD\u{1B}[31m", branch: "main\u{2028}branch")]
        let table = try output(packages: packages)

        #expect(table.split(separator: "\n").count == 2)
        #expect(table.contains("A B C D [31m"))
        #expect(table.contains("main branch"))
        #expect(!table.contains("\u{1B}"))
    }

    @Test func preservesLongValues() throws {
        let name = String(repeating: "long-package-name", count: 10)
        let branch = String(repeating: "long-branch-name", count: 10)
        let table = try output(packages: [package(name: name, branch: branch)])
        #expect(table.contains(name))
        #expect(table.contains(branch))
    }

    private func package(
        name: String,
        kind: Package.Kind = .custom,
        version: String? = nil,
        branch: String? = nil,
        revision: String? = nil,
        license: String? = nil
    ) -> Package {
        Package(
            kind: kind,
            identity: name,
            name: name,
            version: version,
            branch: branch,
            revision: revision,
            location: "",
            license: license
        )
    }

    private func output(packages: [Package]) throws -> String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("package-table-\(UUID()).txt")
        defer { try? FileManager.default.removeItem(at: url) }

        let generator = TableGenerator(outputDestination: .file(url: url), packages: packages)
        try generator.generateOutput()
        return try String(contentsOf: url, encoding: .utf8)
    }
}
