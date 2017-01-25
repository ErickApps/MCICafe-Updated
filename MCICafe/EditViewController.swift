//
//  EditViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/12/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class EditViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descripitionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    var item: MenuSpecials?
    var indexKey: String?
    var nodeKey: String?
    let url = "https://fcm.googleapis.com/fcm/send"
   
    var ref: FIRDatabaseReference!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        sendMessage()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveButton(_ sender: UIButton) {
        ref = FIRDatabase.database().reference()
        
        let post = ["title": titleTextField.text!,
                    "description": descripitionTextField.text!,
                    "cost": costTextField.text!]

        ref.child("menu").child("specials").updateChildValues(["0": post])
        

        
    }

    func configureView() {
        // Update the user interface.
        
        
        titleLabel.text = item?.title
        descriptionLabel.text = item?.description ?? ""
        costLabel.text = item?.cost
        
        
    }
    
    func sendMessage()  {
        
        let token = FIRInstanceID.instanceID().token()!
//        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
//
//        request.httpMethod = "POST"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        request.setValue("key=AAAAL644vRY:APA91bGsDOi2kNyK5pnRjkvBVOK47-UhllnHIk3_33PP4O0C0os2ur1YpY4l-KPuRGl1f-GoBgkh_8q3Xk4Ttdc_sdNl5UHC-VxMyY7BxTJuzu0hb65rSyjbGvWuAR2GW_JxF9X9r0qmHZD2UR7SYSt6YFrys3lSvw", forHTTPHeaderField: "Authorization")
//        
//        //let postParams: [String : Any] = ["to": token, "notification": ["body": "bodmmy", "title": "This is the title."]]
//    
//       //let postParams: [String : Any] = ["to": "/topics/notification", "data": ["body": "bodmmy", "title": "This is the title."]]
//        
//        let postParams: [String: Any] = [
//            "to": "/topics/notification",
//            "data": [
//                "message": "This is the body."]]
//        
//        do
//        {
//            request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
//            print("My paramaters: \(postParams)")
//        }
//        catch
//        {
//            print("Caught an error: \(error)")
//        }
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            
//            if let realResponse = response as? HTTPURLResponse
//            {
//                if realResponse.statusCode != 200
//                {
//                    print("Not a 200 response")
//                }
//            }
//            
//            if let postString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as? String
//            {
//                print("POST: \(postString)")
//            }
//        }
//        
//        task.resume()
        
    }



   
}
