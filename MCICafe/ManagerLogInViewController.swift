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
    @IBOutlet weak var logoutButton: UIButton!
    @IBAction func logout(_ sender: UIButton) {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        
        if let email = emailTextField.text,let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
                
                if (error != nil) {
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                    self.emailTextField.text = nil
                    self.passwordTextField.text = nil
                }
                else if isLogIn(){
                    self.displayAlert(title: "LogedIn", message: ("Login succesfull"))
                    
                }
                
                
                
            }
            
        }
        
        
    }
    
    func displayAlert(title: String, message: String) {
        
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        present(refreshAlert, animated: true, completion: nil)
        
        
    }

    @IBAction func backButton(_ sender: UIButton) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "tabController") as! UITabBarController
        self.present(controller, animated: true, completion: nil)
    }
    

    
    
}
