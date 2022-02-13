// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "9ad9000ea4c3a4b5f8658612fc188fd7"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Device.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EmergencyContact.self)
    ModelRegistry.register(modelType: Run.self)
  }
}