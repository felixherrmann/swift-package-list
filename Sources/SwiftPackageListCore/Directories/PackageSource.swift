//
//  PackageSource.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation

struct PackageSource: Directory {
    let url: URL
}

extension PackageSource {
    var license: License? {
        get throws {
            return try FileManager.default
                .contentsOfDirectory(
                    at: url.resolvingSymlinksInPath(),
                    includingPropertiesForKeys: [.isRegularFileKey],
                    options: .skipsHiddenFiles
                )
                .filter { (try? $0.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true }
                .compactMap(License.init(uncheckedURL:))
                .first
        }
    }
}
