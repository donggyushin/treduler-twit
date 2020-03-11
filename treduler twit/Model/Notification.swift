//
//  Notification.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/10.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation

struct Notification {
    let id:String
    let from:String
    let to:String
    // LIKE || RETWEET || FOLLOW
    let type:String
    let tweetId:String
    let isRead:Bool
    
    init(data:[String:Any]) {
        let from = data["from"] as? String ?? ""
        let isRead = data["isRead"] as? Bool ?? false
        let to = data["to"] as? String ?? ""
        let tweetId = data["tweetId"] as? String ?? ""
        let type = data["type"] as? String ?? ""
        let id = data["id"] as? String ?? ""
        
        self.from = from
        self.to = to
        self.type = type
        self.tweetId = tweetId
        self.isRead = isRead
        self.id = id
        
    }
}
