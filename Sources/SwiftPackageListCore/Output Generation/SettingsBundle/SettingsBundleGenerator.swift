//
//  SettingsBundleGenerator.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 07.04.22.
//

import Foundation
import SwiftPackageList

struct SettingsBundleGenerator: OutputGenerator {
    let outputURL: URL
    let packages: [Package]

    private let fileManager: FileManager = .default
    private let encoder: PropertyListEncoder = {
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        return encoder
    }()

    private var packagesURL: URL {
        return outputURL.appendingPathComponent("Packages")
    }

    func generateOutput() throws {
        try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true)
        try createRootPlist()
        try createAcknowledgmentsPlist()
        try createPackagesDirectory()

        for package in packages {
            try createPackagePlist(for: package)
        }

        for language in Language.allCases {
            try createStringsFile(for: language)
        }

        print("Generated \(outputURL.path)")
    }

    private func createRootPlist() throws {
        let rootURL = outputURL.appendingPathComponent("Root.plist")
        guard !fileManager.fileExists(atPath: rootURL.path) else { return }
        let rootSpecifiers: [Specifier] = [.childPane(title: "Acknowledgments", file: "Acknowledgments")]
        let rootPlist = PropertyList(stringsTable: "Root", preferenceSpecifiers: rootSpecifiers)
        let encodedRoot = try encoder.encode(rootPlist)
        try encodedRoot.write(to: rootURL)
    }

    private func createAcknowledgmentsPlist() throws {
        let packageChildPanes: [Specifier] = packages.map { .childPane(title: $0.name, file: "Packages/\($0.name)") }
        let preferenceSpecifiers: [Specifier] = [.group(title: "Licenses")] + packageChildPanes
        let acknowledgmentsPlist = PropertyList(stringsTable: "Acknowledgments", preferenceSpecifiers: preferenceSpecifiers)
        let encodedAcknowledgments = try encoder.encode(acknowledgmentsPlist)
        let acknowledgmentsURL = outputURL.appendingPathComponent("Acknowledgments.plist")
        try encodedAcknowledgments.write(to: acknowledgmentsURL)
    }

    private func createPackagesDirectory() throws {
        try? fileManager.removeItem(at: packagesURL)
        try fileManager.createDirectory(at: packagesURL, withIntermediateDirectories: true)
    }

    private func createPackagePlist(for package: Package) throws {
        let preferenceSpecifiers: [Specifier] = [.group(footerText: package.license)]
        let packagePlist = PropertyList(preferenceSpecifiers: preferenceSpecifiers)
        let encodedPackage = try encoder.encode(packagePlist)
        let packageURL = packagesURL.appendingPathComponent("\(package.name).plist")
        try encodedPackage.write(to: packageURL)
    }

    private func createStringsFile(for language: Language) throws {
        let languageURL = outputURL.appendingPathComponent("\(language.rawValue).lproj")
        try fileManager.createDirectory(at: languageURL, withIntermediateDirectories: true)

        let rootStringsURL = languageURL.appendingPathComponent("Root.strings")
        if !fileManager.fileExists(atPath: rootStringsURL.path) {
            try language.rootFileData.write(to: rootStringsURL)
        }

        let acknowledgmentsStringsURL = languageURL.appendingPathComponent("Acknowledgments.strings")
        try language.acknowledgmentsFileData.write(to: acknowledgmentsStringsURL)
    }
}
