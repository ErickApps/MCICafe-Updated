//
//  NotiTextViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 2/11/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit

class NotiTextViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var notiTextView: UITextView!
    @IBOutlet weak var tableView: UITableView!
    var arr = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
         arr = ["rame = (0 0; 375 258); layer = <CALayer: 0x17022ee20>>) with","Dispose of any resources that can be recreated","creenUpdates:NO, because the view is not in a window. Use afterScreenUpdates:YES","   lsfisf;msl;fm  ","jehfosijlksmkladjfsao;jf"]


        // Do any additional setup after loading the view.
    }
    @IBAction func sendButton(_ sender: UIButton) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notiCell", for: indexPath) as! NotiTableViewCell
        
        let noti = self.arr[(indexPath as NSIndexPath).row]
        
        cell.notificationLabel.text = noti
        
        return cell

    }
    
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.tableView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.tableView.isScrollEnabled = false
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let msgTexField = self.notiTextView {
            if (!aRect.contains(msgTexField.frame.origin)){
                self.tableView.scrollRectToVisible(msgTexField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.tableView.contentInset = contentInsets
        self.tableView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.tableView.isScrollEnabled = false
    }
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
