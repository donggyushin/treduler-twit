//
//  TweetCell.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol TweetCellDelegate:class {
    func profileImageTapped(cell:TweetCell)
    func captionTapped(cell:TweetCell)
    func goToReplyController(cell:TweetCell)
    func presentAlert(title:String, message:String )
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - properties
    var tweet:Tweet? {
        didSet {
            configure()
            checkILikeThisTweet()
            fetchUser()
        }
    }
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    weak var delegate:TweetCellDelegate?
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 46).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 46).isActive = true
        iv.layer.cornerRadius = 23
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = ""
        return label
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.italicSystemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var timeLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var captionLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(captionTapped))
        label.addGestureRecognizer(tap)
        return label
    }()
    
    lazy var commentIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "comment")
        iv.tintColor = .black
        iv.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToReply))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var retweetIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "retweet")
        iv.tintColor = .black
        iv.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var heartIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "like_unselected")
        iv.tintColor = .black
        iv.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var shareIconImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "share")
        iv.tintColor = .black
        iv.widthAnchor.constraint(equalToConstant: 16).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 16).isActive = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var divider:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()
    // MARK: - life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - helpers
    
    
    
    func makeHeartRed(){
        
        self.heartIconImageView.image = #imageLiteral(resourceName: "like_filled")
        self.heartIconImageView.tintColor = .systemRed
        let tap = UITapGestureRecognizer(target: self, action: #selector(redHeartTapped))
        self.heartIconImageView.addGestureRecognizer(tap)
    }
    
    func makeHeartBlack(){
        self.heartIconImageView.image = #imageLiteral(resourceName: "like")
        self.heartIconImageView.tintColor = .black
        let tap = UITapGestureRecognizer(target: self, action: #selector(blackHeartTapped))
        self.heartIconImageView.addGestureRecognizer(tap)
    }
    
    func presenterAlert(title:String, message:String ){
        delegate?.presentAlert(title: title, message: message)
    }
   
    
    // MARK: - selectors
    
    @objc func redHeartTapped(){
        guard let tweetId = tweet?.id else { return }
        self.makeHeartBlack()
        self.heartIconImageView.isUserInteractionEnabled = false
        TweetService.shared.userUnlikeThisTweet(tweetId: tweetId) { (error) in
            if let error = error {
                self.presenterAlert(title: "Warning", message: error.localizedDescription)
                self.makeHeartRed()
            }else {
                self.heartIconImageView.isUserInteractionEnabled = true
            }
        }
    }
    
    @objc func blackHeartTapped(){
        guard let tweet = tweet else { return }
        self.makeHeartRed()
        self.heartIconImageView.isUserInteractionEnabled = false
        TweetService.shared.userLikeThisTweet(tweet: tweet) { (error) in
            if let error = error {
                self.presenterAlert(title: "Warning", message: error.localizedDescription)
                self.makeHeartBlack()
            }else {
                self.heartIconImageView.isUserInteractionEnabled = true
            }
        }
    }
    
    
    @objc func goToReply(){
        delegate?.goToReplyController(cell: self)
    }
    
    @objc func captionTapped(){
        delegate?.captionTapped(cell: self)
    }
    
    @objc func profileImageTapped(){
        delegate?.profileImageTapped(cell:self)
    }
    
    // MARK: - configure ui
    
    func checkILikeThisTweet(){
        
        guard let tweet = tweet else { return }
        TweetService.shared.checkILikeThisTweet(tweetId: tweet.id) { (bool) in
            bool ? self.makeHeartRed() : self.makeHeartBlack()
        }
    }
    
    
    func configure(){
           guard let tweet = self.tweet else { return }
           captionLabel.text = tweet.caption
           timeLabel.text = ". " + tweet.timestamp.getElapsedInterval()
           
    }
    func fetchUser(){
        guard let tweet = tweet else { return }
        UserService.shared.fetchUserFromUid(userId: tweet.userId) { (user) in
            self.user = user
        }
    }
    
    func configureUser(){
        guard let user = user else { return }
        nameLabel.text = user.name
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        
        usernameLabel.text = "@\(user.username)"
    }
    
    
    func configureUI(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        let userInfoStack = UIStackView(arrangedSubviews: [nameLabel, usernameLabel, timeLabel])
        userInfoStack.spacing = 4
        userInfoStack.axis = .horizontal
        addSubview(userInfoStack)
        userInfoStack.translatesAutoresizingMaskIntoConstraints = false
        userInfoStack.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        userInfoStack.topAnchor.constraint(equalTo: topAnchor, constant: 17).isActive = true
        
        addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 10).isActive = true
        captionLabel.topAnchor.constraint(equalTo: userInfoStack.bottomAnchor, constant: 3).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        let eventStackView = UIStackView(arrangedSubviews: [
            commentIconImageView,
            retweetIconImageView,
            heartIconImageView,
            shareIconImageView
        ])
        
        eventStackView.axis = .horizontal
        addSubview(eventStackView)
        eventStackView.translatesAutoresizingMaskIntoConstraints = false
        eventStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        eventStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        eventStackView.spacing = 72
    }
}
