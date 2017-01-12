//
//  ManagerLogInViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/11/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase

class ManagerLogInViewController: UIViewController {
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        
        
                
        FIRAuth.auth()?.signIn(withEmail: email!, password: password!) { (user, error) in
           //print(user?.isEmailVerified ?? "default")
            
        }
        
    }
    

    
    
}
