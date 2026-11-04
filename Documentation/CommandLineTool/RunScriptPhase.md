# Run Script Phase

You can easily set up a Run Script Phase in your target of your Xcode project to keep the package-list file up to date automatically:

1. open the corresponding target and click on the plus under the *Build Phases* section
2. select *New Run Script Phase* and add the following script into the code box:

   ```shell
   if command -v swift-package-list &> /dev/null; then
       OUTPUT_PATH=$SOURCE_ROOT/$TARGETNAME
       swift-package-list "$PROJECT_FILE_PATH" --output-type json --output-path "$OUTPUT_PATH" --requires-license
   else
       echo "warning: swift-package-list not installed"
   fi
   ```

3. move the Phase above the `Copy Bundle Resources`-phase
4. optionally you can rename the Phase by double-clicking on the title
5. build your project (<kbd>cmd</kbd> + <kbd>b</kbd>)
6. right-click on the targets-folder in the sidebar and select *Add Files to "\<project-name\>"*
7. select `package-list.json` in the Finder-window

The package-list file will be updated now on every build and can be opened from the bundle in your app.
You can do that manually or use the [Swift libraries](../Libraries/README.md) for that.

## Xcode Workspace (CocoaPods)

If you have an Xcode workspace instead of a standard Xcode project everything works exactly the same,
you just need a slightly modified script for the Run Script Phase:

```shell
if command -v swift-package-list &> /dev/null; then
    OUTPUT_PATH=$SOURCE_ROOT/$TARGETNAME
    WORKSPACE_FILE_PATH=${PROJECT_FILE_PATH%.xcodeproj}.xcworkspace
    swift-package-list "$WORKSPACE_FILE_PATH" --output-type json --output-path "$OUTPUT_PATH" --requires-license
else
    echo "warning: swift-package-list not installed"
fi
```

## Homebrew Troubleshooting on Apple Silicon

If you used Homebrew to install the Command-Line Tool on an Apple Silicon Mac, Xcode will not recognize the swift-package-list command.
This is because Homebrew uses it's own /bin directory and Xcode's PATH environment variable is not aware of that.
There are 2 easy ways to fix this issue:

- add `export PATH="$PATH:/opt/homebrew/bin"` as the first line to your build script
- execute `ln -s /opt/homebrew/bin/swift-package-list /usr/local/bin/swift-package-list` in your Terminal

## Mint Troubleshooting

If you used Mint to install the Command-Line Tool, Xcode will not recognize the swift-package-list command.
This is because Mint uses it's own /bin directory and Xcode's PATH environment variable is not aware of that.
There are 2 easy ways to fix this issue:

- add `export PATH="$PATH:$HOME/.mint/bin/"` as the first line to your build script
- execute `ln -s $HOME/.mint/bin/swift-package-list /usr/local/bin/swift-package-list` in your Terminal
