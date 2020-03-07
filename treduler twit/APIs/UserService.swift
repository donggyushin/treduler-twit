//
//  UserService.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import Foundation
import Firebase
struct UserService {
    static let shared = UserService()
    let db = Firestore.firestore()
    
    func fetchFollowings(user:User, completion:@escaping([User]) -> Void) {
        db.collection("users").document(user.uid).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let followings = data["following"] as? [String] ?? []
                var users = [User]()
                for following in followings {
                    self.db.collection("users").document(following).getDocument { (querySnapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            guard let data = querySnapshot!.data() else { return }
                            let user = User(data: data)
                            users.append(user)
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    func fetchFollwers(user:User, completion:@escaping([User]) -> Void){
        db.collection("users").document(user.uid).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let followers = data["followers"] as? [String] ?? []
                var users = [User]()
                for follower in followers {
                    self.db.collection("users").document(follower).getDocument { (querySnapshot, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            let user = User(data: data)
                            users.append(user)
                            completion(users)
                        }
                    }
                }
            }
        }
    }
    
    func fetchFollowingAndFollowerNumbers(user:User, completion:@escaping(_ followingNumber:Int, _ followersNumber:Int) -> Void){
        db.collection("users").document(user.uid).addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let following = data["following"] as? [String] ?? []
                let followers = data["followers"] as? [String] ?? []
                completion(following.count, followers.count)
            }
        }
    }
    
    
    func checkIFollowThisUserOrNot(user:User, completion:@escaping(Bool) -> Void){
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUid).getDocument { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = querySnapshot!.data() else { return }
                let following = data["following"] as? [String] ?? []
                for item in following {
                    if item == user.uid {
                        completion(true)
                        return
                    }
                }
                completion(false)
            }
        }
    }
    
    func unfollowUser(user:User, completion:@escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).updateData(["following": FieldValue.arrayRemove([user.uid])]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.db.collection("users").document(user.uid).updateData(["followers" : FieldValue.arrayRemove([uid])], completion: completion)
            }
        }
    }
    
    func followUser(user:User, completion:@escaping(Error?) -> Void){
        guard let myUid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(myUid).updateData([
            "following": FieldValue.arrayUnion([user.uid])
        ]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.db.collection("users").document(user.uid).updateData(["followers":FieldValue.arrayUnion([myUid])], completion: completion)
            }
        }
    }
    
    func newUser(email:String, password:String, username:String, name:String, profileImageUrlString:String, uid:String, completion:@escaping(Error?) -> Void ){
        
        db.collection("users").document(uid).setData([
        "email": email,
        "password": password,
        "username": username,
        "name": name,
        "profileImageUrlString":profileImageUrlString,
        "uid": uid
        ], completion: completion)
        
    }
    
    func fetchAllUsers(completion:@escaping([User]) -> Void){
        db.collection("users").addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                var users = [User]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let user = User(data: data)
                    users.append(user)
                }
                completion(users)
            }
        }
    }
    
    func fetchUser(completion:@escaping(_ user:User) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = documentSnapshot!.data() else { return }
                let user = User(data: data)
                completion(user)
            }
        }
        
    }
    
    func fetchUserFromUid(userId:String, completion:@escaping(User) -> Void){
        db.collection("users").document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = snapshot!.data() else { return }
                let user = User(data: data)
                completion(user)
            }
        }
    }
    
}
