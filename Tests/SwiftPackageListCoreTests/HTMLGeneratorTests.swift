//
//  HTMLGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import Testing
import SwiftPackageList

@testable import SwiftPackageListCore

struct HTMLGeneratorTests {
    @Test func output() throws {
        let project = TestProject(name: "Test App", organizationName: "Test Organization")
        let license = "\nCopyright © 2026\n\n    Permission is granted.\n"
        let packages = [package(name: "Z Package", license: license), package(name: "A Package", license: "MIT")]
        let html = try output(packages: packages, project: project)

        #expect(html.hasPrefix("<!DOCTYPE html>\n"))
        #expect(html.contains("<meta charset=\"utf-8\">"))
        #expect(html.contains("<title>Test App Acknowledgments</title>"))
        #expect(html.contains("Portions of this Test Organization Software"))
        #expect(html.contains("<pre>\n\(license)</pre>"))
        let firstHeading = try #require(html.range(of: "<h2>Z Package</h2>"))
        let secondHeading = try #require(html.range(of: "<h2>A Package</h2>"))
        #expect(firstHeading.lowerBound < secondHeading.lowerBound)
        #expect(html.hasSuffix("</html>\n"))
    }

    @Test func escapesContent() throws {
        let text = "<script>alert(\"A & B's\")</script> &lt;"
        let project = TestProject(name: text, organizationName: text)
        let html = try output(packages: [package(name: text, license: text)], project: project)
        let escaped = "&lt;script&gt;alert(&quot;A &amp; B&#39;s&quot;)&lt;/script&gt; &amp;lt;"

        #expect(!html.contains("<script>"))
        #expect(html.contains("<title>\(escaped) Acknowledgments</title>"))
        #expect(html.contains("Portions of this \(escaped) Software"))
        #expect(html.contains("<h2>\(escaped)</h2>"))
        #expect(html.contains("<pre>\n\(escaped)</pre>"))
    }

    @Test func missingLicense() throws {
        let html = try output(packages: [package(name: "Package", license: nil)])
        #expect(html.contains("<pre>\nNo license</pre>"))
        #expect(html.contains("Portions of this Software"))
    }

    @Test func emptyPackages() throws {
        let html = try output(packages: [])
        #expect(html.contains("<h1>Acknowledgments</h1>"))
        #expect(!html.contains("<section>"))
        #expect(html.hasSuffix("</html>\n"))
    }

    private func output(packages: [Package], project: TestProject = TestProject()) throws -> String {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("Acknowledgments-\(UUID()).html")
        defer { try? FileManager.default.removeItem(at: url) }

        let generator = HTMLGenerator(outputDestination: .file(url: url), packages: packages, project: project)
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
