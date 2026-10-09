//
//  ProjectPbxproj.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 26.12.23.
//

import Foundation

struct ProjectPbxproj: File {
    let url: URL
}

extension ProjectPbxproj {
    var organizationName: String? {
        guard let content = try? content else { return nil }
        return content.objects[content.rootObject]?.attributes?.ORGANIZATIONNAME
    }
}

extension ProjectPbxproj {
    private struct Content: Decodable {
        struct Object: Decodable {
            struct Attributes: Decodable {
                let ORGANIZATIONNAME: String?
            }
            
            let attributes: Attributes?
        }
        
        let rootObject: String
        let objects: [String: Object]
    }
    
    private var content: Content {
        get throws {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: url)
            return try decoder.decode(Content.self, from: data)
        }
    }
}
