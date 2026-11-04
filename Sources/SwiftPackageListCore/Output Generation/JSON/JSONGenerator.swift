//
//  JSONGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import SwiftPackageList

struct JSONGenerator: OutputGenerator {
    let outputDestination: OutputDestination
    let packages: [Package]

    private let jsonEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }()

    func generateOutput() throws {
        let data = try jsonEncoder.encode(packages)
        try outputDestination.write(data: data)
    }
}
