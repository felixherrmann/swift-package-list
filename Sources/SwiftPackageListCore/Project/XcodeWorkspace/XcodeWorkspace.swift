//
//  XcodeWorkspace.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

struct XcodeWorkspace: NativeProject {
    let fileURL: URL
    let options: ProjectOptions
    
    var name: String {
        return fileURL
            .deletingPathExtension()
            .lastPathComponent
    }
    
    var organizationName: String? {
        let contentsURL = fileURL.appendingPathComponent("contents.xcworkspacedata")
        let contentsXcworkspacedata = ContentsXcworkspacedata(url: contentsURL)
        guard let projectURLs = try? contentsXcworkspacedata.projectURLs else { return nil }
        guard let projectURL = projectURLs.first(where: { $0.lastPathComponent != "Pods.xcodeproj" }) else { return nil }
        
        let projectXcprojURL = projectURL.appendingPathComponent("project.xcproj")
        let projectXcproj = ProjectXcproj(url: projectXcprojURL)
        if let organizationName = projectXcproj.organizationName {
            return organizationName
        }
        
        let projectPbxprojURL = projectURL.appendingPathComponent("project.pbxproj")
        let projectPbxproj = ProjectPbxproj(url: projectPbxprojURL)
        if let organizationName = projectPbxproj.organizationName {
            return organizationName
        }
        
        return nil
    }
    
    var workspaceURL: URL {
        return fileURL
    }
    
    var packageResolved: PackageResolved {
        get throws {
            let url = fileURL
                .appendingPathComponent("xcshareddata")
                .appendingPathComponent("swiftpm")
                .appendingPathComponent("Package.resolved")
            return try PackageResolved(url: url)
        }
    }
    
    var configuration: Configuration? {
        let url = fileURL
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("configuration")
        return Configuration(url: url)
    }
}
