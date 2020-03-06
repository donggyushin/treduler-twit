//
//  SignUpController.swift
//  treduler twit
//
//  Created by 신동규 on 2020/03/06.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    
    // MARK: - properties
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var profileImage:UIImage?
    var email:String?
    
    let picker:UIImagePickerController = {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
        picker.allowsEditing = true // 수정가능하게 할지 선택. 하지만 false
        return picker
    }()
    
    private lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "plus_photo")
        iv.image = iv.image?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = .white
        iv.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        iv.addGestureRecognizer(tapRecognizer)
        
        return iv
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
        emailTextField.autocorrectionType = .no
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
    
    private lazy var emailTextField:UITextField = {
        let tf = UITextField()
        return tf
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
        
        
        usernameTextField.attributedPlaceholder = NSAttributedString(string: "User name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameTextField.tintColor = .white
        usernameTextField.backgroundColor = .clear
        usernameTextField.autocorrectionType = .no
        usernameTextField.textColor = .white
        usernameTextField.autocapitalizationType = .none
        view.addSubview(self.usernameTextField)
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        usernameTextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        usernameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    private lazy var usernameTextField:UITextField = {
        let tf = UITextField()
        return tf
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
        
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Name",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        nameTextField.tintColor = .white
        nameTextField.backgroundColor = .clear
        nameTextField.textColor = .white
        nameTextField.autocapitalizationType = .none
        view.addSubview(self.nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    private lazy var nameTextField:UITextField = {
        let tf = UITextField()
        return tf
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
        
        
        password1TextField.attributedPlaceholder = NSAttributedString(string: "password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password1TextField.isSecureTextEntry = true
        password1TextField.tintColor = .white
        password1TextField.backgroundColor = .clear
        password1TextField.autocapitalizationType = .none
        password1TextField.textColor = .white
        view.addSubview(self.password1TextField)
        password1TextField.translatesAutoresizingMaskIntoConstraints = false
        password1TextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        password1TextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        password1TextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    private lazy var password1TextField:UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    private lazy var confirmpasswordTextFieldContainer:UIView = {
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
        
        
        password2TextField.attributedPlaceholder = NSAttributedString(string: "password",
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        password2TextField.isSecureTextEntry = true
        password2TextField.tintColor = .white
        password2TextField.backgroundColor = .clear
        password2TextField.autocapitalizationType = .none
        password2TextField.textColor = .white
        view.addSubview(self.password2TextField)
        password2TextField.translatesAutoresizingMaskIntoConstraints = false
        password2TextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        password2TextField.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
        password2TextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
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
    
    private lazy var password2TextField:UITextField = {
        let tf = UITextField()
        return tf
    }()
    
    private lazy var signupButton:UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.backgroundColor = .white
        button.setTitle("SIGN UP", for: .normal)
        button.setTitleColor(UIColor.mainBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
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
    
    private lazy var activityView:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        return view
    }()
    
    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configViewMovableWhenKeyboardAppearOrHide()
        picker.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configUI()
    }
    
    // MARK: - helper
    
    func presenterAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @objc func signupButtonTapped(){
        
        self.signupButton.isEnabled = false
        self.activityView.startAnimating()
        
        guard let email = self.emailTextField.text,
            let password1 = self.password1TextField.text,
            let password2 = self.password2TextField.text,
            let username = self.usernameTextField.text,
            let name = self.nameTextField.text,
            let profileImage = self.profileImage
        else {
            presenterAlert(title: "Warning", message: "Please fill all form")
            self.signupButton.isEnabled = true
            self.activityView.stopAnimating()
                return
                
        }
        
        if password1 != password2 {
            presenterAlert(title: "Warning", message: "Please confirm your password again")
            self.signupButton.isEnabled = true
            self.activityView.stopAnimating()
            return
        }
        
        
        
        let profile_image_uuid = UUID().uuidString
        let profileImageRef = self.storage.reference().child("profile_images/\(profile_image_uuid)")
        guard let data = profileImage.jpegData(compressionQuality: 1) else {
            self.presenterAlert(title: "Warning", message: "Fail to make data from your profile image")
            self.signupButton.isEnabled = true
            self.activityView.stopAnimating()
            return
        }
        
        let uploadTask = profileImageRef.putData(data, metadata: nil) { (meta, error) in
            if let error = error {
                self.presenterAlert(title: "Warning", message: error.localizedDescription)
                self.signupButton.isEnabled = true
                self.activityView.stopAnimating()
            }else {
                profileImageRef.downloadURL { (url, error) in
                    if let error = error {
                        self.presenterAlert(title: "Warning", message: error.localizedDescription)
                        self.signupButton.isEnabled = true
                        self.activityView.stopAnimating()
                    }else {
                        let downloadUrl = url!.absoluteString
                        Auth.auth().createUser(withEmail: email, password: password1) { (result, error) in
                            if let error = error {
                                self.presenterAlert(title: "Warning", message: error.localizedDescription)
                                self.signupButton.isEnabled = true
                                self.activityView.stopAnimating()
                            }else {
                                self.db.collection("users").document(result!.user.uid).setData([
                                "email": email,
                                "password": password1,
                                "username": username,
                                "name": name,
                                "profileImageUrlString":downloadUrl,
                                "uid": result!.user.uid
                                    ], completion: { (error) in
                                        if let error = error {
                                            self.presenterAlert(title: "Warning", message: error.localizedDescription)
                                            self.signupButton.isEnabled = true
                                            self.activityView.stopAnimating()
                                        }else {
                                            // success sign up
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
                                })
                            }
                        }
                    }
                }
            }
        }
        uploadTask.resume()
        
        
        
        
        
    }
    
    
    func configViewMovableWhenKeyboardAppearOrHide(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 40
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc func openImagePicker(){
        present(self.picker, animated: true, completion: nil)
    }
    
    @objc func goToLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: configure ui

    func configUI(){
        view.backgroundColor = UIColor.mainBlue
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backItem?.title = "Login"
        
        
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.layer.cornerRadius = 50
        
        view.addSubview(emailTextFieldContainer)
        emailTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        emailTextFieldContainer.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 30).isActive = true
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
        
        view.addSubview(confirmpasswordTextFieldContainer)
        confirmpasswordTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        confirmpasswordTextFieldContainer.topAnchor.constraint(equalTo: passwordTextFieldContainer.bottomAnchor, constant: 20).isActive = true
        confirmpasswordTextFieldContainer.widthAnchor.constraint(equalToConstant: view.frame.width * 0.8).isActive = true
        confirmpasswordTextFieldContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmpasswordTextFieldContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(signupButton)
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.topAnchor.constraint(equalTo: confirmpasswordTextFieldContainer.bottomAnchor, constant: 10).isActive = true
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
        
        self.view.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
    }

}

// MARK: - ImagePickerController delegate

extension SignUpController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.picker.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            self.picker.dismiss(animated: true, completion: nil)
            return
        }
        self.profileImage = image
        self.profileImageView.image = image
        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 1.2
        self.picker.dismiss(animated: true, completion: nil)
        
    }
}
