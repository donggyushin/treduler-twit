//
//  UploadTweetController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

class UploadTweetController: UIViewController {
    
    let db = Firestore.firestore()
    
    let user:User
    

    // MARK: - properties
    
    lazy var loadingIndicator:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return loading
    }()
    
    lazy var uploadTweetButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Twit", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 64).isActive = true
        button.heightAnchor.constraint(equalToConstant: 28).isActive = true
        button.backgroundColor = UIColor.mainBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.addTarget(self, action: #selector(navigationRightBarButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        if let url = URL(string: self.user.profileImageUrl) {
            iv.sd_setImage(with: url, completed: nil)
        }
        
        return iv
    }()
    
    let captionTextView = CaptionTextView()
    
    // MARK: - initializers
    
    init(user:User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
    }
    
    // MARK: - helpers
    
    func presenterAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Selectors
    @objc func navigationLeftBarButtonTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func navigationRightBarButtonTapped(){
        
        self.loadingIndicator.startAnimating()
        self.uploadTweetButton.isEnabled = false
        
        guard let caption = self.captionTextView.text else {
            self.loadingIndicator.stopAnimating()
            self.uploadTweetButton.isEnabled = true
            return
            
        }
        if caption.isEmpty {
            self.presenterAlert(title: "Warning", message: "Please write caption ^__^")
            self.loadingIndicator.stopAnimating()
            self.uploadTweetButton.isEnabled = true
        }else {
            TweetService.shared.postTweet(caption: caption) { (tweet) in
                
                    if let rootVC = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                        .filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController {
                        if let nav = rootVC.viewControllers?[0] as? UINavigationController {
                            
                            if let profileVC = nav.viewControllers.last as? ProfileController {
                                profileVC.tweets.insert(tweet, at: 0)
                            }
                            
                            guard let feedVC = nav.viewControllers.first as? FeedController else { return }
                            feedVC.callFetchTweets()
                            
                            
                        }
                    }
                    self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    // MARK: - configure ui
    
    func configureUi(){
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(navigationLeftBarButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: uploadTweetButton)
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.layer.cornerRadius = 24
        
        view.addSubview(captionTextView)
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionTextView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 16).isActive = true
        captionTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        captionTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        captionTextView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
}
