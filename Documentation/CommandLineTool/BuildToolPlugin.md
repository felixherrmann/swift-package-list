# Build Tool Plugin

The easiest way to add this tool to your project is using the provided build-tool plugin, available for both Xcode projects and Swift packages.

For Xcode projects simply add it under the `Run Build Tool Plug-ins` section in the Target's Build Phases tab after you have added this package to the project's Package Dependencies; for Swift packages configure it in the `Package.swift` manifest, as described [here](https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/enablebuildplugin).

By default the plugin uses JSON output with `--requires-license`. To configure it, create a `.swift-package-list.json` file in your project's root directory.

Configuration files support JSON and JSON5, including comments, unquoted keys and trailing commas; paths are resolved relative to the project directory. Use `version: 2` for the following format; all other fields are optional:

```json5
// Swift Package List configuration file
// Check out https://github.com/felixherrmann/swift-package-list/blob/master/Documentation/CommandLineTool/BuildToolPlugin.md for all possible configuration options.

{
    $schema: "https://raw.githubusercontent.com/felixherrmann/swift-package-list/master/Schemas/plugin.v2.schema.json",
    version: 2,
    projectPath: "Project.xcworkspace",
    targets: {
        "*": {
            outputType: "plist",
            requiresLicense: false,
        },
        "Target 1": {
            outputType: "settings-bundle",
            packageOrder: "name-ascending",
            requiresLicense: true,
        },
        "Target 2": {
            outputType: "json",
            requiresLicense: true,
            ignorePackages: [
                "swift-package-list",
                "swift-argument-parser",
                "swift-openapi-*",
            ],
            includePackages: [
                "swift-openapi-runtime",
            ],
            customPackagesFilePaths: [
                "custom-packages.json",
            ],
        },
    },
    environments: {
        "ci": {
            customSourcePackagesPath: "SourcePackages",
        },
    },
}
```

The `targets` keys are target names (`displayName` in Xcode). The `"*"` entry supplies options for targets without an explicit entry; omitted options use the plugin defaults.

Once added and configured the file(s) will get generated during every build process and are available in the App's bundle.
You can then open them manually or use the various options in the included [Swift libraries](../Libraries/README.md).

> [!NOTE]
> When using Xcode Cloud add `defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES`
> to `ci_post_clone.sh` which disables the plugin validation.

## Environment

Select an environment by setting `SWIFT_PACKAGE_LIST_PLUGIN_ENVIRONMENT` in the process that starts the build. Its value must exactly match a key in the configuration's `environments` section.

For example, a CI build can use `-clonedSourcePackagesDirPath` to store package sources in a custom directory. Run the following from the project root to select the `ci` entry above and use its matching `SourcePackages` path:

```shell
export SWIFT_PACKAGE_LIST_PLUGIN_ENVIRONMENT=ci
xcodebuild -workspace Project.xcworkspace \
    -scheme "Target 1" \
    -clonedSourcePackagesDirPath SourcePackages \
    build
```
