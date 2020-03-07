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
    
    func postTweet(caption:String, completion:@escaping(Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var ref:DocumentReference?
        ref = db.collection("tweets").addDocument(data: ["userId": uid, "caption":caption, "likes": 0, "retweets" : 0,
                                                         "timestamp": Int(Date().timeIntervalSince1970)
            ], completion: { (error) in
                guard error == nil else { return }
                
                
                
                self.db.collection("tweets").document(ref!.documentID).updateData(["id" : ref!.documentID], completion: completion)
                self.db.collection("tweets").document(ref!.documentID).updateData(["id" : ref!.documentID])
                self.db.collection("users").document(uid).updateData(["tweetIds" : FieldValue.arrayUnion([ref!.documentID])])
        })
    }
    
    func fetchTweets(user:User, completion:@escaping([Tweet]) -> Void) {
        db.collection("users").document(user.uid).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let tweetIds = data["tweetIds"] as? [String] ?? []
                var tweets = [Tweet]()
                for tweetId in tweetIds {
                    self.db.collection("tweets").document(tweetId).getDocument { (querySnapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            guard let data = querySnapshot!.data() else { return }
                            let tweet = Tweet(data: data, user: user)
                            tweets.append(tweet)
                            completion(tweets)
                        }
                    }
                }
                
            }
        }
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
