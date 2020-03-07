//
//  UserCell.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/08.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol UserCellDelegate:class {
    func goToProfileView(cell:UserCell)
}

class UserCell: UICollectionViewCell {
    
    // MARK: properties
    
    weak var delegate:UserCellDelegate?
    
    var user:User? {
        didSet {
            configureUser()
        }
    }
    
    lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 40).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfileView))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    lazy var usernameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.boldSystemFont(ofSize: 14)
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfileView))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var nameLabel:UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(goToProfileView))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    // MARK: -  Life cycles
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUi()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - selectors
    
    @objc func goToProfileView(){
        delegate?.goToProfileView(cell: self)
    }
    
    
    // MARK: - configure
    
    func configureUser(){
        guard let user = self.user else { return }
        if let url = URL(string: user.profileImageUrl) {
            profileImageView.sd_setImage(with: url, completed: nil)
        }
        usernameLabel.text = user.username
        nameLabel.text = user.name
    }
    
    func configureUi(){
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 9).isActive = true
        
        let nameStackView = UIStackView(arrangedSubviews: [usernameLabel, nameLabel])
        nameStackView.axis = .vertical
        addSubview(nameStackView)
        nameStackView.translatesAutoresizingMaskIntoConstraints = false
        nameStackView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        nameStackView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    }
}
