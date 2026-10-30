//
//  HTMLGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import SwiftPackageList

struct HTMLGenerator: OutputGenerator {
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
        let organizationText = organizationName.map { $0 + " " } ?? ""
        let sections = packages.map { package in
            let license = package.license ?? "No license"
            // HTML discards the first newline after <pre>; add one to preserve the license text.
            // swiftlint:disable indentation_width
            return """
                    <section>
                        <h2>\(escape(package.name))</h2>
                        <pre>
            \(escape(license))</pre>
                    </section>
            """
            // swiftlint:enable indentation_width
        }

        let html = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <title>\(escape(projectName)) Acknowledgments</title>
            <style>
                :root { color-scheme: light dark; }
                body { font-family: system-ui, sans-serif; line-height: 1.5; margin: 0 auto; max-width: 60rem; padding: 2rem; }
                section { margin-top: 2rem; }
                pre { font: inherit; white-space: pre-wrap; overflow-wrap: anywhere; }
            </style>
        </head>
        <body>
            <main>
                <h1>Acknowledgments</h1>
                <p>Portions of this \(escape(organizationText))Software may utilize the following copyrighted material, \
        the use of which is hereby acknowledged.</p>
        \(sections.joined(separator: "\n"))
            </main>
        </body>
        </html>

        """
        let data = Data(html.utf8)
        try outputDestination.write(data: data)
    }

    private func escape(_ string: String) -> String {
        return string
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
            .replacingOccurrences(of: "'", with: "&#39;")
    }
}
