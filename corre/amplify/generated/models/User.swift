// swiftlint:disable all
import Amplify
import Foundation

public struct User: Model {
  public let id: String
  public var sub: String
  public var username: String
  public var bio: String?
  public var totalDistance: Double?
  public var runningStatus: RunningStatus?
  public var friends: [String?]?
  public var blockedUsers: [String?]?
  public var EmergencyContacts: List<EmergencyContact>?
  public var Runs: List<Run>?
  public var firstName: String?
  public var lastName: String?
  public var email: String?
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      sub: String,
      username: String,
      bio: String? = nil,
      totalDistance: Double? = nil,
      runningStatus: RunningStatus? = nil,
      friends: [String?]? = nil,
      blockedUsers: [String?]? = nil,
      EmergencyContacts: List<EmergencyContact>? = [],
      Runs: List<Run>? = [],
      firstName: String? = nil,
      lastName: String? = nil,
      email: String? = nil) {
    self.init(id: id,
      sub: sub,
      username: username,
      bio: bio,
      totalDistance: totalDistance,
      runningStatus: runningStatus,
      friends: friends,
      blockedUsers: blockedUsers,
      EmergencyContacts: EmergencyContacts,
      Runs: Runs,
      firstName: firstName,
      lastName: lastName,
      email: email,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      sub: String,
      username: String,
      bio: String? = nil,
      totalDistance: Double? = nil,
      runningStatus: RunningStatus? = nil,
      friends: [String?]? = nil,
      blockedUsers: [String?]? = nil,
      EmergencyContacts: List<EmergencyContact>? = [],
      Runs: List<Run>? = [],
      firstName: String? = nil,
      lastName: String? = nil,
      email: String? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.sub = sub
      self.username = username
      self.bio = bio
      self.totalDistance = totalDistance
      self.runningStatus = runningStatus
      self.friends = friends
      self.blockedUsers = blockedUsers
      self.EmergencyContacts = EmergencyContacts
      self.Runs = Runs
      self.firstName = firstName
      self.lastName = lastName
      self.email = email
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
}
