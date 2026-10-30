//
//  PDFGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import Foundation
import Testing
import PDFKit
import SwiftPackageList

@testable import SwiftPackageListCore

final class PDFGeneratorTests {
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Acknowledgements-\(UUID()).pdf")

    init() throws {
        let url = try #require(
            Bundle.module.url(
                forResource: "Project",
                withExtension: "xcodeproj",
                subdirectory: "Resources/XcodeProject/pbxproj"
            )
        )
        let projectType = try ProjectType(fileURL: url)
        let project = try projectType.project(fileURL: url)
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

        let pdfGenerator = PDFGenerator(outputURL: outputURL, packages: [package], project: project)
        try pdfGenerator.generateOutput()
    }

    deinit {
        try? FileManager.default.removeItem(at: outputURL)
    }

    @Test func output() throws {
        let output = try #require(PDFDocument(url: outputURL))

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy"
        let creationDate = dateFormatter.string(from: Date())

        let attributes = try #require(output.documentAttributes)
        #expect(attributes["Author"] as? String == "Swift Package List")
        #expect(attributes["Subject"] as? String == "Project Acknowledgements")
        #expect(attributes["Title"] as? String == "Project_Acks_File_\(creationDate)")
        #expect(attributes["Creator"] as? String == "swift-package-list")

        let expectedOutput: String
        if #available(macOS 15.0, *) {
            expectedOutput = """
            Acknowledgements
            Portions of this Swift Package List Software may utilize the following copyrighted
            material, the use of which is hereby acknowledged.
            test
            MIT
            """
        } else {
            expectedOutput = """
            Acknowledgements
            Portions of this Swift Package List Software may utilize the following \
            copyrighted material, the use of which is hereby acknowledged.
            test
            MIT

            """
        }
        #expect(output.string == expectedOutput)
    }
}
