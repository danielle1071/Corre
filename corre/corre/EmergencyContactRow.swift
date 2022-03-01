//
//  EmergencyContactRow.swift
//  corre
//
//  Created by Lucas Morehouse on 2/28/22.
//

import SwiftUI

struct EmergencyContactRow: View {
    
    var emergencyContact: EmergencyContact
    
    var body: some View {
        Text("\(emergencyContact.firstName ?? "") \(emergencyContact.lastName ?? "")")
    }
}

struct EmergencyContactRow_Previews: PreviewProvider {
    static var previews: some View {
        EmergencyContactRow(emergencyContact: EmergencyContact(id: "000", firstName: "Database", lastName: "Guy", email: "ERROR@ERROR.COM", phoneNumber: "+10000000000", appUser: true, emergencyContactUserId: "002", userID: "001", emergencyContactAppUsername: "test"))
    }
}
