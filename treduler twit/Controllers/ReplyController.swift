//
//  ReplyController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/08.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

class ReplyController: UIViewController {

    // MARK: - properties
    private let tweet:Tweet
    
    var tweetVC:TweetController?
    
    private var writer:User? {
        didSet {
            configureUser()
        }
    }
    
    private var me:User? {
        didSet {
            configureMe()
        }
    }
    
    lazy var replyingLabel:UILabel = {
        let label = UILabel()
        label.text = "Replying to"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var replyingUsername:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .systemBlue
        label.font = UIFont.italicSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var myProfileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 24
        return iv
    }()
    
    lazy var textView:UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = true
        tv.font = UIFont.systemFont(ofSize: 15)
        
        tv.addSubview(textViewPlaceholder)
        textViewPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        textViewPlaceholder.topAnchor.constraint(equalTo: tv.topAnchor, constant: 8).isActive = true
        textViewPlaceholder.leftAnchor.constraint(equalTo: tv.leftAnchor, constant: 4).isActive = true
        
        return tv
    }()
    
    lazy var textViewPlaceholder:UILabel = {
        let label = UILabel()
        label.text = "What's happening?"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var loadingIndicator:UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView(style: .large)
        return loading
    }()
    
    
    //MARK: - life cycles
    
    init(tweet:Tweet, tweetVC:TweetController?) {
        self.tweet = tweet
        self.tweetVC = tweetVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNav()
        fetchMe()
    }
    
    // MARK: - helpers
    
    func presentAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - selectors
    @objc func rightBarButtonItemTapped(){
        guard let caption = self.textView.text else { return }
        self.loadingIndicator.startAnimating()
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        TweetService.shared.replyTweet(caption: caption, parentTweet: tweet) { (error) in
            if let error = error {
                self.presentAlert(title: "Warning", message: error.localizedDescription)
                self.loadingIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }else {
                self.loadingIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.tweetVC?.fetchRetweets()
                
                if let rootVC = UIApplication.shared.connectedScenes
                                    .filter({$0.activationState == .foregroundActive})
                                    .map({$0 as? UIWindowScene})
                                    .compactMap({$0})
                                    .first?.windows
                                        .filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController {
                                        if let nav = rootVC.viewControllers?[0] as? UINavigationController {
                                            guard let feedVC = nav.viewControllers.first as? FeedController else { return }
                                            feedVC.callFetchTweets()
                                        }
                                    }
                
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
    
    // MARK: configures
    
    func configureUI(){
        view.backgroundColor = .white
        textView.delegate = self
        
        view.addSubview(replyingLabel)
        replyingLabel.translatesAutoresizingMaskIntoConstraints = false
        replyingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        replyingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 14).isActive = true
        
        view.addSubview(replyingUsername)
        replyingUsername.translatesAutoresizingMaskIntoConstraints = false
        replyingUsername.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        replyingUsername.leftAnchor.constraint(equalTo: replyingLabel.rightAnchor, constant: 8).isActive = true
        
        view.addSubview(myProfileImageView)
        myProfileImageView.translatesAutoresizingMaskIntoConstraints = false
        myProfileImageView.topAnchor.constraint(equalTo: replyingLabel.bottomAnchor, constant: 10).isActive = true
        myProfileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: replyingLabel.bottomAnchor, constant: 10).isActive = true
        textView.leftAnchor.constraint(equalTo: myProfileImageView.rightAnchor, constant: 10).isActive = true
        textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
    
    func configureMe(){
        guard let user = self.me else { return }
        if let url = URL(string: user.profileImageUrl) {
            myProfileImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    func fetchMe(){
        UserService.shared.fetchUser { (user) in
            self.me = user
        }
    }
    
    
    func configureUser(){
        guard let writer = self.writer else { return }
        self.replyingUsername.text = "@" + writer.username
    }
    
    func configureNav(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(rightBarButtonItemTapped))
    }
    
}

extension ReplyController:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        self.textViewPlaceholder.isHidden = !textView.text.isEmpty
    }
    
}
