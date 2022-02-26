// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "e6690b3a66105e48caee2377ee6dd3ae"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Notification.self)
    ModelRegistry.register(modelType: Message.self)
    ModelRegistry.register(modelType: Device.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EmergencyContact.self)
    ModelRegistry.register(modelType: Run.self)
  }
}