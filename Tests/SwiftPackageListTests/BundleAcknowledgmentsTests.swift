//
//  BundleAcknowledgmentsTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 11.02.24.
//

import Foundation
import Testing

@testable import SwiftPackageList

struct BundleAcknowledgmentsTests {
    @Test func url() {
        let expectedURL = Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Acknowledgments")
            .appendingPathExtension("pdf")

        #expect(Bundle.module.acknowledgmentsURL == expectedURL)
    }

    @Test func path() {
        let expectedPath = Bundle.module.bundlePath
            .appending("/Contents")
            .appending("/Resources")
            .appending("/Acknowledgments.pdf")

        #expect(Bundle.module.acknowledgmentsPath == expectedPath)
    }
}
