//
//  SignUpController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    // MARK: - properties
    
    lazy var logoLabelsContainer:UIView = {
        let view = UIView()
        
        return view
    }()
    
    lazy var twitlogoImageView:UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "TwitterLogo")
        iv.widthAnchor.constraint(equalToConstant: 25).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 25).isActive = true
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
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
    
    private lazy var emailTextFieldContainer:UIView = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "ic_mail_outline_white_2x-1")
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "email@gmail.com",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.tintColor = .white
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.autocapitalizationType = .none
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .white
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        
        return view
    }()
    
    private lazy var usernameTextFieldContainer:UIView = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 3).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "User name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.tintColor = .white
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.autocapitalizationType = .none
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .white
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        
        return view
    }()
    
    private lazy var nameTextFieldContainer:UIView = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 3).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.tintColor = .white
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.autocapitalizationType = .none
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .white
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        
        return view
    }()
    
    private lazy var passwordTextFieldContainer:UIView = {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 3).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        let textField = UITextField()
        textField.attributedPlaceholder = NSAttributedString(string: "password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textField.isSecureTextEntry = true
        textField.tintColor = .white
        textField.backgroundColor = .clear
        textField.autocapitalizationType = .none
        textField.textColor = .white
        view.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        textField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        let divider = UIView()
        divider.backgroundColor = .white
        view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        divider.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        divider.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        
        return view
    }()
    
    private lazy var signupButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .white
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    private lazy var signupLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Already have an account?"
        
        return label
    }()
    
    private lazy var SignUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(goToLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configUI()
    }
    
    // MARK: - helper
    
    @objc func goToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: configure ui

    func configUI(){
        view.backgroundColor = UIColor.mainBlue
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.title = "Login"
        
        view.addSubview(logoLabelsContainer)
        logoLabelsContainer.translatesAutoresizingMaskIntoConstraints = false
        logoLabelsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        logoLabelsContainer.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        logoLabelsContainer.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        view.addSubview(TredulerLogoLabel)
        TredulerLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        TredulerLogoLabel.centerXAnchor.constraint(equalTo: logoLabelsContainer.centerXAnchor).isActive = true
        TredulerLogoLabel.bottomAnchor.constraint(equalTo: logoLabelsContainer.bottomAnchor).isActive = true
        
        view.addSubview(twitLogoLabel)
        twitLogoLabel.translatesAutoresizingMaskIntoConstraints = false
        twitLogoLabel.bottomAnchor.constraint(equalTo: logoLabelsContainer.bottomAnchor, constant: -6).isActive = true
        twitLogoLabel.leftAnchor.constraint(equalTo: TredulerLogoLabel.rightAnchor, constant: 6).isActive = true
        
        view.addSubview(twitlogoImageView)
        twitlogoImageView.translatesAutoresizingMaskIntoConstraints = false
        twitlogoImageView.leftAnchor.constraint(equalTo: TredulerLogoLabel.rightAnchor, constant: 15).isActive = true
        twitlogoImageView.bottomAnchor.constraint(equalTo: twitLogoLabel.topAnchor, constant: 3).isActive = true
        
        view.addSubview(emailTextFieldContainer)
        emailTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldContainer.topAnchor.constraint(equalTo: logoLabelsContainer.bottomAnchor, constant: 30).isActive = true
        emailTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        emailTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(usernameTextFieldContainer)
        usernameTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        usernameTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        usernameTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        usernameTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        usernameTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(nameTextFieldContainer)
        nameTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        nameTextFieldContainer.topAnchor.constraint(equalTo: usernameTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        nameTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        nameTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer.topAnchor.constraint(equalTo: nameTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        passwordTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 10).isActive = true
        signupButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        signupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.layer.cornerRadius = 8
        
        view.addSubview(signupLabel)
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        signupLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -20).isActive = true
        
        view.addSubview(SignUpButton)
        SignUpButton.translatesAutoresizingMaskIntoConstraints = false
        SignUpButton.leftAnchor.constraint(equalTo: signupLabel.rightAnchor, constant: 12).isActive = true
        SignUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
        
    }

}
