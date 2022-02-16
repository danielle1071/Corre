// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "2812d19658efac52dee98f9d95d40f1a"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Device.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EmergencyContact.self)
    ModelRegistry.register(modelType: Run.self)
  }
}