//
//  ContentsXcworkspacedata.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 09.10.26.
//

import Foundation

struct ContentsXcworkspacedata: File {
    let url: URL
}

extension ContentsXcworkspacedata {
    var projectURLs: [URL] {
        get throws {
            let document = try XMLDocument(contentsOf: url, options: .nodeLoadExternalEntitiesNever)
            let nodes = try document.nodes(forXPath: "//FileRef")
            return nodes.compactMap { node in
                guard let element = node as? XMLElement else { return nil }
                guard let url = locationURL(for: element), url.pathExtension == "xcodeproj" else { return nil }
                return url
            }
        }
    }
    
    private var workspaceParentDirectoryURL: URL {
        return url.deletingLastPathComponent().deletingLastPathComponent()
    }
    
    private func locationURL(for element: XMLElement) -> URL? {
        if let location = element.attribute(forName: "location")?.stringValue {
            return resolvedURL(for: location, in: element)
        } else if element.name == "Group" {
            return parentGroupDirectoryURL(for: element)
        } else {
            return nil
        }
    }
    
    private func resolvedURL(for location: String, in element: XMLElement) -> URL? {
        let components = location.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: false)
        guard components.count == 2 else { return nil }
        let path = String(components[1])
        
        switch components[0] {
        case "group":
            guard !path.isEmpty else { return parentGroupDirectoryURL(for: element) }
            return parentGroupDirectoryURL(for: element)?.appendingPathComponent(path)
        case "container", "self":
            guard !path.isEmpty else { return workspaceParentDirectoryURL }
            return workspaceParentDirectoryURL.appendingPathComponent(path)
        case "absolute":
            guard path.hasPrefix("/") else { return nil }
            return URL(fileURLWithPath: path)
        default:
            return nil
        }
    }
    
    private func parentGroupDirectoryURL(for element: XMLElement) -> URL? {
        if let parent = element.parent as? XMLElement, parent.name == "Group" {
            return locationURL(for: parent)
        } else {
            return workspaceParentDirectoryURL
        }
    }
}
