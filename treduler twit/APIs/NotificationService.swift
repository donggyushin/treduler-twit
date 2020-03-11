//
//  NotificationService.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/11.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    let db = Firestore.firestore()
    
    func fetchNotifications(completion:@escaping([Notification]) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        var notifications = [Notification]()
        db.collection("users").document(userId).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let data = querySnapshot!.data()!
                let notificationIds = data["notifications"] as? [String] ?? []
                
                for notificationId in notificationIds {
                    self.db.collection("notifications").document(notificationId).getDocument { (querySnapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            let data = querySnapshot!.data()!
                            let notification = Notification(data: data)
                            notifications.append(notification)
                            completion(notifications)
                            self.db.collection("notifications").document(notificationId).updateData(["isRead" : true])
                        }
                    }   // end db.collection.notifications
                    
                }
            }
        }   // end db.collection.users
    }
}
