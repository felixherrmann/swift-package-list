//
//  BundleAcknowledgementsTests.swift
//  SwiftPackageListTests
//
//  Created by Felix Herrmann on 11.02.24.
//

import Foundation
import Testing

@testable import SwiftPackageList

struct BundleAcknowledgementsTests {
    @Test func url() {
        let expectedURL = Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent("Acknowledgements")
            .appendingPathExtension("pdf")

        #expect(Bundle.module.acknowledgementsURL == expectedURL)
    }

    @Test func path() {
        let expectedPath = Bundle.module.bundlePath
            .appending("/Contents")
            .appending("/Resources")
            .appending("/Acknowledgements.pdf")

        #expect(Bundle.module.acknowledgementsPath == expectedPath)
    }
}
