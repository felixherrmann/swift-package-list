#  SwiftPackageList 2 Migration Guide

This guide eases the transition of the existing apps that use SwiftPackageList 1.x to
version 2 of the tool.

### Minimum Requirements

```diff
- Swift 5.5
+ Swift 5.6

  macOS 10.15
  Mac Catalyst 13.0
  iOS 13.0
  tvOS 13.0
  watchOS 6.0
```

> [!IMPORTANT]
> The package manifest still declares Swift tools version 5.5, but the command-line
> tool's core uses `any OutputGenerator`. The `any` syntax was introduced in
> [Swift 5.6](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0335-existential-any.md).
> Update the Swift toolchain used to build the CLI to Swift 5.6 or later.
