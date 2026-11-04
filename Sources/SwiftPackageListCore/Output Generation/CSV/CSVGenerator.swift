//
//  CSVGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation
import SwiftPackageList

struct CSVGenerator: OutputGenerator {
    let outputDestination: OutputDestination
    let packages: [Package]

    func generateOutput() throws {
        var csv = "kind,identity,name,version,branch,revision,location,hasLicense\r\n"
        for package in packages {
            let fields = [
                package.kind.rawValue,
                package.identity,
                package.name,
                package.version ?? "",
                package.branch ?? "",
                package.revision ?? "",
                package.location,
                String(package.hasLicense),
            ]
            csv += fields.map(escape(_:)).joined(separator: ",") + "\r\n"
        }

        let data = Data(csv.utf8)
        try outputDestination.write(data: data)
    }

    private func escape(_ field: String) -> String {
        guard field.rangeOfCharacter(from: CharacterSet(charactersIn: ",\"\r\n")) != nil else {
            return field
        }
        return "\"" + field.replacingOccurrences(of: "\"", with: "\"\"") + "\""
    }
}
