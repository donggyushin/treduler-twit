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
   
    
    func checkILikeThisTweet(tweetId:String, completion:@escaping(Bool) -> Void){
        guard let userid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(userid).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let user = User(data: data)
                for tweetIdThisUserLike in user.tweetsILiked {
                    if tweetIdThisUserLike == tweetId {
                        completion(true)
                        return
                    }
                }
                completion(false)
            }
        }
    }
    
    func userUnlikeThisTweet(tweetId:String, completion:@escaping(Error?) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        db.collection("tweets").document(tweetId).updateData([
            "likeUsers": FieldValue.arrayRemove([userId])
        ]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.db.collection("users").document(userId).updateData([
                    "tweetsILiked":FieldValue.arrayRemove([tweetId])
                ], completion: completion)
                
            }
        }
    }
    
    func userLikeThisTweet(tweet:Tweet, completion:@escaping(Error?) -> Void){
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        
        // 먼저 해당 트위터에 좋아요를 누른 사람중에 본인이 있는지 없는지 확인한다. 본인이 있을 경우에는 에러없이 그냥 리턴
        db.collection("tweets").document(tweet.id).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                let data = querySnapshot!.data()!
                let likeUsers = data["likeUsers"] as? [String] ?? []
                for likeUser in likeUsers {
                    if likeUser == userId {
                        return completion(nil)
                    }
                }
                // Start liking tweet
                self.db.collection("tweets").document(tweet.id).updateData([
                    "likeUsers":FieldValue.arrayUnion([userId])
                ]) { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }else {
                        self.db.collection("users").document(userId).updateData([
                            "tweetsILiked": FieldValue.arrayUnion([tweet.id])
                        ], completion: completion)
                        
                        
                        if userId != tweet.userId {
                            // Start add notification
                            var ref:DocumentReference?
                            ref = self.db.collection("notifications").addDocument(data: [
                                "from":userId,
                                "tweetId":tweet.id,
                                "to":tweet.userId,
                                "type":"LIKE",
                                "isRead":false
                            ]) { (error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }else {
                                    self.db.collection("notifications").document(ref!.documentID).updateData(["id" : ref!.documentID])
                                    self.db.collection("users").document(tweet.userId).updateData(["notifications" :
                                        FieldValue.arrayUnion([ref!.documentID])
                                    ])
                                }
                            } // End notification
                        }
                        
                        
                    }
                }   // End liking tweet
                
                
            }
        }
        
        
        
        
        
        
    }
    
    func listenTweetLikesAndRetweetsNumber(tweetId:String, completion:@escaping(Int, Int) -> Void){
        db.collection("tweets").document(tweetId).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let likeUsers = data["likeUsers"] as? [String] ?? []
                let replieTweets = data["replieTweets"] as? [String] ?? []
                completion(likeUsers.count, replieTweets.count)
            }
        }
    }
    
    func fetchRetweets(tweet:Tweet, completion:@escaping([Tweet]) -> Void){
   
        db.collection("tweets").document(tweet.id).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let replieTweets = data["replieTweets"] as? [String] ?? []
                var tweets = [Tweet]()
                for tweetId in replieTweets {
                    self.db.collection("tweets").document(tweetId).getDocument { (querySnapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            guard let data = querySnapshot!.data() else { return }
                            let tweet = Tweet(data: data, id: tweetId)
                            tweets.append(tweet)
                            completion(tweets)
                        }
                    }
                }
            }
        }
      
    }
    
    func fetchTweet(id:String, completion:@escaping(Tweet) -> Void) {
        
        db.collection("tweets").document(id).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let tweet = Tweet(data: data, id: querySnapshot!.documentID )
                completion(tweet)
            }
            }
    }
    
    func replyTweet(caption:String, parentTweet:Tweet, completion:@escaping(Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var ref:DocumentReference?
        ref = db.collection("tweets").addDocument(data: [
            "userId": uid, "caption": caption,
            "likes": 0, "retweets": 0,
            "timestamp" : Int(Date().timeIntervalSince1970),
            "parentTweetId": parentTweet.id
        ]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let id = ref?.documentID else { return }
                self.db.collection("tweets").document(id).updateData(["id":id], completion: completion)
                self.db.collection("tweets").document(parentTweet.id).updateData([
                    "replieTweets":FieldValue.arrayUnion([id])
                ])
                
                self.db.collection("users").document(uid).updateData([
                    "tweetIds": FieldValue.arrayUnion([id])
                ])
                
                
                // new notification
                if uid != parentTweet.userId {
                    var notificationRef:DocumentReference?
                    notificationRef = self.db.collection("notifications").addDocument(data: [
                    "from" : uid,
                    "isRead": false,
                    "to": parentTweet.userId,
                    "tweetId": parentTweet.id,
                    "type": "RETWEET"
                    ]) { (error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            self.db.collection("notifications").document(notificationRef!.documentID).updateData(["id":notificationRef!.documentID])
                            self.db.collection("users").document(parentTweet.userId).updateData(["notifications" : FieldValue.arrayUnion([notificationRef!.documentID])])
                        }
                    }
                }
            }
        }
    }
    
    func postTweet(caption:String, completion:@escaping(Tweet) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var ref:DocumentReference?
        ref = db.collection("tweets").addDocument(data: ["userId": uid, "caption":caption, "likes": 0, "retweets" : 0,
                                                         "timestamp": Int(Date().timeIntervalSince1970)
            ], completion: { (error) in
                guard error == nil else { return }
                
                
                self.db.collection("tweets").document(ref!.documentID).getDocument { (querySnapshot, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }else {
                        guard let data = querySnapshot!.data() else { return }
                        let tweet = Tweet(data: data, id: ref!.documentID)
                        completion(tweet)
                    }
                }
                
                self.db.collection("users").document(uid).updateData(["tweetIds" : FieldValue.arrayUnion([ref!.documentID])])
        })
    }
    
    func fetchTweets(user:User, completion:@escaping([Tweet]) -> Void) {
        
        db.collection("users").document(user.uid).getDocument { (querySnapshot, error) in
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
                            let tweet = Tweet(data: data, id:querySnapshot!.documentID)
                            tweets.append(tweet)
                            tweets.reverse()
                            completion(tweets)
                        }
                    }
                }
            }
        }
    }
    
    func fetchTweets(completion:@escaping([Tweet]) -> Void){
        
        db.collection("tweets").order(by: "timestamp", descending: true).getDocuments { (querySnapshor, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                var tweets = [Tweet]()
                for document in querySnapshor!.documents {
                    let data = document.data()
                    let tweet = Tweet(data: data, id: document.documentID)
                    tweets.append(tweet)
                }
                completion(tweets)
            }
        }
        
    }
}
