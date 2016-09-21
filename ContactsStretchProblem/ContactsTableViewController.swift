//
//  ContactsTableViewController.swift
//  ContactsStretchProblem
//
//  Created by Spencer Curtis on 9/18/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        ContactController.fetchContacts {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactController.contacts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

        let contact = ContactController.contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name
        cell.detailTextLabel?.text = "\(contact.phoneNumber)"

        return cell
    }
}
