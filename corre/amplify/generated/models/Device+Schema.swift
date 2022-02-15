// swiftlint:disable all
import Amplify
import Foundation

extension Device {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case xCord
    case yCord
    case userDeviceID
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let device = Device.keys
    
    model.authRules = [
      rule(allow: .public, operations: [.create, .update, .delete, .read])
    ]
    
    model.pluralName = "Devices"
    
    model.fields(
      .id(),
      .field(device.xCord, is: .optional, ofType: .double),
      .field(device.yCord, is: .optional, ofType: .double),
      .field(device.userDeviceID, is: .optional, ofType: .string),
      .field(device.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(device.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
}