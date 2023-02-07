import Foundation
import Sh
import ShXcrun
import Rainbow
import ShGit

public struct AppStore {

  let secrets: Secrets, logRoot: String, artifactRoot: String
  public init(secrets: Secrets, logRoot: String, artifactRoot: String) throws {
    self.secrets = secrets
    self.logRoot = logRoot
    self.artifactRoot = artifactRoot
  }

  public func build(project: String? = nil,
                    workspace: String? = nil,
                    scheme: String
                  ) throws {
    let git = Git()
    guard try git.isClean()
    else {
      throw Errors.gitRepoHasUncommitedFiles
    }

    try FileManager.default.createDirectory(atPath: logRoot,
                                            withIntermediateDirectories: true)
    try FileManager.default.createDirectory(atPath: artifactRoot,
                                            withIntermediateDirectories: true)


    print("=== Build start ===".cyan)
    let archivePath = "\(artifactRoot)/\(scheme).xcarchive"
    let exportOptionsPath = "\(artifactRoot)/exportOptions.plist"
    let exportOptions = ExportOptions(compileBitcode: false,
                                      manageAppVersionAndBuildNumber: true,
                                      method: .appStore,
                                      teamID: secrets.appleTeamID,
                                      uploadBitcode: false,
                                      uploadSymbols: true)
    try exportOptions.write(to: exportOptionsPath)

    let xcodebuild = Xcodebuild(project: project,
                                workspace: workspace,
                                scheme: scheme,
                                sdk: "iphoneos",
                                allowProvisioningUpdates: true,
                                allowProvisioningDeviceRegistration: true)
    try xcodebuild.archive(.file("\(logRoot)/archive.log"), path: archivePath)
    try xcodebuild.exportArchive(.file("\(logRoot)/exportArchive.log"),
                                 archivePath: archivePath,
                                 exportPath: artifactRoot,
                                 exportOptionsPlistPath: exportOptionsPath)

    let altool = Altool(credential: .password(username: secrets.apploaderUsername, password: secrets.apploaderPassword))
    print("=== Uploading to App Store ===".lightBlue)
    try altool.uploadApp(.file("\(logRoot)/upload.log"),
                         file: "\(artifactRoot)/\(scheme).ipa",
                         platform: .iOS)
    print("=== Build complete ===".green)
  }

  public enum Errors: LocalizedError {
    case gitRepoHasUncommitedFiles
    public var errorDescription: String? {
      switch self {
      case .gitRepoHasUncommitedFiles: return "Git repo isn't clean"
      }
    }
  }
}
