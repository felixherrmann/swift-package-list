//
//  CustomPackagesTests.swift
//  swift-package-list-tests
//
//  Created by Felix Herrmann on 17.02.25.
//

import Foundation
import Testing

@testable import swift_package_list

struct CustomPackagesTests {
    @Test func version1() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages_v1",
            withExtension: ".json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try #require(url)
        let customPackages = try SwiftPackageList.CustomPackages(url: unwrappedURL)
        let package = try #require(customPackages.packages().first)

        #expect(package.branch == "branch-test")
        #expect(package.identity == "identity-test")
        #expect(package.kind == .remoteSourceControl)
        #expect(package.license == "license-test")
        #expect(package.location == "location-tes")
        #expect(package.name == "name-test")
        #expect(package.revision == "revision-test")
        #expect(package.version == "version-test")
    }

    @Test func unsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages_v999",
            withExtension: ".json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try #require(url)

        #expect {
            try SwiftPackageList.CustomPackages(url: unwrappedURL)
        } throws: { error in
            guard case DecodingError.dataCorrupted(let context) = error else { return false }
            guard context.codingPath.last?.stringValue == "version" else { return false }
            guard context.debugDescription == "Unsupported custom-packages version: 999" else { return false }
            return true
        }
    }

    @Test func version2() throws {
        let url = Bundle.module.url(
            forResource: "custom-packages_v2",
            withExtension: "json",
            subdirectory: "Resources/CustomPackages"
        )
        let unwrappedURL = try #require(url)
        let customPackages = try SwiftPackageList.CustomPackages(url: unwrappedURL)
        let packages = try customPackages.packages()

        #expect(packages.count == 5)
        let rawPackage = try #require(packages.first)
        #expect(rawPackage.identity == "raw-license")
        #expect(rawPackage.name == "RawLicense")
        #expect(rawPackage.location == "https://example.com/raw-license")
        #expect(rawPackage.version == "1.2.3")
        #expect(rawPackage.license == "Raw license text")

        let pathPackage = try #require(packages.first { $0.identity == "path-license" })
        #expect(pathPackage.location.isEmpty)
        #expect(pathPackage.license == "License text from a file.\n")
        #expect(pathPackage.version == nil)

        let directoryPackage = try #require(packages.first { $0.identity == "directory-license" })
        #expect(directoryPackage.license == "Preferred detected license.\n")

        for package in packages {
            #expect(package.kind == .custom)
            #expect(package.branch == nil)
            #expect(package.revision == nil)
        }
        for identity in ["no-license", "null-license"] {
            let package = try #require(packages.first { $0.identity == identity })
            #expect(package.location.isEmpty)
            #expect(package.license == nil)
            #expect(package.version == nil)
        }
    }

    @Test(arguments: [false, true])
    func absoluteLicensePath(directory: Bool) throws {
        let url = Bundle.module.url(
            forResource: "LICENSE",
            withExtension: "txt",
            subdirectory: "Resources/CustomPackages/Licenses/File"
        )
        let unwrappedURL = try #require(url)
        let license: SwiftPackageList.CustomPackages.Storage.V2.CustomPackage.License = directory
            ? .directory(path: unwrappedURL.deletingLastPathComponent().path)
            : .file(path: unwrappedURL.path)
        let customPackages = packages(license: license)

        #expect(try customPackages.packages().first?.license == "License text from a file.\n")
    }

    @Test(arguments: [false, true])
    func missingLicensePath(directory: Bool) {
        let path = "missing-\(UUID().uuidString)"
        let customPackages = packages(license: directory ? .directory(path: path) : .file(path: path))

        #expect(throws: CocoaError.self) {
            try customPackages.packages()
        }
    }

    @Test func directoryWithoutLicense() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        for name in ["README.md", ".LICENSE", "license.spdx"] {
            try "Ignored".write(to: directory.appendingPathComponent(name), atomically: true, encoding: .utf8)
        }
        let nestedDirectory = directory.appendingPathComponent("LICENSE.txt")
        try FileManager.default.createDirectory(at: nestedDirectory, withIntermediateDirectories: false)
        try "Nested license".write(
            to: nestedDirectory.appendingPathComponent("LICENSE"),
            atomically: true,
            encoding: .utf8
        )

        let customPackages = packages(license: .directory(path: directory.path))
        let package = try #require(customPackages.packages().first)
        #expect(package.kind == .custom)
        #expect(package.license == nil)
    }

    @Test func unreadableDetectedLicense() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        try Data([0xFF]).write(to: directory.appendingPathComponent("LICENSE"))
        let customPackages = packages(license: .directory(path: directory.path))

        #expect(throws: CocoaError.self) {
            try customPackages.packages()
        }
    }

    @Test(arguments: [
        "{}",
        #"{"raw":"text","file":"license.txt"}"#,
        #"{"raw":"text","directory":"Vendor"}"#,
        #"{"file":"license.txt","directory":"Vendor"}"#,
        #"{"raw":"text","file":"license.txt","directory":"Vendor"}"#,
        #"{"raw":null}"#,
        #"{"file":42}"#,
        #"{"directory":null}"#,
        #"{"directory":42}"#,
        #"{"unknown":"text"}"#,
        #""text""#,
    ])
    func invalidLicense(license: String) {
        typealias License = SwiftPackageList.CustomPackages.Storage.V2.CustomPackage.License

        #expect(throws: DecodingError.self) {
            try JSONDecoder().decode(License.self, from: Data(license.utf8))
        }
    }

    @Test(arguments: ["identity", "name"])
    func missingRequiredField(field: String) throws {
        var package = ["identity": "custom", "name": "Custom"]
        package.removeValue(forKey: field)
        let data = try JSONSerialization.data(withJSONObject: ["version": 2, "packages": [package]])

        #expect {
            try JSONDecoder().decode(SwiftPackageList.CustomPackages.Storage.self, from: data)
        } throws: { error in
            guard case DecodingError.keyNotFound(let key, _) = error else { return false }
            return key.stringValue == field
        }
    }

    private func packages(
        license: SwiftPackageList.CustomPackages.Storage.V2.CustomPackage.License
    ) -> SwiftPackageList.CustomPackages {
        return SwiftPackageList.CustomPackages(
            url: URL(fileURLWithPath: "/custom-packages.json"),
            storage: .v2(.init(packages: [
                .init(
                    identity: "custom",
                    name: "Custom",
                    version: nil,
                    location: nil,
                    license: license
                ),
            ]))
        )
    }
}
