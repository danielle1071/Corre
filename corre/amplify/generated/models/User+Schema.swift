// swiftlint:disable all
import Amplify
import Foundation

extension User {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case sub
    case username
    case bio
    case totalDistance
    case runningStatus
    case friends
    case blockedUsers
    case EmergencyContacts
    case Runs
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let user = User.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Users"
    
    model.fields(
      .id(),
      .field(user.sub, is: .required, ofType: .string),
      .field(user.username, is: .required, ofType: .string),
      .field(user.bio, is: .optional, ofType: .string),
      .field(user.totalDistance, is: .optional, ofType: .double),
      .field(user.runningStatus, is: .optional, ofType: .enum(type: RunningStatus.self)),
      .field(user.friends, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .field(user.blockedUsers, is: .optional, ofType: .embeddedCollection(of: String.self)),
      .hasMany(user.EmergencyContacts, is: .optional, ofType: EmergencyContact.self, associatedWith: EmergencyContact.keys.userID),
      .hasMany(user.Runs, is: .optional, ofType: Run.self, associatedWith: Run.keys.userID),
      .field(user.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(user.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}