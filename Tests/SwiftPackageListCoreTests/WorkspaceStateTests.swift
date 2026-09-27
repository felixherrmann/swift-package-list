//
//  WorkspaceStateTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 10.12.23.
//

import Foundation
import Testing

@testable import SwiftPackageListCore

struct WorkspaceStateTests {
    @Test func version6() throws {
        let url = Bundle.module.url(
            forResource: "workspace-state_v6",
            withExtension: "json",
            subdirectory: "Resources/WorkspaceState"
        )
        let unwrappedURL = try #require(url)
        let workspaceState = try WorkspaceState(url: unwrappedURL)

        guard case .v6(let workspaceState_V6) = workspaceState.storage else {
            Issue.record("\(unwrappedURL.path) was not recognized as v6")
            return
        }
        #expect(workspaceState_V6.version == 6)
        #expect(workspaceState_V6.object.artifacts[0].packageRef.identity == "intercom-ios-sp")
        #expect(workspaceState_V6.object.artifacts[0].packageRef.name == "Intercom")
        #expect(workspaceState_V6.object.dependencies[0].packageRef.identity == "collectionconcurrencykit")
        #expect(workspaceState_V6.object.dependencies[0].packageRef.name == "CollectionConcurrencyKit")
    }

    @Test func version7() throws {
        let url = Bundle.module.url(
            forResource: "workspace-state_v7",
            withExtension: "json",
            subdirectory: "Resources/WorkspaceState"
        )
        let unwrappedURL = try #require(url)
        let workspaceState = try WorkspaceState(url: unwrappedURL)

        guard case .v7(let workspaceState_V7) = workspaceState.storage else {
            Issue.record("\(unwrappedURL.path) was not recognized as v7")
            return
        }
        #expect(workspaceState_V7.version == 7)
        #expect(workspaceState_V7.object.artifacts.isEmpty)
        #expect(workspaceState_V7.object.dependencies[0].packageRef.identity == "swift-syntax")
        #expect(workspaceState_V7.object.dependencies[0].packageRef.name == "swift-syntax")
    }

    @Test func unsupportedVersion() throws {
        let url = Bundle.module.url(
            forResource: "workspace-state_v999",
            withExtension: "json",
            subdirectory: "Resources/WorkspaceState"
        )
        let unwrappedURL = try #require(url)

        let error = #expect(throws: RuntimeError.self) {
            try WorkspaceState(url: unwrappedURL)
        }
        #expect(error?.description == "Version 999 of workspace-state.json is not supported")
    }
}
