//
//  RunningManager.swift
//  correWatch WatchKit Extension
//
//  Created by Lucas Morehouse on 4/8/22.
//

import Foundation
import Combine

final class RunningManager: ObservableObject {
    
//    @Published var emergencyContactList = TestNetworkResponseModel(usrID: "")
    @Published var emergencyContacts = EmergencyContactResponseModel(emergencyContacts: [])
//    func getNetworkCall(for id: String) {
//        let url = URL(string: "https://vmt4adr728.execute-api.us-east-1.amazonaws.com/dev/correres?usrID=\(id)")!
//        NetworkManager<TestNetworkResponseModel>().fetch(for: url) { (result) in
//            switch result {
//            case .failure(let err):
//                print(err.localizedDescription)
//            case .success(let resp):
//                self.emergencyContactList = resp
//                print("RESPONSE DATA FROM NETWORK CALL : \(self.emergencyContactList)")
//            }
//        }
//    }
    
    func getEmergencyContacts(for id: String) {
        let url = URL(string: "https://vmt4adr728.execute-api.us-east-1.amazonaws.com/dev/correres?usrID=\(id)")!
        NetworkManager<EmergencyContactResponseModel>().fetch(for: url) { (result) in
            switch result {
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let resp):
                self.emergencyContacts = resp
                print("RESPONSE DATA FROM NETWORK CALL : \(self.emergencyContacts)")
            }
        }
    }
}
