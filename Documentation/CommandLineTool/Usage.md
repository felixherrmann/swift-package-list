# Usage

Open the terminal and run `swift-package-list <project-path>` with the path to the project file you want to generate the list from.
Currently supported are:

- `*.xcodeproj` for Xcode projects
- `*.xcworkspace` for Xcode workspaces
- `Package.swift` for Swift packages
- `Project.swift` for Tuist projects

In addition to that you can specify the following options:

| Option                                                        | Description                                                                                                                                                  |
| ------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| --custom-derived-data-path \<custom-derived-data-path\>       | A custom path to your DerivedData-folder.                                                                                                                    |
| --custom-source-packages-path \<custom-source-packages-path\> | A custom path to the SourcePackages-folder.                                                                                                                  |
| --custom-packages-file-path \<custom-packages-file-path\>     | A path to a JSON file containing custom packages. (This option may be repeated multiple times)                                                               |
| --output-type \<output-type\>                                 | The type of output for the package-list. (values: table, csv, json, plist, markdown, html, pdf, settings-bundle; default: table)                             |
| --output-path \<output-path\>                                 | The path where the file will be written. If omitted, the content is sent to stdout.                                                                          |
| --custom-file-name \<custom-file-name\>                       | A custom filename to be used instead of the default ones.                                                                                                    |
| --package-order \<package-order\>                             | The order in which the packages will be listed. (values: source, name-ascending, name-descending, identity-ascending, identity-descending; default: source)  |
| --requires-license                                            | Will skip the packages without a license-file.                                                                                                               |
| --ignore-package \<package-identity-pattern\>                 | Will skip a package with the specified identity; glob patterns are supported. (This option may be repeated multiple times)                                   |
| --include-package \<package-identity-pattern\>                | Will include a package with the specified identity; glob patterns are supported. It has precedence over ignore. (This option may be repeated multiple times) |
| --version                                                     | Show the version.                                                                                                                                            |
| -h, --help                                                    | Show help information.                                                                                                                                       |

## Filtering

The provided package filters work in the following order: `--requires-license` -> `--include-package` -> `--ignore-package`.
Package identity values support glob patterns.

For example, to achieve an include-only setup ignore everything first: `--ignore-package '*' --include-package 'swift-argument-parser'`

## Known Limitations

- Registry packages must include license files in their downloaded archives for license detection. License detection with Artifactory has not been verified; see the [discussion in #128](https://github.com/felixherrmann/swift-package-list/pull/128#issuecomment-2692854709).
