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
        let options = OutputGeneratorOptions(outputURL: URL(fileURLWithPath: "/User/test/Desktop"))

        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project, options: options)
        let jsonGenerator = try #require(anyJSONGenerator as? JSONGenerator)
        #expect(jsonGenerator.outputURL.path == "/User/test/Desktop/package-list.json")

        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project, options: options)
        let plistGenerator = try #require(anyPlistGenerator as? PropertyListGenerator)
        #expect(plistGenerator.outputURL.path == "/User/test/Desktop/package-list.plist")

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
    }

    @Test func customOutputURL() throws {
        let project = XcodeProject(fileURL: URL(fileURLWithPath: ""), options: ProjectOptions())
        let options = OutputGeneratorOptions(outputURL: URL(fileURLWithPath: "/User/test/Desktop"), customFileName: "test")

        let anyJSONGenerator = try OutputType.json.outputGenerator(packages: [], project: project, options: options)
        let jsonGenerator = try #require(anyJSONGenerator as? JSONGenerator)
        #expect(jsonGenerator.outputURL.path == "/User/test/Desktop/test.json")

        let anyPlistGenerator = try OutputType.plist.outputGenerator(packages: [], project: project, options: options)
        let plistGenerator = try #require(anyPlistGenerator as? PropertyListGenerator)
        #expect(plistGenerator.outputURL.path == "/User/test/Desktop/test.plist")

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
    }
}
