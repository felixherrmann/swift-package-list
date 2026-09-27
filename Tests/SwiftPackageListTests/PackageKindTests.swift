//
//  PackageKindTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation
import Testing

@testable import SwiftPackageList

struct PackageKindTests {
    @Test func equatableConformance() {
        #expect(Package.Kind.localSourceControl == Package.Kind(rawValue: "localSourceControl"))
        #expect(Package.Kind.remoteSourceControl != Package.Kind.registry)
    }

    @Test func hashableConformance() {
        #expect(Package.Kind.localSourceControl.hashValue == Package.Kind(rawValue: "localSourceControl").hashValue)
        #expect(Package.Kind.remoteSourceControl.hashValue != Package.Kind.registry.hashValue)
    }

    @Test func decodableConformance() throws {
        struct Example: Decodable {
            let kind: Package.Kind
        }

        let decoder = JSONDecoder()
        let data = Data("{\"kind\":\"remoteSourceControl\"}".utf8)
        let example = try decoder.decode(Example.self, from: data)

        #expect(example.kind == .remoteSourceControl)
    }

    @Test func encodableConformance() throws {
        struct Example: Encodable {
            let kind: Package.Kind
        }

        let encoder = JSONEncoder()
        let example = Example(kind: .remoteSourceControl)
        let data = try encoder.encode(example)

        #expect(data == Data("{\"kind\":\"remoteSourceControl\"}".utf8))
    }
}
