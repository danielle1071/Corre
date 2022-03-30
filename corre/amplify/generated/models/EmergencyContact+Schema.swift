// swiftlint:disable all
import Amplify
import Foundation

extension EmergencyContact {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case firstName
    case lastName
    case email
    case phoneNumber
    case appUser
    case emergencyContactUserId
    case emergencyContactAppUsername
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let emergencyContact = EmergencyContact.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "EmergencyContacts"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser")
    )
    
    model.fields(
      .id(),
      .field(emergencyContact.firstName, is: .optional, ofType: .string),
      .field(emergencyContact.lastName, is: .optional, ofType: .string),
      .field(emergencyContact.email, is: .required, ofType: .string),
      .field(emergencyContact.phoneNumber, is: .required, ofType: .string),
      .field(emergencyContact.appUser, is: .optional, ofType: .bool),
      .field(emergencyContact.emergencyContactUserId, is: .optional, ofType: .string),
      .field(emergencyContact.emergencyContactAppUsername, is: .optional, ofType: .string),
      .field(emergencyContact.userID, is: .required, ofType: .string),
      .field(emergencyContact.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(emergencyContact.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}