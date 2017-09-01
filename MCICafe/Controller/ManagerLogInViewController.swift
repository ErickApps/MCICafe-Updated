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
    
    if let email = emailTextField.text,let password = passwordTextField.text {
      FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
        // if login fails display the error else login
        if (error != nil) {
          self.displayAlert(title: "Error", message: (error?.localizedDescription)!, dismiss: false)
          self.emailTextField.text = nil
          self.passwordTextField.text = nil
        }
        else if isLogIn(){
          self.displayAlert(title: "Loged-In", message: ("Login succesfull"), dismiss: true)
        }
        
      }
    }
  }
  
  func displayAlert(title: String, message: String, dismiss: Bool) {
    
    
    let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
    
    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
      if dismiss {
        self.dismiss(animated: true, completion: nil)
      }
    }))
    
    present(refreshAlert, animated: true, completion: nil)
    
    
  }
  
  @IBAction func backButton(_ sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
