// swiftlint:disable all
import Amplify
import Foundation

extension Message {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case senderId
    case receiverId
    case body
    case creationDate
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let message = Message.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Messages"
    
    model.fields(
      .id(),
      .field(message.senderId, is: .required, ofType: .string),
      .field(message.receiverId, is: .required, ofType: .string),
      .field(message.body, is: .required, ofType: .string),
      .field(message.creationDate, is: .required, ofType: .dateTime),
      .field(message.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(message.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}