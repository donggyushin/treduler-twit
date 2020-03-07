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

private let reuseIdenrifierForTweetCell = "tweetCell"

class FeedController: UICollectionViewController {
    
    // MARK: - properties
    private var tweets = [Tweet]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
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
        collectionView.alwaysBounceVertical = true
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdenrifierForTweetCell)
        
        configureNavigationBarUI()
        callFetchTweets()
    }
    
    // MARK: - Functions
    func setUserProfileImage(profileUrl:String){
        
        guard let url = URL(string: profileUrl) else { return }
        self.userProfileImageView.sd_setImage(with: url, completed: nil)
        
    }
    
    func callFetchTweets(){
        TweetService.shared.fetchTweets { (tweets) in
            self.tweets = tweets
        }
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
        
        collectionView.backgroundColor = .white
    }

}

// MARK: - UICollectionView Delegate Methods

extension FeedController {
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdenrifierForTweetCell, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

extension FeedController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = tweets[indexPath.row]
        let caption = tweet.caption
        let height = caption.height(withConstrainedWidth: view.frame.width - 20 - 46 - 10 - 10, font: UIFont.systemFont(ofSize: 14))
        return CGSize(width: view.frame.width, height: height + 93)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
