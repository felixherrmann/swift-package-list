//
//  OutputType.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

public enum OutputType: String, CaseIterable {
    case table
    case csv
    case json
    case plist
    case markdown
    case html
    case pdf
    case settingsBundle = "settings-bundle"
}

extension OutputType {
    public func outputGenerator(
        packages: [Package],
        project: some Project,
        options: OutputGeneratorOptions = OutputGeneratorOptions()
    ) throws -> any OutputGenerator {
        switch self {
        case .table:
            let outputDestination = outputDestination(filename: "package-table", extension: "txt", options: options)
            return TableGenerator(outputDestination: outputDestination, packages: packages)
        case .csv:
            let outputDestination = outputDestination(filename: "package-list", extension: "csv", options: options)
            return CSVGenerator(outputDestination: outputDestination, packages: packages)
        case .json:
            let outputDestination = outputDestination(filename: "package-list", extension: "json", options: options)
            return JSONGenerator(outputDestination: outputDestination, packages: packages)
        case .plist:
            let outputDestination = outputDestination(filename: "package-list", extension: "plist", options: options)
            return PropertyListGenerator(outputDestination: outputDestination, packages: packages)
        case .markdown:
            let outputDestination = outputDestination(filename: "Acknowledgments", extension: "md", options: options)
            return MarkdownGenerator(outputDestination: outputDestination, packages: packages, project: project)
        case .html:
            let outputDestination = outputDestination(filename: "Acknowledgments", extension: "html", options: options)
            return HTMLGenerator(outputDestination: outputDestination, packages: packages, project: project)
        case .pdf:
            let outputURL = try outputURL(filename: "Acknowledgments", extension: "pdf", options: options)
            return PDFGenerator(outputURL: outputURL, packages: packages, project: project)
        case .settingsBundle:
            let outputURL = try outputURL(filename: "Settings", extension: "bundle", options: options)
            return SettingsBundleGenerator(outputURL: outputURL, packages: packages)
        }
    }

    private func outputURL(filename: String, extension: String, options: OutputGeneratorOptions) throws -> URL {
        guard let outputURL = options.outputURL else {
            throw RuntimeError("Output path is required for output type '\(rawValue)'")
        }
        let filename = options.customFilename ?? filename
        return outputURL.appendingPathComponent(filename).appendingPathExtension(`extension`)
    }

    private func outputDestination(filename: String, extension: String, options: OutputGeneratorOptions) -> OutputDestination {
        if let outputURL = options.outputURL {
            let filename = options.customFilename ?? filename
            let url = outputURL.appendingPathComponent(filename).appendingPathExtension(`extension`)
            return .file(url: url)
        } else {
            return .stdout
        }
    }
}
