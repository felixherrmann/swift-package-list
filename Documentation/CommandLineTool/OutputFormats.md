# Output Formats

Use `--output-type` to select a format through the [command-line options](Usage.md), or set `outputType` in the [build tool plugin configuration](BuildToolPlugin.md).

For the command-line tool, add `--output-path` to write files to a directory; otherwise, text formats are sent to stdout. PDF and Settings Bundle output require an output path. The filenames below are the defaults.

Markdown, HTML and PDF use the project name and, when available, its organization name. You can set the organization name in Xcode's project file inspector as shown [here](https://stackoverflow.com/a/38395030/11342085).

## Table

Use `--output-type table` (the default) to display a compact dependency summary:

```text
PACKAGE                VERSION/REF  LICENSE
swift-argument-parser  1.5.0        Found
```

When written to a file, the default filename is `package-table.txt`.

## CSV

Use `--output-type csv` to generate a `package-list.csv` table.

The columns are `kind`, `identity`, `name`, `version`, `branch`, `revision`, `location` and `hasLicense`.

## JSON

Use `--output-type json` to generate a `package-list.json` file containing package metadata and license text.

Load it in your app with [JSONPackageProvider](../Libraries/SwiftPackageList.md#json).

## PLIST

Use `--output-type plist` to generate a `package-list.plist` file containing package metadata and license text.

Load it in your app with [PropertyListPackageProvider](../Libraries/SwiftPackageList.md#property-list).

## Markdown

Use `--output-type markdown` to generate an `Acknowledgments.md` document that preserves license formatting.

## HTML

Use `--output-type html` to generate a standalone `Acknowledgments.html` page that preserves license formatting.

## PDF

Use `--output-type pdf` to generate an `Acknowledgments.pdf` document containing all licenses.

## Settings Bundle

Use `--output-type settings-bundle` to generate a `Settings.bundle` that shows acknowledgments in the Settings app.

A Settings Bundle contains several files and may already exist in your app. The Settings Bundle is localized in the following languages: [Localization](../Localization.md).

**Important:** The `Root.plist` and `Root.strings` files will (unlike the other files) only be created if they do not already exist,
to preserve existing configurations. Make sure you set up the `Acknowledgments.plist` correctly as a Child Pane as shown below:

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

For more information on how to set up and use a Settings Bundle, take a look at Apple's [documentation](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html).
