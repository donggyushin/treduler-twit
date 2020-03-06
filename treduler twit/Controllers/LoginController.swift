//
//  LoginController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

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
    
    private lazy var emailTextField:UITextField = {
        let tf = UITextField()
        return tf
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
        
        
        emailTextField.attributedPlaceholder = NSAttributedString(string: "email@gmail.com",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        emailTextField.tintColor = .white
        emailTextField.backgroundColor = .clear
        emailTextField.textColor = .white
        emailTextField.autocapitalizationType = .none
        view.addSubview(self.emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    private lazy var passwordTextField:UITextField = {
        return UITextField()
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
        
        
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.isSecureTextEntry = true
        passwordTextField.tintColor = .white
        passwordTextField.backgroundColor = .clear
        passwordTextField.autocapitalizationType = .none
        passwordTextField.textColor = .white
        view.addSubview(self.passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    
    private lazy var loadingIndicator:UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        return iv
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
    
    func presentAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func loginButtonTapped(){
        self.loginButton.isEnabled = false
        self.loadingIndicator.startAnimating()
        
        
        guard let email = self.emailTextField.text,
            let password = self.passwordTextField.text else {
                self.presentAlert(title: "Warning", message: "Please fill all form")
                self.loginButton.isEnabled = true
                self.loadingIndicator.stopAnimating()
                return
            }
            
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.presentAlert(title: "Warning", message: error.localizedDescription)
                self.loginButton.isEnabled = true
                self.loadingIndicator.stopAnimating()
            }else {
                guard let viewController = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                    .filter({$0.isKeyWindow}).first?.rootViewController as? MainTabBarController else {
                    print("fail to retrieve view controller")
                    return
                }
                viewController.checkUserLoggedIn()
                self.dismiss(animated: true, completion: nil)
            }
        }
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
        
        
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
    }
    
        
    

}
