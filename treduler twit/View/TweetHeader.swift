//
//  TweetHeader.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/08.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftDate

protocol TweetHeaderDelegate:class {
    func goToReplyController(cell:TweetHeader)
    
    func presenterAlert(title:String, message:String)
    
    func goToLikeController(cell:TweetHeader)
    
    func goToProfileVC(cell:TweetHeader)
    
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - properties
    
    weak var delegate:TweetHeaderDelegate?
    
    var tweet:Tweet? {
        didSet {
            configureTweet()
            checkILikeThisTweet()
            listenRetweetNumbers()
            fetchUser()
        }
    }
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        
        return label
    }()
    
    lazy var actionButton:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.image = #imageLiteral(resourceName: "down_arrow_24pt")
        iv.tintColor = .gray
        return iv
    }()
    
    lazy var captionLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var dateLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var retweetNumber = 0
    
    lazy var likeNumber = 0
    
    lazy var retweetNumberLabel:UILabel = {
        let label = UILabel()
        label.text = "\(self.retweetNumber)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var likeNumberLabel:UILabel = {
        let label = UILabel()
        label.text = "\(self.likeNumber)"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    lazy var retweetLabel:UILabel = {
        let label = UILabel()
        label.text = "retweets"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        return label
    }()
    
    lazy var likeLabel:UILabel = {
        let label = UILabel()
        label.text = "likes"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeLabelTapped))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var divider:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    
    lazy var commentButton:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "comment")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToReplyController))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var cycleButton:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "retweet")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var likeButton:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "like")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var shareButton:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "share")
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFit
        iv.widthAnchor.constraint(equalToConstant: 20).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 20).isActive = true
        return iv
    }()
    
    
    // MARK: - Life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Apis
    
    func fetchUser(){
        guard let tweet = tweet else { return }
        UserService.shared.fetchUserFromUid(userId: tweet.userId) { (user) in
            self.user = user
        }
    }
    
    
    // MARK: - helpers
    
    func checkILikeThisTweet(){
        guard let tweet = self.tweet else { return }
        TweetService.shared.checkILikeThisTweet(tweetId: tweet.id) { (bool) in
            if bool {
                self.likeButton.image = #imageLiteral(resourceName: "like_filled")
                self.likeButton.tintColor = .systemRed
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.colorfulHeartTapped))
                self.likeButton.addGestureRecognizer(tap)
                self.likeButton.isUserInteractionEnabled = true
            }else {
                self.likeButton.image = #imageLiteral(resourceName: "like")
                self.likeButton.tintColor = .black
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.emptyHeartTapped))
                self.likeButton.addGestureRecognizer(tap)
                self.likeButton.isUserInteractionEnabled = true
            }
        }
    }
    
    func presentAlert(title:String, message:String){
        delegate?.presenterAlert(title: title, message: message)
    }
    
    
    // MARK: - selectors
    
    @objc func profileImageTapped(){
        delegate?.goToProfileVC(cell: self)
    }
    
    @objc func likeLabelTapped(){
        delegate?.goToLikeController(cell: self)
    }
    
    @objc func emptyHeartTapped(){
        guard let tweet = self.tweet else { return }
        self.likeButton.isUserInteractionEnabled = false
        self.likeButton.image = #imageLiteral(resourceName: "like_filled")
        self.likeButton.tintColor = .systemRed
        TweetService.shared.userLikeThisTweet(tweet: tweet) { (error) in
            if let error = error {
                self.presentAlert(title: "Warning", message: error.localizedDescription)
                self.likeButton.isUserInteractionEnabled = true
                self.likeButton.image = #imageLiteral(resourceName: "like")
                self.likeButton.tintColor = .black
            }else {
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.colorfulHeartTapped))
                self.likeButton.addGestureRecognizer(tap)
                self.likeButton.isUserInteractionEnabled = true
            }
        }
        
    }
    
    @objc func colorfulHeartTapped(){
        guard let tweet = self.tweet else { return }
        self.likeButton.isUserInteractionEnabled = false
        self.likeButton.image = #imageLiteral(resourceName: "like")
        self.likeButton.tintColor = .black
        TweetService.shared.userUnlikeThisTweet(tweetId: tweet.id) { (error) in
            if let error = error {
                self.presentAlert(title: "Warning", message: error.localizedDescription)
                self.likeButton.isUserInteractionEnabled = true
                self.likeButton.image = #imageLiteral(resourceName: "like_filled")
                self.likeButton.tintColor = .systemRed
            }else {
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.emptyHeartTapped))
                self.likeButton.addGestureRecognizer(tap)
                self.likeButton.isUserInteractionEnabled = true
            }
        }
        
        self.likeButton.image = #imageLiteral(resourceName: "like")
        self.likeButton.tintColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(emptyHeartTapped))
        self.likeButton.addGestureRecognizer(tap)
    }
    
    @objc func goToReplyController(){
        delegate?.goToReplyController(cell: self)
    }
    
    // MARK: - configures
    
    func configureUser(){
        guard let user = user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
    }
    
    
    
    func configureTweet(){
        guard let tweet = tweet else { return }
        
        captionLabel.text = tweet.caption
        dateLabel.text = tweet.timestamp.toFormat("dd MMM yyyy 'at' HH:mm")
        self.retweetNumberLabel.text = "\(tweet.replieTweets.count)"

    }
    
    
    func listenRetweetNumbers(){
        guard let tweet = tweet else { return }
        TweetService.shared.listenTweetLikesAndRetweetsNumber(tweetId: tweet.id) { (likeNumber, retweetNumber) in
            self.retweetNumber = retweetNumber
            self.likeNumber = likeNumber
            self.retweetNumberLabel.text = "\(self.retweetNumber)"
            self.likeNumberLabel.text = "\(self.likeNumber)"
        }
    }
    
    func configUI(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        addSubview(actionButton)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        actionButton.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        
        
        addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        captionLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 20).isActive = true
        
        addSubview(retweetNumberLabel)
        retweetNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        retweetNumberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        retweetNumberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        
        addSubview(retweetLabel)
        retweetLabel.translatesAutoresizingMaskIntoConstraints = false
        retweetLabel.leftAnchor.constraint(equalTo: retweetNumberLabel.rightAnchor, constant: 4).isActive = true
        retweetLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        
        addSubview(likeNumberLabel)
        likeNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        likeNumberLabel.leftAnchor.constraint(equalTo: retweetLabel.rightAnchor, constant: 6).isActive = true
        likeNumberLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        
        addSubview(likeLabel)
        likeLabel.translatesAutoresizingMaskIntoConstraints = false
        likeLabel.leftAnchor.constraint(equalTo: likeNumberLabel.rightAnchor, constant: 6).isActive = true
        likeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: leftAnchor, constant: 0).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let actionButtonStackView = UIStackView(arrangedSubviews: [commentButton, cycleButton, likeButton, shareButton])
        actionButtonStackView.axis = .horizontal
        actionButtonStackView.alignment = .center
        actionButtonStackView.distribution = .fillEqually
        addSubview(actionButtonStackView)
        actionButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        actionButtonStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        actionButtonStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        actionButtonStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        actionButtonStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
}
