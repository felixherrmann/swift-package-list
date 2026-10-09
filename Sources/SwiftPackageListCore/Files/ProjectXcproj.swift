//
//  ProjectXcproj.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 08.10.26.
//

import Foundation

struct ProjectXcproj: File {
    let url: URL
}

extension ProjectXcproj {
    var organizationName: String? {
        return try? content.organization
    }
}

extension ProjectXcproj {
    private struct Content: Decodable {
        let organization: String?
    }
    
    private var content: Content {
        get throws {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            return try decoder.decode(Content.self, from: data)
        }
    }
}
