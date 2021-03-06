//
//  Tweet.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation

struct Tweet {
    let caption:String
    let id:String
    let likes:Int
    let retweets:Int
    let timestamp:Date
    let userId:String
//    let user:User
    let replieTweets:[String]
    let likeUsers:[String]
    
    init(data:[String:Any], id:String) {
        let userId = data["userId"] as? String ?? ""
        let timeinterval = data["timestamp"] as? Int ?? 0
        let caption = data["caption"] as? String ?? ""
        let likes = data["likes"] as? Int ?? 0
        let retweets = data["retweets"] as? Int ?? 0
        
        let replieTweets = data["replieTweets"] as? [String] ?? []
        let likeUsers = data["likeUsers"] as? [String] ?? []
        
        let timestamp = Date(timeIntervalSince1970: TimeInterval(timeinterval))
        
        self.caption = caption
        self.userId = userId
        self.timestamp = timestamp
        self.id = id
        self.likes = likes
        self.retweets = retweets
//        self.user = user
        self.replieTweets = replieTweets
        self.likeUsers = likeUsers
    }
    
}
