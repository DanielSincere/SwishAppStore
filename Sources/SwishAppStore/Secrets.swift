import Foundation

extension AppStore {
  public struct Secrets {
    let apploaderUsername: String
    let apploaderPassword: String
    let appleTeamID: String
    
    public init(appleTeamID: String, apploaderUsername: String, apploaderPassword: String) {
      self.apploaderUsername = apploaderUsername
      self.apploaderPassword = apploaderPassword
      self.appleTeamID = appleTeamID
    }
  }
}
