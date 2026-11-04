# Acknowledgments from the Terminal

Inspect a project's dependencies and save their metadata and licenses as a JSON file.

## 1. Install the CLI

Using Homebrew, run:

```shell
brew install felixherrmann/tap/swift-package-list
swift-package-list --version
```

The second command confirms the installation and prints the installed version.

## 2. Prepare the Project

Open your project in Xcode and build it once so package dependencies are resolved and their sources are checked out.

In the terminal, change to the directory containing your `.xcodeproj` file. The examples use `MyApp.xcodeproj`; replace it with your project filename.

## 3. Inspect the Dependencies

Run:

```shell
swift-package-list MyApp.xcodeproj
```

The default table output lists dependencies, their versions or references, and whether a license was found.

## 4. Save a JSON File

Create an output directory and generate the package list:

```shell
mkdir -p Acknowledgments
swift-package-list MyApp.xcodeproj \
    --output-type json \
    --output-path Acknowledgments \
    --requires-license
```

`--output-path` is the destination directory. `--requires-license` excludes packages whose licenses were not found.

Open `Acknowledgments/package-list.json` in your editor. It should contain your dependencies' metadata and license text.

Rerun the command after updating dependencies.
