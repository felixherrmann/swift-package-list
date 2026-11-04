# Acknowledgments in a macOS App

Generate an acknowledgments PDF during builds and open it from your SwiftUI app's menu.

## 1. Add the Package

In Xcode, choose **File > Add Package Dependencies** and add `https://github.com/felixherrmann/swift-package-list`.

Add the `SwiftPackageList` library product to your macOS app target.

## 2. Configure the Build Tool Plugin

Select the app target, open **Build Phases**, and add `SwiftPackageListPlugin` under **Run Build Tool Plug-ins**.

Create `.swift-package-list.json` beside your `.xcodeproj` file:

```json5
{
    $schema: "https://raw.githubusercontent.com/felixherrmann/swift-package-list/master/Schemas/plugin.v2.schema.json",
    version: 2,
    targets: {
        "MyApp": {
            outputType: "pdf",
        },
    },
}
```

Replace `MyApp` with your app target's name.

Build the app and approve plugin execution if prompted. The plugin generates `Acknowledgments.pdf` and makes it available in the app's bundle. It includes only packages with detected licenses by default.

## 3. Add a Menu Item

Update your SwiftUI app entry point to add an Acknowledgments menu item. This example uses your app's `ContentView`:

```swift
import AppKit
import SwiftUI
import SwiftPackageList

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(after: .appInfo) {
                Button("Acknowledgments") {
                    guard let url = Bundle.main.acknowledgmentsURL(format: .pdf) else {
                        return
                    }
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
}
```

The menu item appears after the app's About item.

## 4. Verify the Result

Run the app and choose **Acknowledgments** from the app menu. The generated PDF should open in the default PDF viewer and contain your dependencies' licenses.
