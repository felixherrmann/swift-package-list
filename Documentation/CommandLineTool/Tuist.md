# Tuist

This tool supports the following [Tuist external dependency](https://docs.tuist.dev/en/guides/features/projects/dependencies#external-dependencies) setups:

| Setup                                                                                                                          | Command                                                                             |
|--------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|
| [XcodeProj-based](https://docs.tuist.dev/en/guides/features/projects/dependencies#tuists-xcodeprojbased-integration) at root   | `swift-package-list Package.swift --custom-source-packages-path .build`             |
| [XcodeProj-based](https://docs.tuist.dev/en/guides/features/projects/dependencies#tuists-xcodeprojbased-integration) at /Tuist | `swift-package-list Tuist/Package.swift --custom-source-packages-path Tuist/.build` |
| [Xcode's default](https://docs.tuist.dev/en/guides/features/projects/dependencies#xcodes-default-integration)                  | `swift-package-list Project.swift`                                                  |
