//
//  PackageResolvedTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 15.05.22.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct PackageResolvedTests {
    @Test func version1() throws {
        let url = Bundle.module.url(
            forResource: "Package_v1",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try #require(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)

        guard case .v1(let storage) = packageResolved.storage else {
            Issue.record("\(unwrappedURL.path) was not recognized as v1")
            return
        }

        #expect(storage.version == 1)
        #expect(storage.object.pins.count == 2)
        #expect(storage.object.pins[0].repositoryURL == "/Users/example/swift-package-list")
        #expect(storage.object.pins[1].repositoryURL == "https://github.com/felixherrmann/swift-package-list")
    }

    @Test func version2() throws {
        let url = Bundle.module.url(
            forResource: "Package_v2",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try #require(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)

        guard case .v2(let storage) = packageResolved.storage else {
            Issue.record("\(unwrappedURL.path) was not recognized as v2")
            return
        }

        #expect(storage.version == 2)
        #expect(storage.pins.count == 3)
        #expect(storage.pins[0].kind == .localSourceControl)
        #expect(storage.pins[1].kind == .remoteSourceControl)
        #expect(storage.pins[2].kind == .registry)
    }

    @Test func version3() throws {
        let url = Bundle.module.url(
            forResource: "Package_v3",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try #require(url)
        let packageResolved = try PackageResolved(url: unwrappedURL)

        guard case .v3(let storage) = packageResolved.storage else {
            Issue.record("\(unwrappedURL.path) was not recognized as v3")
            return
        }

        #expect(storage.version == 3)
        #expect(storage.originHash == "0000000000000000000000000000000000000000000000000000000000000000")
        #expect(storage.pins.count == 3)
        #expect(storage.pins[0].kind == .localSourceControl)
        #expect(storage.pins[1].kind == .remoteSourceControl)
        #expect(storage.pins[2].kind == .registry)
    }

    @Test func unsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "Package_v999",
            withExtension: "resolved",
            subdirectory: "Resources/PackageResolved"
        )
        let unwrappedURL = try #require(url)

        let error = #expect(throws: RuntimeError.self) {
            try PackageResolved(url: unwrappedURL)
        }
        #expect(error?.description == "Version 999 of Package.resolved is not supported")
    }

    @Test func version1Kind() {
        let remotePin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "https://github.com/test/TestRemote.git",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        #expect(remotePin.kind == .remoteSourceControl)

        let localPin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "/Users/test/Desktop/TestLocal/",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        #expect(localPin.kind == .localSourceControl)
    }

    @Test func version1Identity() {
        let remotePin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "https://github.com/test/TestRemote.git",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        #expect(remotePin.identity == "testremote")

        let localPin = PackageResolved.Storage.V1.Object.Pin(
            package: "",
            repositoryURL: "/Users/test/Desktop/TestLocal/",
            state: PackageResolved.Storage.V1.Object.Pin.State(branch: nil, revision: "", version: nil)
        )
        #expect(localPin.identity == "testlocal")
    }
}
