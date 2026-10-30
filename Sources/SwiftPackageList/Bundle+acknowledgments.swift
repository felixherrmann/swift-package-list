//
//  Bundle+acknowledgments.swift
//  SwiftPackageList
//
//  Created by Felix Herrmann on 11.02.24.
//

import Foundation

extension Bundle {
    /// The format of a generated acknowledgments document.
    public enum AcknowledgmentsFormat: Sendable {

        /// A PDF document.
        case pdf

        /// An HTML document.
        case html

        /// A Markdown document.
        case markdown
    }

    /// Returns the file URL of the acknowledgments document in the given format.
    /// - Parameter format: The document format.
    /// - Returns: The URL of 'Acknowledgments.pdf', 'Acknowledgments.html', or 'Acknowledgments.md',
    ///   or `nil` if it is not in the bundle.
    public func acknowledgmentsURL(format: AcknowledgmentsFormat) -> URL? {
        switch format {
        case .pdf:
            return url(forResource: "Acknowledgments", withExtension: "pdf")
        case .html:
            return url(forResource: "Acknowledgments", withExtension: "html")
        case .markdown:
            return url(forResource: "Acknowledgments", withExtension: "md")
        }
    }

    /// Returns the full pathname of the acknowledgments document in the given format.
    /// - Parameter format: The document format.
    /// - Returns: The path of 'Acknowledgments.pdf', 'Acknowledgments.html', or 'Acknowledgments.md',
    ///   or `nil` if it is not in the bundle.
    public func acknowledgmentsPath(format: AcknowledgmentsFormat) -> String? {
        switch format {
        case .pdf:
            return path(forResource: "Acknowledgments", ofType: "pdf")
        case .html:
            return path(forResource: "Acknowledgments", ofType: "html")
        case .markdown:
            return path(forResource: "Acknowledgments", ofType: "md")
        }
    }
}

// MARK: - Deprecations

extension Bundle {
    /// The file URL of the 'Acknowledgments.pdf' file.
    @available(*, deprecated, message: "Use acknowledgmentsURL(format:) instead.")
    public var acknowledgmentsURL: URL? {
        return acknowledgmentsURL(format: .pdf)
    }

    /// The full pathname of the 'Acknowledgments.pdf' file.
    @available(*, deprecated, message: "Use acknowledgmentsPath(format:) instead.")
    public var acknowledgmentsPath: String? {
        return acknowledgmentsPath(format: .pdf)
    }
}
