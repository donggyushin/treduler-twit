//
//  NotificationController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseableIdentifier = "Cell"

class NotificationController: UICollectionViewController {

    // MARK: - properties
    
    private var refreshControl = UIRefreshControl()
    
    var notifications = [Notification]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    // MARK: - life cycles
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        fetchNotifications()
        
    }
    
    // MARK: - APIs
    func fetchNotifications(){
        
        NotificationService.shared.fetchNotifications { (notifications) in
            self.refreshControl.endRefreshing()
            self.notifications = notifications
        }
    }
    
    // MARK: - selectors
    @objc func refresh(){
        fetchNotifications()
    }
    
    // MARK: - configures
    
    func configure(){
        configureNavigationBarUI()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.backgroundColor = .white
        collectionView.register(NotificationCell.self, forCellWithReuseIdentifier: reuseableIdentifier)
    }
    
    func configureNavigationBarUI(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,
                              NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Notification"
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}

// MARK: - collectionview delegate
extension NotificationController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableIdentifier, for: indexPath) as! NotificationCell
        
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - collection view flow layout delegate
extension NotificationController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


// MARK: - notification cell delegate
extension NotificationController:NotificationCellDelegate {
    
    func goToProfile(cell: NotificationCell) {
        guard let user = cell.user else { return }
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func goToTweet(cell: NotificationCell) {
        guard let tweetId = cell.notification?.tweetId else { return }
        TweetService.shared.fetchTweet(id: tweetId) { (tweet) in
            let tweetVC = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(tweetVC, animated: true)
        }
        
    }
    
}
