// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "a187b2fd5f42f6cab92580c17f8f1d13"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Message.self)
    ModelRegistry.register(modelType: Device.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EmergencyContact.self)
    ModelRegistry.register(modelType: Run.self)
  }
}