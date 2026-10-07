#  SwiftPackageList 3 Migration Guide

This guide eases the transition of the existing apps that use SwiftPackageList 2.x to
version 3 of the tool.

### Minimum Requirements

```diff
- Swift 5.6
+ Swift 5.7

  macOS 10.15
  Mac Catalyst 13.0
  iOS 13.0
  tvOS 13.0
  watchOS 6.0
```

## `generate` Subcommand

The new `scan` subcommand prints the package list as JSON to the console. To support
both scanning and file generation, the existing file-generation behavior moved into
a separate `generate` subcommand. Add `generate` before the project path:

```shell
// SwiftPackageList 2
swift-package-list Test.xcodeproj --file-type json --output-path .

// SwiftPackageList 3
swift-package-list generate Test.xcodeproj --file-type json --output-path .
```

> [!IMPORTANT]
> There is no default subcommand. Update existing scripts and CI commands to include
> `generate` when generating package-list files.

For an Xcode Run Script Phase, update the command as follows:

```diff
  if command -v swift-package-list &> /dev/null; then
      OUTPUT_PATH=$SOURCE_ROOT/$TARGETNAME
-     swift-package-list "$PROJECT_FILE_PATH" --output-path "$OUTPUT_PATH" --requires-license
+     swift-package-list generate "$PROJECT_FILE_PATH" --output-path "$OUTPUT_PATH" --requires-license
  else
      echo "warning: swift-package-list not installed"
  fi
```

For an Xcode workspace, make the same change to the command that uses
`"$WORKSPACE_FILE_PATH"`.
