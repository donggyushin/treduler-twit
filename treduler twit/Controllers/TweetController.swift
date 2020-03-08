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


    }
    
    // MARK: - configures
    
    func configuration(){
        self.collectionView!.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: reuseHeaderIdentifier)
        
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func configureView(){
        collectionView.backgroundColor = .white
    }

}

extension TweetController {
    // MARK: UICollectionViewDataSource
    
       override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           // #warning Incomplete implementation, return the number of items
           return 0
       }

       override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
       
           // Configure the cell
       
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let textHeight = tweet.caption.height(withConstrainedWidth: view.frame.width - 40 , font: UIFont.systemFont(ofSize: 14))
        
        return CGSize(width: view.frame.width, height: textHeight + 210)
    }
}

extension TweetController:TweetHeaderDelegate {
    func goToReplyController(cell: TweetHeader) {
        guard let tweet = cell.tweet else { return }
        let replyVC = ReplyController(tweet: tweet)
        navigationController?.pushViewController(replyVC, animated: true)
    }
}
