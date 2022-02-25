// swiftlint:disable all
import Amplify
import Foundation

public struct Notification: Model {
  public let id: String
  public var senderId: String
  public var receiverId: String
  public var body: String?
  public var type: NotificationType?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      senderId: String,
      receiverId: String,
      body: String? = nil,
      type: NotificationType? = nil) {
    self.init(id: id,
      senderId: senderId,
      receiverId: receiverId,
      body: body,
      type: type,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      senderId: String,
      receiverId: String,
      body: String? = nil,
      type: NotificationType? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.senderId = senderId
      self.receiverId = receiverId
      self.body = body
      self.type = type
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}