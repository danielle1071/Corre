// swiftlint:disable all
import Amplify
import Foundation

public struct Device: Model {
  public let id: String
  public var xCord: Double?
  public var yCord: Double?
  public var userDeviceID: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      xCord: Double? = nil,
      yCord: Double? = nil,
      userDeviceID: String? = nil) {
    self.init(id: id,
      xCord: xCord,
      yCord: yCord,
      userDeviceID: userDeviceID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      xCord: Double? = nil,
      yCord: Double? = nil,
      userDeviceID: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.xCord = xCord
      self.yCord = yCord
      self.userDeviceID = userDeviceID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}