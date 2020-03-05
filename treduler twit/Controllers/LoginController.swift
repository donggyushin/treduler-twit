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
    
    private lazy var loginButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .white
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var signupLabel:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Don't you have an account yet?"
        
        return label
    }()
    
    private lazy var SignUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(self.goToSignUp), for: .touchUpInside)
        
        return button
    }()
    
    
    
    
    // MARK: - life circle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - helper
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func goToSignUp(){
        let signUpVC = SignUpController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func loginButtonTapped(){
        print("login button tapped")
    }
    
    
    
    // MARK: - configure ui
    
    func configUI(){
        view.backgroundColor = UIColor.mainBlue
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        view.addSubview(logoLabelsContainer)
        logoLabelsContainer.translatesAutoresizingMaskIntoConstraints = false
        logoLabelsContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        logoLabelsContainer.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        logoLabelsContainer.heightAnchor.constraint(equalToConstant: 130).isActive = true
        
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
        
        view.addSubview(passwordTextFieldContainer)
        passwordTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordTextFieldContainer.topAnchor.constraint(equalTo: emailTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        passwordTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        passwordTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 10).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.layer.cornerRadius = 8
        
        view.addSubview(signupLabel)
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        signupLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5).isActive = true
        signupLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30).isActive = true
        
        view.addSubview(SignUpButton)
        SignUpButton.translatesAutoresizingMaskIntoConstraints = false
        SignUpButton.leftAnchor.constraint(equalTo: signupLabel.rightAnchor, constant: 12).isActive = true
        SignUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 1).isActive = true
        
        
    }
    
        
    

}
