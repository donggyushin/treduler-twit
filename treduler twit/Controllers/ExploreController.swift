
//
//  ExploreController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

private let reuseableIdentifer = "UserCell"

class ExploreController: UICollectionViewController {
    
    // MARK: - properties
    
    var users = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var searchedUsers = [User]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var searchMode:Bool {
        return search.isActive && !search.searchBar.text!.isEmpty
    }
    
    lazy var search = UISearchController(searchResultsController: nil)

    // MARK: - life cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: reuseableIdentifer)
        
        
        configNavigationBarUI()
        configureUi()
        fetchUsers()
        configureSearchBar()
    }
    
    // MARK: - API
    func fetchUsers(){
        UserService.shared.fetchAllUsers { users in
            self.users = users
        }
    }
    
    // MARK: - configure ui
    
    func configureSearchBar(){
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Search user"
        navigationItem.searchController = search
    }
    
    func configureUi(){
        collectionView.backgroundColor = .white
    }
    
    func configNavigationBarUI(){
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.systemBlue,
                              NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 20)
        ]


        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = "Explore"
        navigationController?.navigationBar.shadowImage = UIImage()
    }

}

    // MARK: - uicollectionview controller

extension ExploreController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchMode ? searchedUsers.count : users.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseableIdentifer, for: indexPath) as! UserCell
        let user = searchMode ? searchedUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension ExploreController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 65)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension ExploreController:UserCellDelegate {
    func goToProfileView(cell: UserCell) {
        guard let user = cell.user else { return }
        let profileVC = ProfileController(user: user)
        navigationController?.pushViewController(profileVC, animated: true)
    }
}

extension ExploreController:UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        self.searchedUsers = users.filter { (user) -> Bool in
            return user.username.lowercased().contains(text.lowercased()) || user.name.lowercased().contains(text.lowercased())
        }
        
    }
}
