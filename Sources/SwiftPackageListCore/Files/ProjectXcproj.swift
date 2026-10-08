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
    struct Content: Decodable {
        let organization: String?
    }
    
    var content: Content {
        get throws {
            let decoder = JSONDecoder()
            let data = try Data(contentsOf: url)
            return try decoder.decode(Content.self, from: data)
        }
    }
}
