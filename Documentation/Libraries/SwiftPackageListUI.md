# SwiftPackageListUI

Use `SwiftPackageListUI` to display acknowledgments with UIKit or SwiftUI.

This library is localized in the following languages: [Localization](../Localization.md)

## UIKit

```swift
import SwiftPackageListUI

let acknowledgmentsViewController = SPLAcknowledgmentsTableViewController()
acknowledgmentsViewController.canOpenRepositoryLink = true
navigationController.pushViewController(acknowledgmentsViewController, animated: true)
```

## SwiftUI

```swift
import SwiftPackageListUI

var body: some View {
    NavigationStack {
        AcknowledgmentsList()
    }
}
```
