//
//  NotificationExtension.swift
//  MCICafe
//
//  Created by Erick Barbosa on 8/31/17.
//  Copyright © 2017 Erick Barbosa. All rights reserved.
//

import Foundation

extension ViewController {
  
  func sendNotification(text: String){
    
    var request = URLRequest(url: URL(string: "https://fcm.googleapis.com/fcm/send")!)
    
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("key=AAAAL644vRY:APA91bGsDOi2kNyK5pnRjkvBVOK47-UhllnHIk3_33PP4O0C0os2ur1YpY4l-KPuRGl1f-GoBgkh_8q3Xk4Ttdc_sdNl5UHC-VxMyY7BxTJuzu0hb65rSyjbGvWuAR2GW_JxF9X9r0qmHZD2UR7SYSt6YFrys3lSvw", forHTTPHeaderField: "Authorization")
    
    
    let postParams: [String : Any] = ["to": "/topics/notification","priority": "high", "content_available": true,"time_to_live" : 5, "notification": ["body": text]]
    
    
    DispatchQueue.main.async(){
      
      do {
        request.httpBody = try JSONSerialization.data(withJSONObject: postParams, options: JSONSerialization.WritingOptions())
      } catch {
        print("Caught an error: \(error)")
      }
      
      let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        }
      
      task.resume()
    }
  }
  
  
  func saveNotificatioFirebase(text: String) {
    self.messagesRef.childByAutoId().setValue(["text":text, "senderId":self.senderId])
  }
  
  
  
}
