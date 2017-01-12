//
//  ContactsController.swift
//  Contacts
//
//  Created by Andrew Madsen on 1/11/17.
//  Copyright © 2017 Dev Mountain. All rights reserved.
//

import Foundation

extension ContactsController {
	static let DidRefreshNotification = Notification.Name("DidRefreshNotification")
}

class ContactsController {
	
	static let shared = ContactsController()
	
	init() {
		refresh()
	}
	
	func refresh(completion: @escaping ((Error?) -> Void) = { _ in }) {
		let sortDescriptors = [NSSortDescriptor(key: Contact.nameKey, ascending: true)]
		cloudKitManager.fetchRecords(ofType: Contact.recordType, sortDescriptors: sortDescriptors) {
			(records, error) in
			
			defer { completion(error) }
			
			if let error = error {
				NSLog("Error fetching contacts: \(error)")
				return
			}
			guard let records = records else { return }
			
			self.contacts = records.flatMap { Contact(cloudKitRecord: $0) }
		}
	}
	
	func add(contact: Contact, completion: @escaping ((Error?) -> Void) = { _ in }) {
		cloudKitManager.save(contact) { (error) in
			defer { completion(error) }
			if let error = error {
				NSLog("Error saving \(contact) to CloudKit: \(error)")
				return
			}
			self.contacts.append(contact)
		}
	}
	
	func remove(contact: Contact, completion: @escaping ((Error?) -> Void) = { _ in }) {
		guard let index = contacts.index(of: contact) else {
			completion(nil)
			return
		}
		
		cloudKitManager.delete(contact) { (error) in
			if let error = error {
				completion(error)
				return
			}
			
			self.contacts.remove(at: index)
			completion(nil)
		}
	}
	
	func update(contact: Contact, with newContact: Contact, completion: @escaping ((Error?) -> Void) = { _ in }) {
		guard let index = contacts.index(of: contact),
			contact != newContact else { return } // Nothing to be done
		
		remove(contact: contact) { (error) in
			guard error == nil else {
				completion(error)
				return
			}
			
			self.cloudKitManager.save(newContact) { (error) in
				guard error == nil else {
					completion(error)
					return
				}
				
				var scratch = self.contacts
				scratch.remove(at: index)
				scratch.insert(newContact, at: index)
				self.contacts = scratch
				completion(nil)
			}
		}
		
	}
	
	func subscribeToPushNotifications(completion: @escaping ((Error?) -> Void) = { _ in }) {
		
		cloudKitManager.subscribeToCreationOfRecords(ofType: Contact.recordType) { (error) in
			if let error = error {
				NSLog("Error saving subscription: \(error)")
			} else {
				NSLog("Subscribed to push notifications for new contacts")
			}
			completion(error)
		}
	}
	
	private(set) var contacts = [Contact]() {
		didSet {
			let nc = NotificationCenter.default
			nc.post(name: ContactsController.DidRefreshNotification, object: self)
		}
	}
	
	private let cloudKitManager = CloudKitManager()
}
