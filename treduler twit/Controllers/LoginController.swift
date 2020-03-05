//
//  LoginController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - properties
    
    lazy var logoLabelsContainer:UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var twitLogoLabel:UILabel = {
        let label = UILabel()
        label.text = "twit"
        label.font = UIFont.italicSystemFont(ofSize: 20)
        label.textColor = .white
        return label
    }()
    
    lazy var TredulerLogoLabel:UILabel = {
        let label = UILabel()
        
        let tredulerString = "treduler "
        let font = UIFont.italicSystemFont(ofSize: 40)
        let attributes = [NSAttributedString.Key.font: font]
        let attributedString = NSMutableAttributedString(string: tredulerString, attributes: attributes)
        
        label.attributedText = attributedString
        label.textColor = .white
        label.font = UIFont.italicSystemFont(ofSize: 40)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
    }
    
    // MARK: - configure ui
    
    func configUI(){
        view.backgroundColor = UIColor.mainBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(logoLabelsContainer)
        logoLabelsContainer.translatesAutoresizingMaskIntoConstraints = false
        logoLabelsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        logoLabelsContainer.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        logoLabelsContainer.heightAnchor.constraint(equalToConstant: 170).isActive = true
        
        view.addSubview(TredulerLogoLabel)
        TredulerLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        TredulerLogoLabel.centerXAnchor.constraint(equalTo: logoLabelsContainer.centerXAnchor).isActive = true
        TredulerLogoLabel.bottomAnchor.constraint(equalTo: logoLabelsContainer.bottomAnchor).isActive = true
        
        view.addSubview(twitLogoLabel)
        twitLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        twitLogoLabel.bottomAnchor.constraint(equalTo: logoLabelsContainer.bottomAnchor, constant: -6).isActive = true
        twitLogoLabel.leftAnchor.constraint(equalTo: TredulerLogoLabel.rightAnchor, constant: 6).isActive = true
    }
    
        
    

}
