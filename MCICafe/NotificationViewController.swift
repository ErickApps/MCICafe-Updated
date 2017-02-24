//
//  ViewController.swift
//  MCICafe
//
//  Created by Erick Barbosa on 2/19/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    let image = #imageLiteral(resourceName: "MCI_Logo_Only")
    
    let AvatarMCI = JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "MCI_Logo_Only"), diameter: 100)
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    
    
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: FIRDatabaseReference!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
        self.senderId = "Me"
        self.senderDisplayName = "displayseder"
        
        // Bubbles with tails
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        
        
        // no avatars
        // collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        
        
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        setupFirebase()
        setupBackButton()
    }
    
    
    func setupBackButton() {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        sendNotification(text: text)
        saveNotificatioFirebase(text: text)
        //self.messages.append(message!)
        self.finishSendingMessage(animated: true)
    }
    
    
    
    //MARK: JSQMessages CollectionView DataSource
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
        
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return AvatarMCI
    }
    
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
    }
    
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    
    
    
    
    func sendNotification(text: String){
        
        let msgText = text
        
        var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAL644vRY:APA91bGsDOi2kNyK5pnRjkvBVOK47-UhllnHIk3_33PP4O0C0os2ur1YpY4l-KPuRGl1f-GoBgkh_8q3Xk4Ttdc_sdNl5UHC-VxMyY7BxTJuzu0hb65rSyjbGvWuAR2GW_JxF9X9r0qmHZD2UR7SYSt6YFrys3lSvw", forHTTPHeaderField: "Authorization")
        
        
        let postParams: [String : Any] = ["to": "/topics/notification","priority": "high", "content_available": true,"time_to_live" : 5, "notification": ["body": msgText]]
        
        
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
                
                
                
            }
            
            task.resume()
        }
    }
    
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        // let uid = FIRAuth.auth()?.currentUser?.uid
        //JSQSystemSoundPlayer.jsq_playMessageReceivedAlert()
        messagesRef = FIRDatabase.database().reference().child("msg")
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.queryLimited(toLast: 25).observe(FIRDataEventType.childAdded, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let text = value?["text"] as? String
            
            
            let message = JSQMessage(senderId: "MCI", displayName: "displayName", text: text!)
            
            self.messages.append(message!)
            self.finishReceivingMessage()
        })
    }
    func saveNotificatioFirebase(text: String) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        
        messagesRef.childByAutoId().setValue(["text":text])
    }
    
    
    
    
    
}
