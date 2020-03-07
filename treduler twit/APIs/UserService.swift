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
    func fetchUser(completion:@escaping(_ user:User) -> Void){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("users").document(uid).getDocument { (snapshor, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                guard let data = snapshor!.data() else { return }
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
