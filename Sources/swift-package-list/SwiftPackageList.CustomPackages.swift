//
//  SwiftPackageList.CustomPackages.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 17.02.25.
//

import Foundation
import SwiftPackageList

extension SwiftPackageList {
    struct CustomPackages {
        let url: URL
    }
}

extension SwiftPackageList.CustomPackages {
    func packages() throws -> [Package] {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Package].self, from: data)
    }
}
