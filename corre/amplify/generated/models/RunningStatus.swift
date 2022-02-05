// swiftlint:disable all
import Amplify
import Foundation

public enum RunningStatus: String, EnumPersistable {
  case running = "RUNNING"
  case notrunning = "NOTRUNNING"
  case paused = "PAUSED"
}