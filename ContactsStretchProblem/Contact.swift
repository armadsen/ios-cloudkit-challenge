//
//  Contact.swift
//  ContactsStretchProblem
//
//  Created by Spencer Curtis on 9/17/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    private let recordType = "Contact"
    private let kName = "name"
    private let kEmail = "email"
    private let kPhoneNumber = "phoneNumber"
    
    let name: String
    let email: String
    let phoneNumber: Int
    
    
    init(name: String, email: String, phoneNumber: Int) {
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    init?(cloudKitRecord: CKRecord) {
        guard let name = cloudKitRecord[kName] as? String, let email = cloudKitRecord[kEmail] as? String, let phoneNumber = cloudKitRecord[kPhoneNumber] as? Int else { return nil }
        
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        
    }
    
    var cloudKitRecord: CKRecord {
        let record = CKRecord(recordType: recordType)
        record.setValuesForKeys([kName: name, kEmail: email, kPhoneNumber: phoneNumber])
        return record
    }
    
}
