// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "SwishAppStore",
  platforms: [.macOS(.v12)],
  products: [
    .library(name: "SwishAppStore", targets: ["SwishAppStore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/FullQueueDeveloper/ShXcrun.git", from: "0.1.9"),
    .package(url: "https://github.com/FullQueueDeveloper/Sh.git", from: "1.2.0"),
    .package(url: "https://github.com/FullQueueDeveloper/ShGit.git", from: "1.1.0"),
  ],
  targets: [
    .target(name: "SwishAppStore", dependencies: ["Sh", "ShXcrun", "ShGit"]),
  ]
)
