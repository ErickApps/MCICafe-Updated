//
//  NotificationViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 1/27/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import Firebase


class NotificationViewController: UIViewController,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var msgTexField: UITextView!
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet weak var tableView: UITableView!
    let userDMsg = UserDefaults.standard
    
    var msgArr: Array <String> = [] {
        didSet {
            tableView.reloadData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        notiMsgFireBase()
        
        msgTexField.delegate = self
        msgTexField.layer.borderColor = #colorLiteral(red: 0.7950288653, green: 0.7827144265, blue: 0.1463494599, alpha: 1).cgColor
        msgTexField.layer.borderWidth = 1.0
        msgTexField.layer.cornerRadius = 5.0
        
       
        
        
        
        registerForKeyboardNotifications()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NotificationViewController.keyboardDismiss))
        view.addGestureRecognizer(tap)
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func exitDoneButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
//    func deregisterFromKeyboardNotifications(){
//        //Removing notifies on keyboard appearing
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.isScrollEnabled = false
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let msgTexField = self.msgTexField {
            if (!aRect.contains(msgTexField.frame.origin)){
                self.scrollView.scrollRectToVisible(msgTexField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
//    func textViewDidBeginEditing(_ textField: UITextField){
//        msgTexField = textField
//        
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        msgTexField = textView
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        msgTexField.text = nil
    }
    
    func keyboardDismiss() {
        msgTexField.resignFirstResponder()
        
    }
    
    
    //Dismiss keyboard using Return Key (Done) Button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardDismiss()
        
        return true
    }
    func displayAlert(title: String, message: String) {
        
        
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            //self.dismiss(animated: true, completion: nil)
        }))
        
        
        present(refreshAlert, animated: true, completion: nil)
        
    }

    
    @IBAction func sendButton(_ sender: UIButton) {
        
        if msgTexField.text == "" {
            displayAlert(title: "empty", message: "cannot send empty message")
            return
        }else {
            
            let msgText = msgTexField.text!
            
            var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
            
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.setValue("key=AAAAL644vRY:APA91bGsDOi2kNyK5pnRjkvBVOK47-UhllnHIk3_33PP4O0C0os2ur1YpY4l-KPuRGl1f-GoBgkh_8q3Xk4Ttdc_sdNl5UHC-VxMyY7BxTJuzu0hb65rSyjbGvWuAR2GW_JxF9X9r0qmHZD2UR7SYSt6YFrys3lSvw", forHTTPHeaderField: "Authorization")
            
            
            let postParams: [String : Any] = ["to": "/topics/notification","priority": "high", "content_available": true,"time_to_live" : 5, "notification": ["body": msgText]]
            
            let date = Date()
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour,.minute], from: date)
            let toDay = "\(components.year!)-\(components.month!)-\(components.day!)/\(components.hour!):\(components.minute!)"
           
           
        
            
            DispatchQueue.main.async(){
                
                do
                {
                    request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
                }
                catch
                {
                    print("Caught an error: \(error)")
                }
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    
                    if let realResponse = response as? HTTPURLResponse
                    {
                        if realResponse.statusCode != 200
                        {
                            print("Not a 200 response")
                        }else {
                            
                            
                            
                            let ref = FIRDatabase.database().reference().child("notification")
                            
                            
                            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                
                                let post = ["message": msgText]
                                ref.updateChildValues([toDay:post])
                                
                                
                            })
                            
                            
                            
                        }
                    }
                    
                    
                }
                
                task.resume()
                
            }

            
            
        }

        
        
        
        
        
        keyboardDismiss()
        
        msgTexField.text = nil

        

    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notiCell", for: indexPath) as! NotiTableViewCell
        
       
        
    
        let noti = self.msgArr[indexPath.row]
        
        cell.notificationLabel.text = noti
        
        return cell
        
    }
    
    func notiMsgFireBase()  {
        var ref: FIRDatabaseReference!
       
        
        ref = FIRDatabase.database().reference().child("notification")
        
        ref.observe(FIRDataEventType.value, with: { (snapshot) in
            
            let noti = snapshot.value as! [String:AnyObject]
             var tempMsg: Array<String> = []
            for datekey in noti.keys{
                print(noti[datekey]!.allKeys!)
                
                for key in noti[datekey]!.allKeys!{
                    let msg = noti[datekey]?[key] as! NSDictionary
                    
                    tempMsg.append(msg["message"]! as! String)
                    print(msg["message"]!)
                }
            }
            self.msgArr = tempMsg
            tempMsg = []
            print(tempMsg)
        })

    }

    
    
    
}

    
