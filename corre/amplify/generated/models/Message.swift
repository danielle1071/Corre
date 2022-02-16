// swiftlint:disable all
import Amplify
import Foundation

public struct Message: Model {
  public let id: String
  public var senderId: String
  public var receiverId: String
  public var body: String
  public var creationDate: Temporal.DateTime
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      senderId: String,
      receiverId: String,
      body: String,
      creationDate: Temporal.DateTime) {
    self.init(id: id,
      senderId: senderId,
      receiverId: receiverId,
      body: body,
      creationDate: creationDate,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      senderId: String,
      receiverId: String,
      body: String,
      creationDate: Temporal.DateTime,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.senderId = senderId
      self.receiverId = receiverId
      self.body = body
      self.creationDate = creationDate
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}