//
//  OutputType.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.03.22.
//

import Foundation
import SwiftPackageList

public enum OutputType: String, CaseIterable {
    case json
    case plist
    case settingsBundle = "settings-bundle"
    case pdf
}

extension OutputType {
    public func outputGenerator(
        packages: [Package],
        project: some Project,
        options: OutputGeneratorOptions = OutputGeneratorOptions()
    ) throws -> any OutputGenerator {
        switch self {
        case .json:
            let outputDestination = outputDestination(fileName: "package-list", extension: "json", options: options)
            return JSONGenerator(outputDestination: outputDestination, packages: packages)
        case .plist:
            let outputDestination = outputDestination(fileName: "package-list", extension: "plist", options: options)
            return PropertyListGenerator(outputDestination: outputDestination, packages: packages)
        case .settingsBundle:
            let outputURL = try outputURL(fileName: "Settings", extension: "bundle", options: options)
            return SettingsBundleGenerator(outputURL: outputURL, packages: packages)
        case .pdf:
            let outputURL = try outputURL(fileName: "Acknowledgments", extension: "pdf", options: options)
            return PDFGenerator(outputURL: outputURL, packages: packages, project: project)
        }
    }

    private func outputURL(fileName: String, extension: String, options: OutputGeneratorOptions) throws -> URL {
        guard let outputURL = options.outputURL else {
            throw RuntimeError("Output path is required for output type '\(rawValue)'")
        }
        let fileName = options.customFileName ?? fileName
        return outputURL.appendingPathComponent(fileName).appendingPathExtension(`extension`)
    }

    private func outputDestination(fileName: String, extension: String, options: OutputGeneratorOptions) -> OutputDestination {
        if let outputURL = options.outputURL {
            let fileName = options.customFileName ?? fileName
            let url = outputURL.appendingPathComponent(fileName).appendingPathExtension(`extension`)
            return .file(url: url)
        } else {
            return .stdout
        }
    }
}
