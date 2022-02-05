// swiftlint:disable all
import Amplify
import Foundation

public struct Run: Model {
  public let id: String
  public var distance: String?
  public var time: String?
  public var averageSpeed: String?
  public var userID: String
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      distance: String? = nil,
      time: String? = nil,
      averageSpeed: String? = nil,
      userID: String) {
    self.init(id: id,
      distance: distance,
      time: time,
      averageSpeed: averageSpeed,
      userID: userID,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      distance: String? = nil,
      time: String? = nil,
      averageSpeed: String? = nil,
      userID: String,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.distance = distance
      self.time = time
      self.averageSpeed = averageSpeed
      self.userID = userID
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}