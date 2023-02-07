# SwishAppStore

Upload your app to the App Store using Swift.

## Usage

Import this into your [Swish](https://github.com/FullQueueDeveloper/Swish.git) scripts so you can `swish appstore` whenever you would like to deploy.

In your Swish's `Package.swift`

```swift
  dependencies: [
  .package(url: "https://github.com/FullQueueDeveloper/SwishAppStore.git", from: "0.1.0"),
  // ...
  ],
  targets: [
    .executableTarget(name: "appstore", dependencies: ["SwishAppStore"]),
    // ...
  ],
```

And the `main.swift` in your `appstore` target might look like this.

```swift
import SwishAppStore

let logRoot = "Swish/logs"
let artifactRoot = "Swish/artifacts"

let secrets = AppStore.Secrets(
  appleTeamID: ProcessInfo.processInfo.environment["APPLE_TEAM_ID"],
  apploaderUsername: ProcessInfo.processInfo.environment["APPLOADER_USERNAME"],
  apploaderPassword: ProcessInfo.processInfo.environment["APPLOADER_USERNAME"])

let appStore = try AppStore(secrets:secrets, logRoot: logRoot, artifactRoot: artifactRoot)
try appStore.build(project: "MyProject.xcodeproj", scheme: "MyScheme")
```
