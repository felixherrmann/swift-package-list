//
//  License.swift
//  SwiftPackageListCore
//
//  Created by Felix Herrmann on 02.03.25.
//

import Foundation

struct License: File {
    let url: URL
}

extension License {
    /// Ordered by Licensee's filename preference: https://github.com/licensee/licensee/blob/main/lib/licensee/project_files/license_file.rb
    private static let filenamePatterns: [String] = {
        let license = #"(?:un)?licen[sc]e"#
        let preferredExtension = #"\.(?:md|markdown|txt|html)"#
        let anyExtension = #"\.([^./]|\.\d)+"#
        let otherExtension = #"\.(?!xml|sh|go|gemspec)([^./]|\.\d)+"#
        return [
            #"\A"# + license + #"\z"#,
            #"\A"# + license + preferredExtension + #"\z"#,
            #"\Acopying\z"#,
            #"\Acopying"# + preferredExtension + #"\z"#,
            #"\A"# + license + #"\.(?!spdx|header)([^./]|\.\d)+\z"#,
            #"\Acopying"# + anyExtension + #"\z"#,
            #"\A"# + license + #"[-_][^.]+(?:"# + otherExtension + #")?\z"#,
            #"\Acopying[-_][^.]+(?:"# + otherExtension + #")?\z"#,
            #"\A\w+[-_]"# + license + #"[^.]*(?:"# + otherExtension + #")?\z"#,
            #"\A\w+[-_]copying[^.]*(?:"# + otherExtension + #")?\z"#,
            #"\Aofl"# + preferredExtension + #"\z"#,
            #"\Aofl"# + otherExtension + #"\z"#,
            #"\Aofl\z"#,
            #"\Acopyright\z"#,
            #"\Acopyright"# + preferredExtension + #"\z"#,
            #"\Acopyright"# + otherExtension + #"\z"#,
            #"\Acopyright[-_][^.]+(?:"# + otherExtension + #")?\z"#,
            #"\Apatents\z"#,
            #"\Apatents"# + otherExtension + #"\z"#,
        ]
    }()

    private static func checkFilename(_ filename: String, for pattern: String) -> Bool {
        return filename.range(of: pattern, options: [.regularExpression, .caseInsensitive]) != nil
    }

    init?(uncheckedURL url: URL) {
        guard Self.filenamePatterns.contains(where: { Self.checkFilename(url.lastPathComponent, for: $0) }) else { return nil }
        self.init(url: url)
    }
}

extension License {
    var content: String {
        get throws {
            return try String(contentsOf: url, encoding: .utf8)
        }
    }
}
