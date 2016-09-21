//
//  ViewController.swift
//  ContactsStretchProblem
//
//  Created by Spencer Curtis on 9/17/16.
//  Copyright © 2016 Spencer Curtis. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func saveContactButtonTapped(_ sender: AnyObject) {
        
        guard let name = nameTextField.text, let phoneNumber = phoneNumberTextField.text, let phoneNumberInt = Int(phoneNumber), let email = emailTextField.text else { return }
    
        ContactController.saveContactToCloudKit(name: name, email: email, phoneNumber: phoneNumberInt)
    }
}

