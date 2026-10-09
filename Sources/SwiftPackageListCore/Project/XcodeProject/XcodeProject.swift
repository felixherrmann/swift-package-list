//
//  XcodeProject.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 21.12.23.
//

import Foundation

struct XcodeProject: NativeProject {
    let fileURL: URL
    let options: ProjectOptions
    
    var name: String {
        return fileURL
            .deletingPathExtension()
            .lastPathComponent
    }
    
    var organizationName: String? {
        let projectXcprojURL = fileURL.appendingPathComponent("project.xcproj")
        let projectXcproj = ProjectXcproj(url: projectXcprojURL)
        if let organizationName = projectXcproj.organizationName {
            return organizationName
        }
        
        let projectPbxprojURL = fileURL.appendingPathComponent("project.pbxproj")
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
                .appendingPathComponent("project.xcworkspace")
                .appendingPathComponent("xcshareddata")
                .appendingPathComponent("swiftpm")
                .appendingPathComponent("Package.resolved")
            return try PackageResolved(url: url)
        }
    }
    
    var configuration: Configuration? {
        let url = fileURL
            .appendingPathComponent("project.xcworkspace")
            .appendingPathComponent("xcshareddata")
            .appendingPathComponent("swiftpm")
            .appendingPathComponent("configuration")
        return Configuration(url: url)
    }
}
