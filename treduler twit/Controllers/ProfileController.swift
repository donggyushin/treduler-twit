//
//  ProfileController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/07.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let headerIdentifier = "header"

class ProfileController: UICollectionViewController {
    
    // MARK: - properties
    
    private let user:User
    var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()        }
    }
    
    lazy var refreshController:UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    
    
    
    // MARK: - life cycle
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = false
        collectionView.backgroundColor = .white
        
//        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.contentInset.top = -(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.safeAreaInsets.top ?? 0)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshController
        fetchTweets()
    }
    
    
    // MARK: - selectors
    @objc func refresh(){
        fetchTweets()
    }
    
    // MARK: - API
    func fetchTweets(){
        TweetService.shared.fetchTweets(user: self.user) { tweets in
            self.refreshController.endRefreshing()
            self.tweets = tweets
        }
    }
    
    
}
// MARK: - collectionview delegate
extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.delegate = self
        header.user = self.user
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    
}

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
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


extension ProfileController:ProfileHeaderDelegate {
    
    func goToFollowing(cell: ProfileHeader) {
        guard let user = cell.user else { return }
        let followingVC = FollowingController(user: user)
        navigationController?.pushViewController(followingVC, animated: true)
    }
    
    func goToFollowers(cell: ProfileHeader) {
        guard let user = cell.user else { return }
        let followersVC = FollwersController(user: user)
        navigationController?.pushViewController(followersVC, animated: true)
    }
    
    func presenterAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func navBackTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension ProfileController:TweetCellDelegate {
    func profileImageTapped(cell: TweetCell) {
        guard let user = cell.user else { return }
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func captionTapped(cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let tweetVC = TweetController(tweet: tweet)
        navigationController?.pushViewController(tweetVC, animated: true)
    }
    
    func goToReplyController(cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let replyVC = ReplyController(tweet: tweet, tweetVC: nil)
        navigationController?.pushViewController(replyVC, animated: true)
    }
    
    func presentAlert(title: String, message: String) {
        presenterAlert(title: title, message: message)
    }
    
    
}
