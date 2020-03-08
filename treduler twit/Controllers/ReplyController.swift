//
//  ReplyController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/08.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class ReplyController: UIViewController {

    // MARK: - properties
    private let tweet:Tweet
    
    //MARK: - life cycles
    
    init(tweet:Tweet) {
        self.tweet = tweet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNav()
    }
    
    // MARK: - selectors
    @objc func rightBarButtonItemTapped(){
        print("right bar button tapped")
    }
    
    // MARK: configures
    
    func configureUI(){
        view.backgroundColor = .white
    }
    
    func configureNav(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(rightBarButtonItemTapped))
    }
    
}
