// swiftlint:disable all
import Amplify
import Foundation

public enum NotificationType: String, EnumPersistable {
  case friendrequest = "FRIENDREQUEST"
  case emergencycontactrequest = "EMERGENCYCONTACTREQUEST"
  case message = "MESSAGE"
  case runnerstarted = "RUNNERSTARTED"
}