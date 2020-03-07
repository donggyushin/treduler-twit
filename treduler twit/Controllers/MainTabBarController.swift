//
//  MainTabBarController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    // MARK: - properties
    
    var user:User? {
        didSet {
            guard let nav = self.viewControllers?[0] as? UINavigationController else { return }
            guard let feedVC = nav.viewControllers.first as? FeedController else { return }
            feedVC.user = self.user!
        }
    }
    
    lazy var actionButton:UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.mainBlue
        button.imageView?.contentMode = .scaleAspectFit
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - life cycles

    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserLoggedIn()
    }
    
    // MARK: - helpers
    
    func checkUserLoggedIn() {
        if Auth.auth().currentUser == nil {
            self.view.backgroundColor = UIColor.mainBlue
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginController())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true, completion: nil)
            }
        }else {
            self.view.backgroundColor = UIColor.white
            configMainTabBarController()
            configureMainTabBarUI()
            UserService.shared.fetchUser { (user) in
                self.user = user
            }
        }
    }
    
    // MARK: - selectors
    @objc func actionButtonTapped(){
//        try! Auth.auth().signOut()
//        let loginVC = UINavigationController(rootViewController: LoginController())
//        loginVC.modalPresentationStyle = .fullScreen
//        self.present(loginVC, animated: true, completion: nil)
        guard let user = self.user else { return }
        let uploadTweetController = UINavigationController(rootViewController: UploadTweetController(user: user))
        uploadTweetController.modalPresentationStyle = .fullScreen
        present(uploadTweetController, animated: true, completion: nil)
        
    }
    
    
    // MARK: - configure
    
    func configureMainTabBarUI(){
        self.view.addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        actionButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        actionButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -65).isActive = true
        actionButton.layer.cornerRadius = 25
    }
    
    
    func configMainTabBarController(){
        let feedVC = UINavigationController(rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))
        let notificationVC = UINavigationController(rootViewController: NotificationController())
        let conversationVC = UINavigationController(rootViewController: ConversationController())
        let exploreVC = UINavigationController(rootViewController: ExploreController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        feedVC.navigationBar.barTintColor = .white
        notificationVC.navigationBar.barTintColor = .white
        conversationVC.navigationBar.barTintColor = .white
        exploreVC.navigationBar.barTintColor = .white
        
        feedVC.tabBarItem.image = UIImage(named: "home_unselected")
        notificationVC.tabBarItem.image = UIImage(named: "like_unselected")
        conversationVC.tabBarItem.image = UIImage(named: "comment")
        exploreVC.tabBarItem.image = UIImage(named: "search_unselected")
        
        self.viewControllers = [feedVC, exploreVC, notificationVC, conversationVC]
        
    }
    
}
