//
//  Contact.swift
//  Contacts
//
//  Created by Andrew Madsen on 1/11/17.
//  Copyright © 2017 Dev Mountain. All rights reserved.
//

import Foundation
import CloudKit

class Contact: CloudKitSyncable {
	
	static var recordType: String { return "Contact" }
	static var nameKey: String { return "name" }
	static var phoneNumberKey: String { return "phoneNumber" }
	static var emailAddressKey: String { return "emailAddress" }
	
	init(name: String, phoneNumber: String?, emailAddress: String?) {
		self.name = name
		self.phoneNumber = phoneNumber
		self.emailAddress = emailAddress
	}
	
	required init?(cloudKitRecord: CKRecord) {
		guard let name = cloudKitRecord[Contact.nameKey] as? String,
			cloudKitRecord.recordType == Contact.recordType else {
				return nil
		}
		
		self.name = name
		self.phoneNumber = cloudKitRecord[Contact.phoneNumberKey] as? String
		self.emailAddress = cloudKitRecord[Contact.emailAddressKey] as? String
		self.cloudKitRecord = cloudKitRecord
	}
	
	var name: String
	var phoneNumber: String?
	var emailAddress: String?
	
	private var newCloudKitRecord: CKRecord {
		let record = CKRecord(recordType: Contact.recordType)
		record[Contact.nameKey] = name as NSString?
		record[Contact.phoneNumberKey] = phoneNumber as NSString?
		record[Contact.emailAddressKey] = emailAddress as NSString?
		return record
	}
	
	private var _cloudKitRecord: CKRecord? = nil
	var cloudKitRecord: CKRecord {
		get {
			return _cloudKitRecord ?? newCloudKitRecord
		}
		set {
			_cloudKitRecord = newValue
		}
	}
}

extension Contact: Hashable {
	var hashValue: Int {
		return name.hashValue
	}
}

func ==(lhs: Contact, rhs: Contact) -> Bool {
	if lhs.name != rhs.name { return false }
	if lhs.phoneNumber != rhs.phoneNumber { return false }
	if lhs.emailAddress != rhs.emailAddress { return false }
	
	return true
}
