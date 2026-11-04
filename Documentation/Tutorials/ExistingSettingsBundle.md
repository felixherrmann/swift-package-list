# Acknowledgments in an Existing Settings Bundle

Add acknowledgments to a Settings Bundle that already contains your app's settings. A Run Script Phase updates the bundle during builds while preserving its `Root.plist` and `Root.strings` files.

This tutorial uses `MyApp.xcodeproj` with an existing bundle at `MyApp/Settings.bundle` that is already included in the app target. Replace these paths with your own.

## 1. Install the CLI

Using Homebrew, run:

```shell
brew install felixherrmann/tap/swift-package-list
```

## 2. Add a Run Script Phase

Select your app target in Xcode, open **Build Phases**, and choose **+ > New Run Script Phase**. Name it **Generate Acknowledgments** and move it above **Copy Bundle Resources**.

Uncheck **Based on dependency analysis** so the script runs on every build.

In the target's **Build Settings**, set **User Script Sandboxing** to **No** so the script can read package checkouts and update the source bundle.

Add the following script:

```shell
export PATH="$PATH:/opt/homebrew/bin:/usr/local/bin"

if command -v swift-package-list &> /dev/null; then
    OUTPUT_PATH="$SOURCE_ROOT/$TARGETNAME"
    swift-package-list "$PROJECT_FILE_PATH" --output-type settings-bundle --output-path "$OUTPUT_PATH" --requires-license
else
    echo "warning: swift-package-list not installed"
fi
```

`OUTPUT_PATH` points to the folder containing your existing `Settings.bundle`, using the app target's name (`MyApp` in this tutorial). The script generates acknowledgments for packages with detected licenses.

## 3. Add the Acknowledgments Pane

Open `MyApp/Settings.bundle/Root.plist` as source code and add this dictionary to its `PreferenceSpecifiers` array:

```xml
<dict>
    <key>Type</key>
    <string>PSChildPaneSpecifier</string>
    <key>Title</key>
    <string>SPL_ACKNOWLEDGMENTS_TITLE</string>
    <key>File</key>
    <string>Acknowledgments</string>
</dict>
```

## 4. Add the Pane Title

Set `StringsTable` to `Root` in `Root.plist` and add the following entry to the bundle's `Root.strings` files:

```text
"SPL_ACKNOWLEDGMENTS_TITLE" = "Acknowledgments";
```

Use the appropriate translation for each language.

## 5. Verify the Result

Build and run the app. Open the system Settings app on the same simulator or device, find your app's settings and open **Acknowledgments**. Your original settings should still be present, and selecting a package should show its license.

The Run Script Phase keeps the acknowledgments up to date when you build after changing dependencies.
