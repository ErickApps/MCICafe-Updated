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
  
  var messagesRef: FIRDatabaseReference!
  var messages = [JSQMessage]()
  var incomingBubble: JSQMessagesBubbleImage!
  var outgoingBubble: JSQMessagesBubbleImage!
  
  let image = #imageLiteral(resourceName: "MCI_Logo_Only")
  let AvatarMCI = JSQMessagesAvatarImageFactory.avatarImage(with: #imageLiteral(resourceName: "MCI_Logo_Only"), diameter: 100)
  fileprivate var displayName: String!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupView()
    setupFirebase()
    setupBackButton()
  }
  func setupView()  {
    collectionView?.reloadData()
    collectionView?.layoutIfNeeded()
    navigationController?.navigationBar.isTranslucent = true
    inputToolbar.contentView.leftBarButtonItem.isHidden = true
    senderId = FIRAuth.auth()?.currentUser?.uid
    senderDisplayName = "MCI"
    
    // Bubbles with tails
    incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with:
      UIColor.lightGray)
    
    automaticallyScrollsToMostRecentMessage = true
  }
  
  func setupBackButton() {
    let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain,
                                     target: self, action: #selector(backButtonTapped))
    
    navigationItem.leftBarButtonItem = backButton
  }
  func backButtonTapped() {
    dismiss(animated: true, completion: nil)
  }
  
  override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
    
    JSQSystemSoundPlayer.jsq_playMessageSentSound()
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
    
    return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    
  }
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
    return AvatarMCI
  }
  
  
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
    
    if (indexPath.item % 3 == 0) {
      let message = self.messages[indexPath.item]
      
      return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
    }
    
    return nil
  }
  
  
  override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
    
    if indexPath.item % 3 == 0 {
      return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    return 0.0
  }
  func setupFirebase() {
    
    messagesRef = FIRDatabase.database().reference().child("msg")
    
    // ***  RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
    messagesRef.queryLimited(toLast: 25).observe(FIRDataEventType.childAdded, with: { (snapshot) in
      
      if let value = snapshot.value as? NSDictionary, let text = value["text"] as? String, let senderId = value["senderId"] as? String {
        let message = JSQMessage(senderId: senderId, displayName: self.senderDisplayName, text: text)
        self.messages.append(message!)
        self.finishReceivingMessage()
      } else {
        self.saveNotificatioFirebase(text: "")
      }
      
    })
    
  }
  
  
  
}
