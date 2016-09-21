//
//  ContactController.swift
//  ContactsStretchProblem
//
//  Created by Spencer Curtis on 9/17/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

class ContactController {
    
    static let publicDB = CKContainer.default().publicCloudDatabase
    
    static var contacts: [Contact] = []
    
    static func saveContactToCloudKit(name: String, email: String, phoneNumber: Int) {
        
        let contact = Contact(name: name, email: email, phoneNumber: phoneNumber)
        
        publicDB.save(contact.cloudKitRecord) { (_, error) in
            if let error = error  {
                print(error.localizedDescription)
            } else {
                contacts.append(contact)
            }
        }
    }
    
    static func fetchContacts(completion: @escaping () -> Void) {
        
        let query = CKQuery(recordType: "Contact", predicate: NSPredicate(value: true))
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            guard let records = records else { return }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.contacts = records.flatMap({Contact(cloudKitRecord: $0)})
            completion()
        }
    }
    
    static func subscribeToNewContacts() {
        if #available(iOS 10.0, *) {
            let subscription = CKQuerySubscription(recordType: "Contact", predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
            
            let notificationInfo = CKNotificationInfo()
            
            notificationInfo.alertBody = "A new contact has been added"
            notificationInfo.soundName = UILocalNotificationDefaultSoundName
            
            subscription.notificationInfo = notificationInfo
            
            publicDB.save(subscription) { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Successfully subscribed to new contacts")
                }
            }
        } else {
            let subscription = CKSubscription(recordType: "Contact", predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
            
            let notificationInfo = CKNotificationInfo()
            
            notificationInfo.alertBody = "A new contact has been added"
            notificationInfo.soundName = UILocalNotificationDefaultSoundName
            
            subscription.notificationInfo = notificationInfo
            
            publicDB.save(subscription) { (_, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Successfully subscribed to new contacts")
                }
            }
        }
    }
}
