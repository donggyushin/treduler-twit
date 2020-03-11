//
//  NotificationCell.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/11.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol NotificationCellDelegate:class {
    func goToProfile(cell:NotificationCell)
    func goToTweet(cell:NotificationCell)
}

class NotificationCell: UICollectionViewCell {
    
    var notification:Notification? {
        didSet {
            configureNotification()
            fetchUser()
        }
    }
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    weak var delegate:NotificationCellDelegate?
    
    // MARK: - properties
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 48).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 48).isActive = true
        iv.layer.cornerRadius = 24
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 15)
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    
    lazy var captionLabel:UILabel = {
        let caption = UILabel()
        caption.text = ""
        caption.font = UIFont.systemFont(ofSize: 14)
        caption.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(captionTapped))
        caption.addGestureRecognizer(tap)
        return caption
    }()
    
    // MARK: - life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - selectors
    @objc func profileImageTapped(){
        delegate?.goToProfile(cell: self)
    }
    
    @objc func captionTapped(){
        guard let notification = notification else { return }
        switch notification.type {
        case "LIKE":
            delegate?.goToTweet(cell: self)
        case "RETWEET":
            delegate?.goToTweet(cell: self)
        default:
            return
        }
        
    }
    
    // MARK: - APIs
    func fetchUser(){
        guard let notification = notification else { return }
        UserService.shared.fetchUserFromUid(userId: notification.from) { (user) in
            self.user = user
        }
    }
    
    // MARK: configures
    
    
    func configureNotification(){
        guard let notification = notification else { return }
        if notification.isRead {
            backgroundColor = .systemGroupedBackground
        }
        switch notification.type {
        case "LIKE":
            captionLabel.text = "liked your twit"
        case "RETWEET":
            captionLabel.text = "replied to your twit"
        case "FOLLOW":
            captionLabel.text = "started follow you"
        default:
            return
        }
    }
    
    func configureUser(){
        guard let user = user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        nameLabel.text = user.name
    }
    
    func configure(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        
        addSubview(captionLabel)
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 4).isActive = true
        
    }
}
