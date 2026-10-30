//
//  SettingsBundleGeneratorTests.swift
//  SwiftPackageListCoreTests
//
//  Created by Felix Herrmann on 16.05.22.
//

import Foundation
import Testing
import SwiftPackageList

@testable import SwiftPackageListCore

final class SettingsBundleGeneratorTests {
    private let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("Settings-\(UUID()).bundle")

    init() throws {
        let package = Package(
            kind: .remoteSourceControl,
            identity: "test",
            name: "test",
            version: "1.0.0",
            branch: nil,
            revision: "xxxx",
            location: "https://github.com/test/test",
            license: "MIT"
        )

        let settingsBundleGenerator = SettingsBundleGenerator(outputURL: outputURL, packages: [package])
        try settingsBundleGenerator.generateOutput()
    }

    deinit {
        try? FileManager.default.removeItem(at: outputURL)
    }

    @Test func rootPlistOutput() throws {
        let rootPlist = try String(contentsOf: outputURL.appendingPathComponent("Root.plist"))
        // swiftlint:disable indentation_width
        let expectedRootPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>PreferenceSpecifiers</key>
        	<array>
        		<dict>
        			<key>File</key>
        			<string>Acknowledgments</string>
        			<key>Title</key>
        			<string>SPL_ACKNOWLEDGMENTS_TITLE</string>
        			<key>Type</key>
        			<string>PSChildPaneSpecifier</string>
        		</dict>
        	</array>
        	<key>StringsTable</key>
        	<string>Root</string>
        </dict>
        </plist>

        """
        // swiftlint:enable indentation_width
        #expect(rootPlist == expectedRootPlist)
    }

    @Test func acknowledgmentsPlistOutput() throws {
        let acknowledgmentsPlist = try String(contentsOf: outputURL.appendingPathComponent("Acknowledgments.plist"))
        // swiftlint:disable indentation_width
        let expectedAcknowledgmentsPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>PreferenceSpecifiers</key>
        	<array>
        		<dict>
        			<key>Title</key>
        			<string>SPL_ACKNOWLEDGMENTS_SECTION_TITLE</string>
        			<key>Type</key>
        			<string>PSGroupSpecifier</string>
        		</dict>
        		<dict>
        			<key>File</key>
        			<string>Packages/test</string>
        			<key>Title</key>
        			<string>test</string>
        			<key>Type</key>
        			<string>PSChildPaneSpecifier</string>
        		</dict>
        	</array>
        	<key>StringsTable</key>
        	<string>Acknowledgments</string>
        </dict>
        </plist>

        """
        // swiftlint:enable indentation_width
        #expect(acknowledgmentsPlist == expectedAcknowledgmentsPlist)
    }

    @Test func testPlistOutput() throws {
        let testPlistPath = outputURL.appendingPathComponent("Packages").appendingPathComponent("test.plist")
        let testPlist = try String(contentsOf: testPlistPath)
        // swiftlint:disable indentation_width
        let expectedTestPlist = """
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
        	<key>PreferenceSpecifiers</key>
        	<array>
        		<dict>
        			<key>FooterText</key>
        			<string>MIT</string>
        			<key>Type</key>
        			<string>PSGroupSpecifier</string>
        		</dict>
        	</array>
        </dict>
        </plist>

        """
        // swiftlint:enable indentation_width
        #expect(testPlist == expectedTestPlist)
    }

    @Test func rootStringsOutput() throws {
        let rootStringsPath = outputURL.appendingPathComponent("de.lproj").appendingPathComponent("Root.strings")
        let rootStrings = try String(contentsOf: rootStringsPath)
        let expectedRootStrings = """
        "SPL_ACKNOWLEDGMENTS_TITLE" = "Danksagungen";
        """
        #expect(rootStrings == expectedRootStrings)
    }

    @Test func acknowledgmentsStringsOutput() throws {
        let acknowledgmentsStringsPath = outputURL
            .appendingPathComponent("de.lproj")
            .appendingPathComponent("Acknowledgments.strings")
        let acknowledgmentsStrings = try String(contentsOf: acknowledgmentsStringsPath)
        let expectedAcknowledgmentsStrings = """
        "SPL_ACKNOWLEDGMENTS_SECTION_TITLE" = "Lizenzen";
        """
        #expect(acknowledgmentsStrings == expectedAcknowledgmentsStrings)
    }
}
