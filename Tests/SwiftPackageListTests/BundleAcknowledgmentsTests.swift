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
    @Test(arguments: [
        (Bundle.AcknowledgmentsFormat.pdf, "Acknowledgments.pdf"),
        (.html, "Acknowledgments.html"),
    ])
    func url(format: Bundle.AcknowledgmentsFormat, filename: String) {
        let expectedURL = Bundle.module.bundleURL
            .appendingPathComponent("Contents")
            .appendingPathComponent("Resources")
            .appendingPathComponent(filename)

        #expect(Bundle.module.acknowledgmentsURL(format: format) == expectedURL)
    }

    @Test(arguments: [
        (Bundle.AcknowledgmentsFormat.pdf, "Acknowledgments.pdf"),
        (.html, "Acknowledgments.html"),
    ])
    func path(format: Bundle.AcknowledgmentsFormat, filename: String) {
        let expectedPath = Bundle.module.bundlePath
            .appending("/Contents")
            .appending("/Resources")
            .appending("/\(filename)")

        #expect(Bundle.module.acknowledgmentsPath(format: format) == expectedPath)
    }

    @available(*, deprecated)
    @Test func legacyProperties() {
        #expect(Bundle.module.acknowledgmentsURL == Bundle.module.acknowledgmentsURL(format: .pdf))
        #expect(Bundle.module.acknowledgmentsPath == Bundle.module.acknowledgmentsPath(format: .pdf))
    }
}
