//
//  FeedController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedController: UIViewController {
    
    // MARK: - properties
    var user:User? {
        didSet {
            setUserProfileImage(profileUrl: self.user!.profileImageUrl)
        }
    }
    
    lazy var userProfileImageView:UIImageView = {
        let profileImageView = UIImageView()
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.layer.cornerRadius = 16
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        return profileImageView
    }()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBarUI()
    }
    
    // MARK: - Functions
    func setUserProfileImage(profileUrl:String){
        
        guard let url = URL(string: profileUrl) else { return }
        self.userProfileImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    
    // MARK: - Configure UI
    
    func configureNavigationBarUI(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,
                              NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "Treduler Twit"
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userProfileImageView)
    }

}
