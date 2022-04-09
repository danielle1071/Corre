//
//  RunningManager.swift
//  correWatch WatchKit Extension
//
//  Created by Lucas Morehouse on 4/8/22.
//

import Foundation
import Combine

final class RunningManager: ObservableObject {
    

    @Published var emergencyContacts = EmergencyContactResponseModel(emergencyContacts: [])
    @Published var runningStatus = RunningStatusModel(devRecordID: "")
    
    
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
    
    func getRunningStatus(for id: String) {
        let url = URL(string: "https://vmt4adr728.execute-api.us-east-1.amazonaws.com/dev/getstatus?usrID=\(id)")!
        NetworkManager<RunningStatusModel>().fetch(for: url) { (result) in
            switch result {
            case .failure(let err):
                print(err.localizedDescription)
            case .success(let resp):
                self.runningStatus = resp
                print("RESPONSE DATA FROM STATUS NETWORK CALL : \(self.runningStatus)")
            }
        }
    }
    
}
