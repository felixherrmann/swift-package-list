# Acknowledgments Inside an iOS App

Generate a package list during builds and display its licenses inside a SwiftUI app.

## 1. Add the Package

In Xcode, choose **File > Add Package Dependencies** and enter:

```text
https://github.com/felixherrmann/swift-package-list
```

Add the `SwiftPackageListUI` library product to your app target.

## 2. Enable the Build Tool Plugin

Select your app target, open **Build Phases**, and add `SwiftPackageListPlugin` under **Run Build Tool Plug-ins**.

Build the app and approve plugin execution if Xcode prompts. By default, the plugin generates `package-list.json` with packages that have detected licenses and makes it available in the app's bundle.

## 3. Add the Acknowledgments Screen

Create `SettingsView.swift` with the following code, then show `SettingsView()` from your app's main `WindowGroup`:

```swift
import SwiftUI
import SwiftPackageListUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Acknowledgments") {
                    AcknowledgmentsList()
                }
            }
            .navigationTitle("Settings")
        }
    }
}
```

`AcknowledgmentsList()` loads the generated JSON file automatically.

## 4. Verify the Result

Run the app, open **Acknowledgments** and select a package. You should see its license text.
