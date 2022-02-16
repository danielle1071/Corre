// swiftlint:disable all
import Amplify
import Foundation

public struct EmergencyContact: Model {
  public let id: String
  public var firstName: String?
  public var lastName: String?
  public var email: String
  public var phoneNumber: String
  public var appUser: Bool?
  public var emergencyContactUserId: String?
  public var userID: String
  public var emergencyContactAppUsername: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      firstName: String? = nil,
      lastName: String? = nil,
      email: String,
      phoneNumber: String,
      appUser: Bool? = nil,
      emergencyContactUserId: String? = nil,
      userID: String,
      emergencyContactAppUsername: String? = nil) {
    self.init(id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phoneNumber: phoneNumber,
      appUser: appUser,
      emergencyContactUserId: emergencyContactUserId,
      userID: userID,
      emergencyContactAppUsername: emergencyContactAppUsername,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      firstName: String? = nil,
      lastName: String? = nil,
      email: String,
      phoneNumber: String,
      appUser: Bool? = nil,
      emergencyContactUserId: String? = nil,
      userID: String,
      emergencyContactAppUsername: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.firstName = firstName
      self.lastName = lastName
      self.email = email
      self.phoneNumber = phoneNumber
      self.appUser = appUser
      self.emergencyContactUserId = emergencyContactUserId
      self.userID = userID
      self.emergencyContactAppUsername = emergencyContactAppUsername
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}