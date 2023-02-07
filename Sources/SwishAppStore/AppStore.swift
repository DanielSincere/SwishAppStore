import Foundation
import Sh
import ShXcrun
import Rainbow
import ShGit

public struct AppStore {
  let logRoot: String, artifactRoot: String
  let project: String?
  let workspace: String?
  let scheme: String
  
  public init(logRoot: String = "Swish/logs",
              artifactRoot: String = "Swish/artifacts",
              project: String? = nil,
              workspace: String? = nil,
              scheme: String) throws {
    self.logRoot = logRoot
    self.artifactRoot = artifactRoot
    self.workspace = workspace
    self.scheme = scheme
    self.project = project
    
    try FileManager.default.createDirectory(atPath: logRoot,
                                            withIntermediateDirectories: true)
    try FileManager.default.createDirectory(atPath: artifactRoot,
                                            withIntermediateDirectories: true)
  }
  
  public func build(appleTeamID: String) throws {
    let git = Git()
    guard try git.isClean()
    else {
      throw Errors.gitRepoHasUncommitedFiles
    }
    
    print("=== Build start ===".cyan)
    let archivePath = "\(artifactRoot)/\(scheme).xcarchive"
    let exportOptionsPath = "\(artifactRoot)/exportOptions.plist"
    let exportOptions = ExportOptions(compileBitcode: false,
                                      manageAppVersionAndBuildNumber: true,
                                      method: .appStore,
                                      teamID: appleTeamID,
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
    print("=== Build complete ===".green)
  }
  
  public func upload(credential: AltoolCredential, platform: Altool.Platform = .iOS) throws {
    print("=== Uploading to App Store ===".cyan)
    let altool = Altool(credential: credential)
    try altool.uploadApp(.file("\(logRoot)/upload.log"),
                         file: "\(artifactRoot)/\(scheme).ipa",
                         platform: platform)
    print("=== Upload complete ===".green)
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
