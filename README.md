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

guard let appleTeamID = ProcessInfo.processInfo.environment["APPLE_TEAM_ID"],
  let apploaderUsername = ProcessInfo.processInfo.environment["APPLOADER_USERNAME"],
  let apploaderPassword = ProcessInfo.processInfo.environment["APPLOADER_USERNAME"]
else {
  fatalError("Secrets missing")
}

let appStore = try AppStore(project: "MyProject.xcodeproj", scheme: "MyScheme")
try appStore.build(appleTeamID: appleTeamID)
try appStore.upload(credential: LiteralPasswordCredential(username: apploaderUsername, password: apploaderPassword))
```

This approach empowers you to store your secrets in the environment, or use [Sh1Password](https://github.com/FullQueueDeveloper/Sh1Password.git) to fetch secrets from 1Password.

## Next steps

This package is super tiny. If your needs are more specific, you can easily copy the contents of the script into your own [Swish](https://github.com/FullQueueDeveloper/Swish.git) scripts, and easily customize with the exact variations you requrie.
