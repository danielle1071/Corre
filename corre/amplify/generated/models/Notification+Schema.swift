// swiftlint:disable all
import Amplify
import Foundation

extension Notification {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case senderId
    case receiverId
    case body
    case type
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let notification = Notification.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Notifications"
    
    model.fields(
      .id(),
      .field(notification.senderId, is: .required, ofType: .string),
      .field(notification.receiverId, is: .required, ofType: .string),
      .field(notification.body, is: .optional, ofType: .string),
      .field(notification.type, is: .optional, ofType: .enum(type: NotificationType.self)),
      .field(notification.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(notification.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}