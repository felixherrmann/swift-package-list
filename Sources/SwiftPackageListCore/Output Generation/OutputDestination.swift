//
//  OutputDestination.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 30.10.26.
//

import Foundation

enum OutputDestination: Hashable {
    case file(url: URL)
    case stdout
}

extension OutputDestination {
    func write(data: Data) throws {
        switch self {
        case .file(url: let url):
            try data.write(to: url)
            print("Generated \(url.path)")
        case .stdout:
            try FileHandle.standardOutput.write(contentsOf: data)
        }
    }
}
