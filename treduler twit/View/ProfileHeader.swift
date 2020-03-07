//
//  ProfileHeader.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate:class {
    func navBackTapped()
}

class ProfileHeader: UICollectionViewCell {
    
    // MARK: - properties
    weak var delegate:ProfileHeaderDelegate?
    
    var user:User? {
        didSet {
            config()
        }
    }
    
    lazy var navigationBarView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainBlue
        return view
    }()
    
    lazy var backButtonImageView:UIButton = {
        let iv = UIButton(type: UIButton.ButtonType.system)
        let image = #imageLiteral(resourceName: "baseline_arrow_back_white_24dp")
        iv.setImage(image, for: .normal)
        iv.tintColor = .white
        iv.addTarget(self, action: #selector(navBackTapped), for: .touchUpInside)
        return iv
    }()
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: 80).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 80).isActive = true
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 40
        return iv
    }()
    
    lazy var editProfileButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("Loading", for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.mainBlue.cgColor
        button.layer.borderWidth = 1.8
        button.layer.cornerRadius = 18
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 36).isActive = true
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        return button
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        return label
    }()
    
    lazy var bioLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "I need some long text to check what it looks like if the text line over 2 lines."
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var followingNumberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "0"
        return label
    }()
    
    lazy var followingLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "following "
        return label
    }()
    lazy var followerNumberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "0"
        return label
    }()
    
    lazy var followerLabel:UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "following "
        return label
    }()
    
    lazy var divider:UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    
    // MARK: - life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - helper
    func config(){
        guard let user = self.user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        nameLabel.text = user.name
        usernameLabel.text = "@" + user.username
    }
    
    // MARK: - selectors
    
    @objc func navBackTapped(){
        delegate?.navBackTapped()
    }
    
    // MARK: configure ui
    func configure(){
        addSubview(navigationBarView)
        navigationBarView.translatesAutoresizingMaskIntoConstraints = false
        navigationBarView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        navigationBarView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        navigationBarView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        navigationBarView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(backButtonImageView)
        backButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        backButtonImageView.topAnchor.constraint(equalTo: navigationBarView.topAnchor, constant: 40).isActive = true
        backButtonImageView.leftAnchor.constraint(equalTo: navigationBarView.leftAnchor, constant: 15).isActive = true
        
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        profileImageView.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: -25).isActive = true
        
        addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: navigationBarView.bottomAnchor, constant: 10).isActive = true
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 4).isActive = true
        nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10).isActive = true
        
        addSubview(usernameLabel)
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 4).isActive = true
        usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4).isActive = true
        
        addSubview(bioLabel)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.leftAnchor.constraint(equalTo: profileImageView.leftAnchor, constant: 4).isActive = true
        bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4).isActive = true
        bioLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        let followStackView = UIStackView(arrangedSubviews: [followingNumberLabel, followingLabel, followerNumberLabel, followerLabel])
        followStackView.axis = .horizontal
        followStackView.spacing = 4
        addSubview(followStackView)
        followStackView.translatesAutoresizingMaskIntoConstraints = false
        followStackView.leftAnchor.constraint(equalTo: bioLabel.leftAnchor, constant: 0).isActive = true
        followStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 4).isActive = true
        
        
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
    }
}
