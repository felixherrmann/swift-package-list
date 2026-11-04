//
//  OutputTypeTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct OutputTypeTests {
    @Test func outputURL() throws {
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())
        let outputURL = URL(fileURLWithPath: "/User/test/Desktop")
        let options = OutputGeneratorOptions(outputURL: outputURL)

        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project, options: options)
        let jsonGenerator = try #require(anyJSONGenerator as? JSONGenerator)
        #expect(jsonGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("package-list.json")))

        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project, options: options)
        let plistGenerator = try #require(anyPlistGenerator as? PropertyListGenerator)
        #expect(plistGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("package-list.plist")))

        let anySettingsBundleGenerator = try OutputType.settingsBundle.outputGenerator(
            packages: [],
            project: project,
            options: options
        )
        let settingsBundleGenerator = try #require(anySettingsBundleGenerator as? SettingsBundleGenerator)
        #expect(settingsBundleGenerator.outputURL.path == "/User/test/Desktop/Settings.bundle")

        let anyPDFGenerator = try OutputType.pdf.outputGenerator(packages: [], project: project, options: options)
        let pdfGenerator = try #require(anyPDFGenerator as? PDFGenerator)
        #expect(pdfGenerator.outputURL.path == "/User/test/Desktop/Acknowledgments.pdf")

        let anyHTMLGenerator = try OutputType.html.outputGenerator(packages: [], project: project, options: options)
        let htmlGenerator = try #require(anyHTMLGenerator as? HTMLGenerator)
        #expect(htmlGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("Acknowledgments.html")))

        let anyMarkdownGenerator = try OutputType.markdown.outputGenerator(packages: [], project: project, options: options)
        let markdownGenerator = try #require(anyMarkdownGenerator as? MarkdownGenerator)
        #expect(markdownGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("Acknowledgments.md")))

        let anyCSVGenerator = try OutputType.csv.outputGenerator(packages: [], project: project, options: options)
        let csvGenerator = try #require(anyCSVGenerator as? CSVGenerator)
        #expect(csvGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("package-list.csv")))

        let anyTableGenerator = try OutputType.table.outputGenerator(packages: [], project: project, options: options)
        let tableGenerator = try #require(anyTableGenerator as? TableGenerator)
        #expect(tableGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("package-table.txt")))
    }

    @Test func customOutputURL() throws {
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())
        let outputURL = URL(fileURLWithPath: "/User/test/Desktop")
        let options = OutputGeneratorOptions(outputURL: outputURL, customFilename: "test")

        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project, options: options)
        let jsonGenerator = try #require(anyJSONGenerator as? JSONGenerator)
        #expect(jsonGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("test.json")))

        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project, options: options)
        let plistGenerator = try #require(anyPlistGenerator as? PropertyListGenerator)
        #expect(plistGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("test.plist")))

        let anySettingsBundleGenerator = try OutputType.settingsBundle.outputGenerator(
            packages: [],
            project: project,
            options: options
        )
        let settingsBundleGenerator = try #require(anySettingsBundleGenerator as? SettingsBundleGenerator)
        #expect(settingsBundleGenerator.outputURL.path == "/User/test/Desktop/test.bundle")

        let anyPDFGenerator = try OutputType.pdf.outputGenerator(packages: [], project: project, options: options)
        let pdfGenerator = try #require(anyPDFGenerator as? PDFGenerator)
        #expect(pdfGenerator.outputURL.path == "/User/test/Desktop/test.pdf")

        let anyHTMLGenerator = try OutputType.html.outputGenerator(packages: [], project: project, options: options)
        let htmlGenerator = try #require(anyHTMLGenerator as? HTMLGenerator)
        #expect(htmlGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("test.html")))

        let anyMarkdownGenerator = try OutputType.markdown.outputGenerator(packages: [], project: project, options: options)
        let markdownGenerator = try #require(anyMarkdownGenerator as? MarkdownGenerator)
        #expect(markdownGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("test.md")))

        let anyCSVGenerator = try OutputType.csv.outputGenerator(packages: [], project: project, options: options)
        let csvGenerator = try #require(anyCSVGenerator as? CSVGenerator)
        #expect(csvGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("test.csv")))

        let anyTableGenerator = try OutputType.table.outputGenerator(packages: [], project: project, options: options)
        let tableGenerator = try #require(anyTableGenerator as? TableGenerator)
        #expect(tableGenerator.outputDestination == .file(url: outputURL.appendingPathComponent("test.txt")))
    }

    @Test func standardOutput() throws {
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())

        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project)
        let jsonGenerator = try #require(anyJSONGenerator as? JSONGenerator)
        #expect(jsonGenerator.outputDestination == .stdout)

        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project)
        let plistGenerator = try #require(anyPlistGenerator as? PropertyListGenerator)
        #expect(plistGenerator.outputDestination == .stdout)

        let anyHTMLGenerator = try OutputType.html.outputGenerator(packages: [], project: project)
        let htmlGenerator = try #require(anyHTMLGenerator as? HTMLGenerator)
        #expect(htmlGenerator.outputDestination == .stdout)

        let anyMarkdownGenerator = try OutputType.markdown.outputGenerator(packages: [], project: project)
        let markdownGenerator = try #require(anyMarkdownGenerator as? MarkdownGenerator)
        #expect(markdownGenerator.outputDestination == .stdout)

        let anyCSVGenerator = try OutputType.csv.outputGenerator(packages: [], project: project)
        let csvGenerator = try #require(anyCSVGenerator as? CSVGenerator)
        #expect(csvGenerator.outputDestination == .stdout)

        let anyTableGenerator = try OutputType.table.outputGenerator(packages: [], project: project)
        let tableGenerator = try #require(anyTableGenerator as? TableGenerator)
        #expect(tableGenerator.outputDestination == .stdout)
    }
}
