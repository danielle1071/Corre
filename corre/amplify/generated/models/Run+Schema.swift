// swiftlint:disable all
import Amplify
import Foundation

extension Run {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case distance
    case time
    case averageSpeed
    case userID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let run = Run.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Runs"
    
    model.attributes(
      .index(fields: ["userID"], name: "byUser")
    )
    
    model.fields(
      .id(),
      .field(run.distance, is: .optional, ofType: .string),
      .field(run.time, is: .optional, ofType: .string),
      .field(run.averageSpeed, is: .optional, ofType: .string),
      .field(run.userID, is: .required, ofType: .string),
      .field(run.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(run.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}