//
//  MarkdownGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import Testing
import SwiftPackageList

@testable import SwiftPackageListCore

struct MarkdownGeneratorTests {
    @Test func output() throws {
        let project = TestProject(name: "Test App", organizationName: "Test Organization")
        let license = "\nCopyright © 2026\n\n    Permission is granted.\n"
        let packages = [package(name: "Z Package", license: license), package(name: "A Package", license: "MIT")]
        let markdown = try output(packages: packages, project: project)

        #expect(markdown.hasPrefix("# Test App Acknowledgments\n"))
        #expect(markdown.contains("Portions of this Test Organization Software"))
        #expect(markdown.contains("\n## Z Package\n\n```\n\(license)```\n\n## A Package\n"))
        let firstHeading = try #require(markdown.range(of: "## Z Package\n"))
        let secondHeading = try #require(markdown.range(of: "## A Package\n"))
        #expect(firstHeading.lowerBound < secondHeading.lowerBound)
        #expect(markdown.hasSuffix("## A Package\n\n```\nMIT\n```\n"))
    }

    @Test func escapesMetadata() throws {
        let text = "[A](url) *B* <script> &copy; `C` \\D\r\n## Heading"
        let escaped = "\\[A\\]\\(url\\) \\*B\\* \\<script\\> \\&copy; \\`C\\` \\\\D \\#\\# Heading"
        let project = TestProject(name: text, organizationName: text)
        let markdown = try output(packages: [package(name: text, license: "MIT")], project: project)

        #expect(markdown.hasPrefix("# \(escaped) Acknowledgments\n"))
        #expect(markdown.contains("Portions of this \(escaped) Software"))
        #expect(markdown.contains("\n## \(escaped)\n"))
    }

    @Test(arguments: ["```", "````", "`````"])
    func embeddedFences(backticks: String) throws {
        let license = "# License\n\n**Copyright** [Example](https://example.com)\n\n\(backticks)\n<script> &copy;\n\(backticks)"
        let markdown = try output(packages: [package(name: "Package", license: license)])
        let fence = backticks + "`"

        #expect(markdown.hasSuffix("\n## Package\n\n\(fence)\n\(license)\n\(fence)\n"))
    }

    @Test func preservesIndentedLicense() throws {
        let license = "    Apache License\n    Version 2.0, January 2004\n\n1. Definitions.\n\n    Indented definition.\n"
        let markdown = try output(packages: [package(name: "Package", license: license)])

        #expect(markdown.hasSuffix("\n## Package\n\n```\n\(license)```\n"))
    }

    @Test func missingLicense() throws {
        let markdown = try output(packages: [package(name: "Package", license: nil)])
        #expect(markdown.hasSuffix("\n## Package\n\n```\nNo license\n```\n"))
        #expect(markdown.contains("Portions of this Software"))
    }

    @Test func emptyPackages() throws {
        let markdown = try output(packages: [])
        #expect(markdown.hasPrefix("# Test Acknowledgments\n"))
        #expect(!markdown.contains("\n## "))
        #expect(!markdown.contains("```"))
        #expect(markdown.hasSuffix("acknowledged.\n"))
    }

    private func output(packages: [Package], project: TestProject = TestProject()) throws -> String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Acknowledgments-\(UUID()).md")
        defer { try? FileManager.default.removeItem(at: url) }

        let generator = MarkdownGenerator(outputDestination: .file(url: url), packages: packages, project: project)
        try generator.generateOutput()
        return try String(contentsOf: url, encoding: .utf8)
    }

    private func package(name: String, license: String?) -> Package {
        return Package(
            kind: .custom,
            identity: name,
            name: name,
            version: nil,
            branch: nil,
            revision: nil,
            location: "",
            license: license
        )
    }

    private struct TestProject: Project {
        let fileURL = URL(fileURLWithPath: "/Test/Package.swift")
        let options = ProjectOptions()
        var name = "Test"
        var organizationName: String?

        func packages() throws -> [Package] {
            return []
        }
    }
}
