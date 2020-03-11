//
//  TweetController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/08.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let reuseHeaderIdentifier = "TweetHeaderasd"

class TweetController: UICollectionViewController {
    private let tweet:Tweet
    
    private var retweets = [Tweet]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    lazy var refreshController:UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    
    
    
    // MARK: - Life cycles
    
    init(tweet:Tweet){
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        configureView()
        fetchRetweets()
        
    }
    
    // MARK: - selectors
    
    @objc func refresh(){
        fetchRetweets()
    }
    
    // MARK: - APIs
    
    
    func fetchRetweets(){
        TweetService.shared.fetchRetweets(tweet: tweet) { (tweets) in
            self.refreshController.endRefreshing()
            self.retweets = tweets
        }
    }
    
    
    // MARK: - configures
    
    func configuration(){
        self.collectionView!.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        self.collectionView!.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.refreshControl = refreshController
    }
    
    func configureView(){
        collectionView.backgroundColor = .white
    }
    
}

extension TweetController {
    // MARK: UICollectionViewDataSource
    
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of items
        return retweets.count
       }

       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
       
           // Configure the cell
            cell.tweet = retweets[indexPath.row]
            cell.delegate = self
           return cell
       }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseHeaderIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
    
}

extension TweetController:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tweet = retweets[indexPath.row]
        let caption = tweet.caption
        let height = caption.height(withConstrainedWidth: view.frame.width - 20 - 46 - 10 - 10, font: UIFont.systemFont(ofSize: 14))
        return CGSize(width: view.frame.width, height: height + 93)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let textHeight = tweet.caption.height(withConstrainedWidth: view.frame.width - 40 , font: UIFont.systemFont(ofSize: 14))
        
        return CGSize(width: view.frame.width, height: textHeight + 210)
    }
}

extension TweetController:TweetHeaderDelegate {
    
    func goToProfileVC(cell: TweetHeader) {
        guard let user = cell.user else { return }
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func goToLikeController(cell: TweetHeader) {
        guard let tweet = cell.tweet else { return }
        let likeVC = LikeController(tweet: tweet)
        navigationController?.pushViewController(likeVC, animated: true)
    }
    
    func presenterAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func goToReplyController(cell: TweetHeader) {
        guard let tweet = cell.tweet else { return }
        let replyVC = ReplyController(tweet:tweet, tweetVC: self)
        navigationController?.pushViewController(replyVC, animated: true)
    }
}




extension TweetController:TweetCellDelegate {
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: title, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
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
        let replyVC = ReplyController(tweet: tweet, tweetVC: self)
        navigationController?.pushViewController(replyVC, animated: true)
    }
    
    
}
