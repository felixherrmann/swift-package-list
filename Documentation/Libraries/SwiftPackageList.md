# SwiftPackageList

Load generated package lists and locate acknowledgments documents in your application's bundle.

## Package Provider

`PackageProvider` defines the interface for loading packages and is also used by [SwiftPackageListUI](SwiftPackageListUI.md).

### JSON

`JSONPackageProvider` loads `package-list.json` from the main bundle by default:

```swift
import SwiftPackageList

let jsonProvider = JSONPackageProvider()
let jsonPackages = try jsonProvider.packages()
```

### Property List

`PropertyListPackageProvider` loads `package-list.plist` from the main bundle by default:

```swift
import SwiftPackageList

let plistProvider = PropertyListPackageProvider()
let plistPackages = try plistProvider.packages()
```

## Bundle Extension

Use `acknowledgmentsURL(format:)` or `acknowledgmentsPath(format:)` to locate a generated PDF, HTML or Markdown document:

```swift
import Foundation
import SwiftPackageList

let pdfURL = Bundle.main.acknowledgmentsURL(format: .pdf) // Acknowledgments.pdf
let htmlURL = Bundle.main.acknowledgmentsURL(format: .html) // Acknowledgments.html
let markdownPath = Bundle.main.acknowledgmentsPath(format: .markdown) // Acknowledgments.md
```
