//
//  MessageManager.swift
//  corre
//
//  Created by Fabricio Battaglia on 2/18/22.
//

import Amplify
import Foundation

class MessageManager: ObservableObject {
    @Published var messages = [Message]()
    @Published var currentId = ""
    @Published var friendId = ""
    
    func send(_ message: Message) {
        Amplify.API.mutate(request: .create(message)) { mutationResult in
            switch mutationResult {
            case .success(let creationResult):
                switch creationResult {
                case .success:
                    print("successfully created message")
                case .failure(let error):
                    print(error)
                }
            case .failure(let apiError):
                print(apiError)
            }
        }
    }
    
    func getMessages() {
        //MARK: Once we have that you can select a chat by friend, add && Message.keys.senderID == friendID
        //also add where senderId == currentId && receiverId == friendId
        Amplify.API.query(request: .list(Message.self, where: (Message.keys.receiverId == currentId && Message.keys.senderId == friendId) || (Message.keys.receiverId == friendId && Message.keys.senderId == currentId))) { [weak self] result in
            do {
                let messages = try result.get().get()

                
                //DELETING ALL MESSAGES
                /*
                messages.forEach{ message in
                    //self?.delete(message)
                    self?.deleteMessages(message)
                }
                 */
                

                DispatchQueue.main.async {
                    self?.messages = messages.sorted(by: { $0.creationDate < $1.creationDate})
                }
            } catch {
                print(error)
            }
        }
    }

    //this function deletes 1 message
    func deleteMessages(_ message: Message) {
        Amplify.API.mutate(request: .delete(message)) { result in
            print(result)
        }
    }

    var subscription: GraphQLSubscriptionOperation<Message>?
    func observeMessages() {
        subscription = Amplify.API.subscribe(
            request: .subscription(of: Message.self, type: .onCreate),

            valueListener: { [weak self] subscriptionEvent in
                switch subscriptionEvent {
                case .connection(let connectionState):
                    print("connection state:", connectionState)

                case .data(let dataResult):
                    do {
                        let message = try dataResult.get()

                        DispatchQueue.main.async {
                            self?.messages.append(message)
                        }
                    } catch {
                        print(error)
                    }
                }
            },
            completionListener: { completion in
                print(completion)
            }
        )
    }
    
    func setCurrentUserId(id: String) {
        self.currentId = id
    }
    
    func setCurrentFriendId(id: String) {
        self.friendId = id
    }
}
