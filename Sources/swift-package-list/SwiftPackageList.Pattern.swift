//
//  SwiftPackageList.Pattern.swift
//  swift-package-list
//
//  Created by Felix Herrmann on 28.10.26.
//

import ArgumentParser
import Darwin.POSIX.fnmatch

extension SwiftPackageList {
    struct Pattern: RawRepresentable {
        let rawValue: String
    }
}

// MARK: - ExpressibleByArgument

extension SwiftPackageList.Pattern: ExpressibleByArgument {
    init?(argument: String) {
        guard !argument.isEmpty else { return nil }
        self.rawValue = argument
    }
}

// MARK: - Matching

extension SwiftPackageList.Pattern {
    func matches(_ value: String) -> Bool {
        return fnmatch(rawValue, value, 0) == 0
    }
}
