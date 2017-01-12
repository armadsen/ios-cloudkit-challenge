//
//  CloudKitManager.swift
//  Timeline
//
//  Created by Andrew Madsen on 6/18/16.
//  Copyright © 2016 DevMountain. All rights reserved.
//

import Foundation
import CloudKit

private let CreatorUserRecordIDKey = "creatorUserRecordID"
private let LastModifiedUserRecordIDKey = "creatorUserRecordID"
private let CreationDateKey = "creationDate"
private let ModificationDateKey = "modificationDate"

protocol CloudKitSyncable : class {
	static var recordType: String { get }
	init?(cloudKitRecord: CKRecord)
	var cloudKitRecord: CKRecord { get set }
}

class CloudKitManager {
	
	let database = CKContainer.default().publicCloudDatabase
	
	func fetchRecords(ofType type: String,
	                  sortDescriptors: [NSSortDescriptor]? = nil,
	                  completion: @escaping ([CKRecord]?, Error?) -> Void) {
		
		let query = CKQuery(recordType: type, predicate: NSPredicate(value: true))
		query.sortDescriptors = sortDescriptors
		
		database.perform(query, inZoneWith: nil, completionHandler: completion)
	}
	
	func save(_ object: CloudKitSyncable, completion: @escaping ((Error?) -> Void) = { _ in }) {
		
		let record = object.cloudKitRecord
		
		database.save(record, completionHandler: { (record, error) in
			if record == nil || error != nil {
				completion(error)
				return
			}
			object.cloudKitRecord = record!
			completion(nil)
		})
	}
	
	func delete(_ object: CloudKitSyncable, completion: @escaping ((Error?) -> Void) = { _ in }) {
		let recordID = object.cloudKitRecord.recordID
		database.delete(withRecordID: recordID) { (recordID, error) in
			completion(error)
		}
	}
	
	func subscribeToCreationOfRecords(ofType type: String, completion: @escaping ((Error?) -> Void) = { _ in }) {
		let subscription = CKQuerySubscription(recordType: type, predicate: NSPredicate(value: true), options: .firesOnRecordCreation)
		
		let notificationInfo = CKNotificationInfo()
		notificationInfo.alertBody = "There's a new record available."
		subscription.notificationInfo = notificationInfo
		database.save(subscription, completionHandler: { (subscription, error) in
			if let error = error {
				NSLog("Error saving subscription: \(error)")
			}
			completion(error)
		})
	}
}
