//
//  MarkdownGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import SwiftPackageList

struct MarkdownGenerator: OutputGenerator {
    let outputDestination: OutputDestination
    let packages: [Package]
    let projectName: String
    let organizationName: String?

    init(outputDestination: OutputDestination, packages: [Package], project: some Project) {
        self.outputDestination = outputDestination
        self.packages = packages
        self.projectName = project.name
        self.organizationName = project.organizationName
    }

    func generateOutput() throws {
        let organizationText = organizationName.map { escape($0) + " " } ?? ""
        var markdown = """
        # \(escape(projectName)) Acknowledgments

        Portions of this \(organizationText)Software may utilize the following copyrighted material, \
        the use of which is hereby acknowledged.

        """
        for package in packages {
            let license = package.license ?? "No license"
            let fence = fence(for: license)
            markdown += "\n## \(escape(package.name))\n\n\(fence)\n\(license)"
            if !license.hasSuffix("\n") {
                markdown += "\n"
            }
            markdown += "\(fence)\n"
        }
        try outputDestination.write(data: Data(markdown.utf8))
    }

    private func escape(_ string: String) -> String {
        var escaped = string
            .replacingOccurrences(of: "\r\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
            .replacingOccurrences(of: "\n", with: " ")
        let punctuation = ["\\", "`", "*", "_", "{", "}", "[", "]", "(", ")", "#", "+", "-", ".", "!", "<", ">", "|", "~", "&"]
        for character in punctuation {
            escaped = escaped.replacingOccurrences(of: character, with: "\\" + character)
        }
        return escaped
    }

    private func fence(for license: String) -> String {
        var longestRun = 0
        var currentRun = 0
        for character in license {
            if character == "`" {
                currentRun += 1
                longestRun = max(longestRun, currentRun)
            } else {
                currentRun = 0
            }
        }
        return String(repeating: "`", count: max(3, longestRun + 1))
    }
}
