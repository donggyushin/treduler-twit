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
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - properties
    
    weak var delegate:TweetHeaderDelegate?
    
    var tweet:Tweet? {
        didSet {
            configureTweet()
        }
    }
    
    private var user:User? {
        didSet {
            configureUser()
            listenRetweetNumbers()
        }
    }
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
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
    
    // MARK: - selectors
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
        
        UserService.shared.fetchUserFromUid(userId: tweet.userId) { (user) in
            self.user = user
        }
    }
    
    func listenRetweetNumbers(){
        guard let tweet = tweet else { return }
        guard let user = user else { return }
        TweetService.shared.fetchTweet(id: tweet.id, writer: user) { (tweet) in
            DispatchQueue.main.async {
                self.retweetNumber = tweet.replieTweets.count
                self.retweetNumberLabel.text = "\(self.retweetNumber)"
            }
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
