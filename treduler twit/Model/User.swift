//
//  User.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation

struct User {
    let profileImageUrl:String
    let email:String
    let username:String
    let uid:String
    let name:String
    let tweetIds:[String]
    let following:[String]
    let followers:[String]
    let tweetsILiked:[String]
    
    init(data:[String:Any]) {
        let profileImageUrl = data["profileImageUrlString"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        let uid = data["uid"] as? String ?? ""
        let name = data["name"] as? String ?? ""
        let tweetIds = data["tweetIds"] as? [String] ?? []
        let following = data["following"] as? [String] ?? []
        let followers = data["followers"] as? [String] ?? []
        let tweetsILiked = data["tweetsILiked"] as? [String] ?? []
        
        self.profileImageUrl = profileImageUrl
        self.email = email
        self.username = username
        self.uid = uid
        self.name = name
        self.tweetIds = tweetIds
        self.following = following
        self.followers = followers
        self.tweetsILiked = tweetsILiked
    }
}
