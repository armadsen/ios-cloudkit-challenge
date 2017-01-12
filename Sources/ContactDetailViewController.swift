//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Andrew Madsen on 1/11/17.
//  Copyright © 2017 Dev Mountain. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
	
	// MARK: Overridden
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		updateViews()
	}
	
	// MARK: Public Methods
	
	// MARK: Actions
	
	@IBAction func saveContact(_ sender: Any) {
		guard let name = nameField.text else {
			return
		}
		let email = emailField.text
		let phoneNumber = phoneField.text
		
		let newContact = Contact(name: name, phoneNumber: phoneNumber, emailAddress: email)
		let contactsController = ContactsController.shared
		if let oldContact = self.contact {
			contactsController.update(contact: oldContact, with: newContact)
		} else {
			contactsController.add(contact: newContact)
		}
		
		let _ = self.navigationController?.popViewController(animated: true)
	}
	
	// MARK: Private Methods
	
	private func updateViews() {
		guard let contact = contact, isViewLoaded else { return }
		
		nameField.text = contact.name
		phoneField.text = contact.phoneNumber
		emailField.text = contact.emailAddress
	}
	
	// MARK: Public Properties
	
	var contact: Contact? {
		didSet {
			updateViews()
		}
	}
	
	// MARK: Private Properties
	
	// MARK: Outlets
	
	@IBOutlet var nameField: UITextField!
	@IBOutlet var phoneField: UITextField!
	@IBOutlet var emailField: UITextField!
}
