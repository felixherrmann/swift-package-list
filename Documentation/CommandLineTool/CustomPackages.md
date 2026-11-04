# Custom Packages

To provide custom packages or other items with licenses, you can use the `--custom-packages-file-path` option with a JSON file in the following format:

```json5
{
    $schema: "https://raw.githubusercontent.com/felixherrmann/swift-package-list/master/Schemas/custom-packages.v2.schema.json",
    version: 2,
    packages: [
        {
            identity: "custom-package-example",
            name: "CustomPackageExample",
            version: null,
            license: { raw: "The license text" },
        },
        {
            identity: "another-custom-package",
            name: "AnotherCustomPackage",
            location: "https://example.com/another-custom-package",
            license: { file: "Licenses/another-custom-package.txt" },
        },
        {
            identity: "vendored-library",
            name: "VendoredLibrary",
            license: { directory: "Vendor/SomeLibrary" },
        },
    ],
}
```

The `identity` and `name` fields are required, all other ones can be omitted or set to null. A license must contain exactly one of `raw` (inline license text), `file` (a UTF-8 license file) or `directory` (a directory to detect a license in). Relative file and directory paths are resolved from the custom packages file's directory; absolute paths are also supported.

Custom packages are subject to the same filtering and ordering as discovered packages, so entries without a license are skipped when `--requires-license` is enabled.
