//
//  TableGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import SwiftPackageList

struct TableGenerator: OutputGenerator {
    let outputDestination: OutputDestination
    let packages: [Package]

    func generateOutput() throws {
        let rows: [Row] = [.header] + packages.map(Row.init(package:))
        let widths = rows[0].cells.indices.map { index in
            return rows.map { $0.cells[index].width }.max() ?? 0
        }
        let lines = rows.map { $0.render(widths: widths) }
        let content = lines.joined(separator: "\n") + "\n"
        let data = Data(content.utf8)
        try outputDestination.write(data: data)
    }
}

extension TableGenerator {
    private struct Row {
        let cells: [Cell]

        static var header: Row {
            return Row(values: ["PACKAGE", "VERSION/REF", "LICENSE"])
        }

        init(package: Package) {
            let reference = package.version ?? package.branch ?? package.revision.map { String($0.prefix(7)) } ?? "—"
            let license = package.hasLicense ? "Found" : "Missing"
            self.cells = [package.name, reference, license].map(Cell.init(_:))
        }

        init(values: [String]) {
            self.cells = values.map(Cell.init(_:))
        }

        func render(widths: [Int]) -> String {
            return cells.indices
                .map { index in
                    if index == cells.index(before: cells.endIndex) {
                        return cells[index].text
                    } else {
                        return cells[index].padded(to: widths[index])
                    }
                }
                .joined(separator: "  ")
        }
    }

    private struct Cell {
        let text: String

        var width: Int {
            return text.count
        }

        init(_ value: String) {
            let characters = value.unicodeScalars.map { scalar -> Character in
                switch scalar.properties.generalCategory {
                case .control, .lineSeparator, .paragraphSeparator:
                    return " "
                default:
                    return Character(String(scalar))
                }
            }
            text = String(characters)
        }

        func padded(to width: Int) -> String {
            let count = max(0, width - self.width)
            return text + String(repeating: " ", count: count)
        }
    }
}
