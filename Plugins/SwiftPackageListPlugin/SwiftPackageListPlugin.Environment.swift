//
//  SwiftPackageListPlugin.Environment.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 21.10.26.
//

import Foundation

extension SwiftPackageListPlugin {
    struct Environment {
        let rawValue: String
    }
}

extension SwiftPackageListPlugin.Environment {
    static var current: SwiftPackageListPlugin.Environment? {
        guard let rawValue = ProcessInfo.processInfo.environment["SWIFT_PACKAGE_LIST_PLUGIN_ENVIRONMENT"] else { return nil }
        guard !rawValue.isEmpty else { return nil }
        return SwiftPackageListPlugin.Environment(rawValue: rawValue)
    }
}
