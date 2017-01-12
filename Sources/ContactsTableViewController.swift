//
//  ContactsTableViewController.swift
//  Contacts
//
//  Created by Andrew Madsen on 1/11/17.
//  Copyright © 2017 Dev Mountain. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
	
	// MARK: Overridden
	
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		commonInit()
	}
	
	func commonInit() {
		let nc = NotificationCenter.default
		nc.addObserver(self, selector: #selector(dataDidRefresh(_:)), name: ContactsController.DidRefreshNotification, object: nil)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
	}
	
	// MARK: Public Methods
	
	// MARK: Actions
	
	// MARK: UITableViewDataSource/Delegate
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return ContactsController.shared.contacts.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
		
		let contacts = ContactsController.shared.contacts
		cell.textLabel?.text = contacts[indexPath.row].name
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
		guard editingStyle == .delete else { return } // Only support delete right now
		
		let cc = ContactsController.shared
		let contact = cc.contacts[indexPath.row]
		cc.remove(contact: contact) { (error) in
			if let error = error {
				NSLog("Error deleting contact \(contact): \(error)")
				return
			}
		}
	}
	
	// MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let detailVC = segue.destination as? ContactDetailViewController {
			if let cell = sender as? UITableViewCell,
				let indexPath = tableView.indexPath(for: cell) {
				let contacts = ContactsController.shared.contacts
				detailVC.contact = contacts[indexPath.row]
				detailVC.title = "Edit Contact"
			} else {
				detailVC.title = "Create Contact"
			}
		}
	}
	
	// MARK: Private Methods
	
	// MARK: Notifications
	
	func dataDidRefresh(_ notification: NSNotification) {
		DispatchQueue.main.async {
			self.tableView.reloadData()
		}
	}
	
	// MARK: Public Properties
	
	// MARK: Private Properties
	
	// MARK: Outlets
	
}
