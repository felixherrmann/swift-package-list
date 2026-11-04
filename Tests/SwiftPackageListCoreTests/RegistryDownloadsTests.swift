//
//  RegistryDownloadsTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct RegistryDownloadsTests {
    @Test func packageSourceMissingVersion() {
        let registryDownloads = RegistryDownloads(url: URL(fileURLWithPath: "/test/registry/downloads"))
        let packageSource = registryDownloads.packageSource(identity: "", version: nil)
        #expect(packageSource == nil)
    }

    @Test func packageSourceInvalidIdentity() {
        let registryDownloads = RegistryDownloads(url: URL(fileURLWithPath: "/test/registry/downloads"))
        let packageSource = registryDownloads.packageSource(identity: "scope", version: "1.0.0")
        #expect(packageSource == nil)
    }

    @Test func packageSourceValidIdentity() throws {
        let registryDownloads = RegistryDownloads(url: URL(fileURLWithPath: "/test/registry/downloads"))
        let packageSource = try #require(registryDownloads.packageSource(identity: "scope.name", version: "1.0.0"))
        #expect(packageSource.url.path() == "/test/registry/downloads/scope/name/1.0.0")
    }
}
