//
//  EditViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/12/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase




class EditViewController: UIViewController {
    
    var item: Menu?
    var indexKey: String?
    var nodeKey: String?
    var endOfIndex: String?
    



    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descripitionTextField: UITextField!
    @IBOutlet weak var costTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.isHidden = true
        deleteButton.isHidden = true
        self.configureView()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func optionsSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            editButton.isHidden = false
            addButton.isHidden = true
            deleteButton.isHidden = true
           
        }else if sender.selectedSegmentIndex == 1 {
            editButton.isHidden = true
            addButton.isHidden = false
            deleteButton.isHidden = true
        }
        else if sender.selectedSegmentIndex == 2 {
            editButton.isHidden = true
            addButton.isHidden = true
            deleteButton.isHidden = false
        }


        
    }
    
    
    @IBAction func editButton(_ sender: UIButton) {
        
        
        operation(operationType: "edit")
        self.dismiss(animated: true, completion: nil)

        
//        let ref = getChildLocation(nodeKey: nodeKey!)
//        
//                if nodeKey ==  nodeLocation.coffee.rawValue || nodeKey ==  nodeLocation.softDrink.rawValue{
//            if let title = titleTextField.text,
//               let cost = costTextField.text
//            {
//                let post = ["title": title,"cost": cost]
//                ref.updateChildValues([indexKey!: post])
//            }
//        
//        }else {
//                    if let title = titleTextField.text, let description = descripitionTextField.text, let cost = costTextField.text {
//                        let post = ["title": title,
//                                    "description": description,
//                                    "cost": cost]
//                        ref.updateChildValues([indexKey!: post])
//                        
//                    }
//
//            
//        }
    }
    
    @IBAction func addButton(_ sender: UIButton) {
        
        

        
        operation(operationType: "add")
        


    }

    @IBAction func deleteButton(_ sender: UIButton) {
        
        let ref = getChildLocation(nodeKey: nodeKey!)
        
        
        var startIndex = Int(indexKey!)!
        
               
        
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                let nsArr =  snapshot.value as! NSArray
                let endIndex = Int(snapshot.childrenCount-1)
                
                for i in startIndex..<endIndex{
                    
                    let dicData = nsArr[i+1] as! NSDictionary
                    ref.child(String(i)).setValue(dicData.dictionaryWithValues(forKeys: ["title","cost","description"]))
                }
                ref.child(String(snapshot.childrenCount-1)).removeValue()
                
            })
            
        self.dismiss(animated: true, completion: nil)

        
        
        
        
       // ref.observeSingleEvent(of: <#T##FIRDataEventType#>, with: <#T##(FIRDataSnapshot) -> Void#>)
        
//        ref.observe(., with: <#T##(FIRDataSnapshot) -> Void#>)
        
        
//        print(ref.child(indexKey!))
//        ref.child(indexKey!).setValue(ref.child("1") as! NSDictionary)
         //ref.child(indexKey!).removeValue()
//        for i in startIndex..<endIndex {
//            
//            //ref.updateChildValues([String(i+1): String(i)])
//            
//            ref.child(indexKey!).setValue(ref.child("1"))
//        }
        
        
        
    }
    func configureView() {
        // Update the user interface.
        
        
        titleLabel.text = item?.title
        descriptionLabel.text = item?.description ?? ""
        costLabel.text = item?.cost
        
        
    }
    
    func operation(operationType: String) {
        
//        var action: String?
        let ref = getChildLocation(nodeKey: nodeKey!)
        var index = operationType
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            switch index{
                case "add": index = String(snapshot.childrenCount)
                case "edit": index = self.indexKey!
            default : break
            }
            
            if self.nodeKey ==  nodeLocation.coffee.rawValue || self.nodeKey ==  nodeLocation.softDrink.rawValue{
                if let title = self.titleTextField.text,
                    let cost = self.costTextField.text
                {
                    let post = ["title": title,"cost": cost]
                    ref.updateChildValues([index: post])
                }
                
            }else {
                if let title = self.titleTextField.text, let description = self.descripitionTextField.text, let cost = self.costTextField.text {
                    let post = ["title": title,
                                "description": description,
                                "cost": cost]
                    ref.updateChildValues([index: post])
                    
                }
                
                
            }

            
            
        })

//        switch operation {
//        case "edit": action = "edit"
//        case "add": action = "add"
//        default: break
//        }
        
        
//        if nodeKey ==  nodeLocation.coffee.rawValue || nodeKey ==  nodeLocation.softDrink.rawValue{
//            if let title = titleTextField.text,
//                let cost = costTextField.text
//            {
//                let post = ["title": title,"cost": cost]
//                ref.updateChildValues([index: post])
//            }
//            
//        }else {
//            if let title = titleTextField.text, let description = descripitionTextField.text, let cost = costTextField.text {
//                let post = ["title": title,
//                            "description": description,
//                            "cost": cost]
//                ref.updateChildValues([index: post])
//                
//            }
//            
//            
//        }

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
