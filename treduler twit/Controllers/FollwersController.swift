//
//  FollwersController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/08.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FollwersController: UICollectionViewController {
    
    // MARK: - properties
    
    private let user:User
    
    private var followers = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Life cycles
    
    init(user:User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBarUI()
        collectionView.backgroundColor = .white
        self.collectionView!.register(UserCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        fetchFollwers()

    }
    
    // MARK: - APIs
    
    func fetchFollwers(){
        UserService.shared.fetchFollwers(user: self.user) { users in
            self.followers = users
        }
    }
    
    // MARK: - configures
    
    func configNavigationBarUI(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,
                              NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)
        ]


        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Followers"
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}

extension FollwersController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return followers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCell
    
        cell.user = followers[indexPath.row]
        cell.delegate = self
        
        return cell
    }
}

extension FollwersController:UICollectionViewDelegateFlowLayout {
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension FollwersController:UserCellDelegate {
    func goToProfileView(cell: UserCell) {
        guard let user = cell.user else { return }
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}
