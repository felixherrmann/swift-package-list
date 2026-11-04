# Swift Package List

[![Xcode Build](https://github.com/felixherrmann/swift-package-list/actions/workflows/xcodebuild.yml/badge.svg)](https://github.com/felixherrmann/swift-package-list/actions/workflows/xcodebuild.yml)
[![SwiftLint](https://github.com/felixherrmann/swift-package-list/actions/workflows/swiftlint.yml/badge.svg)](https://github.com/felixherrmann/swift-package-list/actions/workflows/swiftlint.yml)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ffelixherrmann%2Fswift-package-list%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/felixherrmann/swift-package-list)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ffelixherrmann%2Fswift-package-list%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/felixherrmann/swift-package-list)

A command-line tool to list Swift package dependencies and generate acknowledgments.

The output includes all the `Package.resolved` information and the license from the checkouts.
You can also generate a JSON, PLIST, Settings.bundle, PDF, HTML, Markdown or CSV file.

Additionally, there are libraries to read the generated package-list file from the application's bundle or to display it with prebuilt components for SwiftUI and UIKit.


## Requirements

- macOS 11.0
- iOS 15.0
- tvOS 15.0
- watchOS 8.0
- visionOS 1.0


## Documentation

See the [documentation](Documentation/README.md) for installation, usage, build integration, output formats, Swift libraries and migration guides.


## License

Swift Package List is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
