//
//  OutputOptionsTests.swift
//  swift-package-list-tests
//
//  Created by Felix Herrmann on 01.11.26.
//

import SwiftPackageList
import Testing

@testable import swift_package_list

struct OutputOptionsTests {
    @Test(arguments: ["--include-package", "--ignore-package"])
    func emptyPackagePatternIsRejected(option: String) {
        #expect(throws: (any Error).self) {
            try SwiftPackageList.OutputOptions.parse([option, ""])
        }
    }

    struct Filter {
        @Test func includesPackagesByDefault() throws {
            let options = try SwiftPackageList.OutputOptions.parse([])
            #expect(options.filter(package: Package()))
        }

        @Test func excludesIgnoredPackages() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--ignore-package", "swift-*",
            ])
            #expect(!options.filter(package: Package()))
        }

        @Test func includeOverridesIgnore() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--ignore-package", "swift-*",
                "--include-package", "swift-argument-parser",
            ])
            #expect(options.filter(package: Package()))
        }

        @Test(arguments: ["swift-*", "swift-argument-parse?"])
        func includePatternsOverrideIgnore(pattern: String) throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--ignore-package", "*",
                "--include-package", pattern,
            ])
            #expect(options.filter(package: Package()))
        }

        @Test func unmatchedPackagesRemainIgnored() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--ignore-package", "*",
                "--include-package", "swift-argument-parser",
            ])
            #expect(!options.filter(package: Package(identity: "other-package")))
        }

        @Test func includeDoesNotExcludeUnmatchedPackages() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--include-package", "swift-argument-parser",
            ])
            #expect(options.filter(package: Package(identity: "other-package")))
        }

        @Test func acceptsRepeatedIncludeOptions() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--ignore-package", "*",
                "--include-package", "other-package",
                "--include-package", "swift-*",
            ])
            #expect(options.filter(package: Package(identity: "other-package")))
            #expect(options.filter(package: Package()))
        }

        @Test func acceptsRepeatedIgnoreOptions() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--ignore-package", "other-package",
                "--ignore-package", "swift-*",
                "--include-package", "unmatched",
            ])
            #expect(!options.filter(package: Package(identity: "other-package")))
            #expect(!options.filter(package: Package()))
        }

        @Test(arguments: [nil, ""] as [String?])
        func includedPackagesWithoutLicenseAreExcluded(license: String?) throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--requires-license",
                "--ignore-package", "*",
                "--include-package", "swift-*",
            ])
            #expect(!options.filter(package: Package(license: license)))
        }

        @Test func includedPackagesWithLicenseAreIncluded() throws {
            let options = try SwiftPackageList.OutputOptions.parse([
                "--requires-license",
                "--ignore-package", "*",
                "--include-package", "swift-*",
            ])
            #expect(options.filter(package: Package(license: "License text")))
        }
    }

    struct Sort {
        private let packages = [
            Package(identity: "bravo", name: "charlie"),
            Package(identity: "Charlie", name: "alpha"),
            Package(identity: "alpha", name: "Bravo"),
        ]

        @Test func preservesSourceOrderByDefault() throws {
            let options = try SwiftPackageList.OutputOptions.parse([])
            #expect(packages.sorted(by: options.sort(lhs:rhs:)) == packages)
        }

        @Test func preservesSourceOrder() throws {
            let options = try SwiftPackageList.OutputOptions.parse(["--package-order", "source"])
            #expect(packages.sorted(by: options.sort(lhs:rhs:)) == packages)
        }

        @Test func sortsByNameAscending() throws {
            let options = try SwiftPackageList.OutputOptions.parse(["--package-order", "name-ascending"])
            let sorted = packages.sorted(by: options.sort(lhs:rhs:))
            #expect(sorted.map(\.name) == ["alpha", "Bravo", "charlie"])
        }

        @Test func sortsByNameDescending() throws {
            let options = try SwiftPackageList.OutputOptions.parse(["--package-order", "name-descending"])
            let sorted = packages.sorted(by: options.sort(lhs:rhs:))
            #expect(sorted.map(\.name) == ["charlie", "Bravo", "alpha"])
        }

        @Test func sortsByIdentityAscending() throws {
            let options = try SwiftPackageList.OutputOptions.parse(["--package-order", "identity-ascending"])
            let sorted = packages.sorted(by: options.sort(lhs:rhs:))
            #expect(sorted.map(\.identity) == ["alpha", "bravo", "Charlie"])
        }

        @Test func sortsByIdentityDescending() throws {
            let options = try SwiftPackageList.OutputOptions.parse(["--package-order", "identity-descending"])
            let sorted = packages.sorted(by: options.sort(lhs:rhs:))
            #expect(sorted.map(\.identity) == ["Charlie", "bravo", "alpha"])
        }

        @Test(arguments: ["name-ascending", "name-descending", "identity-ascending", "identity-descending"])
        func preservesSourceOrderForEqualKeys(order: String) throws {
            let options = try SwiftPackageList.OutputOptions.parse(["--package-order", order])
            let packages = [
                Package(identity: "example", name: "EXAMPLE"),
                Package(identity: "EXAMPLE", name: "example"),
            ]
            #expect(packages.sorted(by: options.sort(lhs:rhs:)) == packages)
        }
    }
}

extension Package {
    fileprivate init(identity: String = "swift-argument-parser", name: String? = nil, license: String? = nil) {
        self.init(
            kind: .remoteSourceControl,
            identity: identity,
            name: name ?? identity,
            version: nil,
            branch: nil,
            revision: nil,
            location: "https://example.com/\(identity)",
            license: license
        )
    }
}
