// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "b00662b8d3478f117ad08c98065cba35"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Device.self)
    ModelRegistry.register(modelType: User.self)
    ModelRegistry.register(modelType: EmergencyContact.self)
    ModelRegistry.register(modelType: Run.self)
  }
}