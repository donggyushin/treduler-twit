//
//  TweetService.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    let db = Firestore.firestore()
    func postTweet(caption:String, completion:@escaping(Error?, DocumentReference?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var ref:DocumentReference?
        ref = db.collection("tweets").addDocument(data: ["userId": uid, "caption":caption, "likes": 0, "retweets" : 0,
                                                         "timestamp": Int(Date().timeIntervalSince1970)
            ], completion: { (error) in
                completion(error, ref)
        })
    }
    
    func fetchTweets(completion:@escaping([Tweet]) -> Void){
        
        db.collection("tweets").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                var tweets = [Tweet]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    guard let userId = data["userId"] as? String else { return }
                    
                    UserService.shared.fetchUserFromUid(userId: userId) { (user) in
                        let tweet = Tweet(data: data, user: user)
                        tweets.append(tweet)
                        completion(tweets)
                    }
                }
                
            }
        }
    }
}
