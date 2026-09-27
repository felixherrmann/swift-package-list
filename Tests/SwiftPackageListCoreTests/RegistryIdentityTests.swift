//
//  RegistryIdentityTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct RegistryIdentityTests {
    @Test func identityInitNoComponents() {
        let identity = RegistryIdentity(identity: "")
        #expect(identity == nil)
    }

    @Test func identityInitSingleComponent() {
        let identity = RegistryIdentity(identity: "scope")
        #expect(identity == nil)
    }

    @Test func identityInitTwoComponents() throws {
        let identity = try #require(RegistryIdentity(identity: "scope.name"))
        #expect(identity.scope == "scope")
        #expect(identity.name == "name")
    }

    @Test func identityInitMultipleComponents() throws {
        let identity = try #require(RegistryIdentity(identity: "scope.name.with.separators"))
        #expect(identity.scope == "scope")
        #expect(identity.name == "name.with.separators")
    }
}
