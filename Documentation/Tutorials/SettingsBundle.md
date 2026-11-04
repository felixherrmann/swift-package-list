# Acknowledgments in the Settings App

Generate a new Settings Bundle so users can read dependency licenses in the system Settings app.

## 1. Add the Package and Plugin

In Xcode, choose **File > Add Package Dependencies** and add `https://github.com/felixherrmann/swift-package-list`. You do not need either library product for this tutorial; choose **None** for their target assignments.

Select the app target, open **Build Phases**, and add `SwiftPackageListPlugin` under **Run Build Tool Plug-ins**.

## 2. Configure Settings Bundle Output

Create `.swift-package-list.json` beside your `.xcodeproj` file:

```json5
{
    $schema: "https://raw.githubusercontent.com/felixherrmann/swift-package-list/master/Schemas/plugin.v2.schema.json",
    version: 2,
    targets: {
        "MyApp": {
            outputType: "settings-bundle",
        },
    },
}
```

Replace `MyApp` with your app target's name.

The plugin includes only packages with detected licenses by default.

## 3. Build and Run the App

Build the app and approve plugin execution if Xcode prompts. The plugin generates `Settings.bundle` and includes it in the app's bundle.

The generated `Root.plist` already contains the Acknowledgments child pane.

## 4. Open the Settings App

After installing and launching your app, open the system Settings app on the same simulator or device. Find your app's settings, open **Acknowledgments**, and select a package to read its license.
