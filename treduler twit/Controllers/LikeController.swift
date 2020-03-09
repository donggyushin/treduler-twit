//
//  LikeController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/09.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class LikeController: UICollectionViewController {
    
    // MARK: - properties
    
    private let tweet:Tweet
    
    private var users = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - Life cycles
    
    init(tweet:Tweet) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: APIs
    func fetchUsers(){
        UserService.shared.fetchUsersWhoLikedThisTweet(tweet: tweet) { (users) in
            self.users = users
        }
    }
    
    // MARK: configures
    
    func configureNavigationBarUI(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,
                              NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.title = "Likes"
        
        
        collectionView.backgroundColor = .white
    }
    
    func configure(){
        fetchUsers()
        configureNavigationBarUI()
        self.collectionView!.register(UserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.backgroundColor = .white
    }
    

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.users.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCell
    
        // Configure the cell
        cell.user = users[indexPath.row]
        cell.delegate = self
    
        return cell
    }

}

extension LikeController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension LikeController:UserCellDelegate {
    func goToProfileView(cell: UserCell) {
        guard let user = cell.user else { return }
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
