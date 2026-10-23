//
//  Bundle+acknowledgments.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 11.02.24.
//

import Foundation

extension Bundle {
    /// The file URL of the 'Acknowledgments.pdf' file.
    public var acknowledgmentsURL: URL? {
        return url(forResource: "Acknowledgments", withExtension: "pdf")
    }

    /// The full pathname of the 'Acknowledgments.pdf' file.
    public var acknowledgmentsPath: String? {
        return path(forResource: "Acknowledgments", ofType: "pdf")
    }
}
