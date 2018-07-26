//
//  SignUpController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation

class SignUpController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Class Properties
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let titleLabel: UILabel = {
        let titleLogo = UILabel()
        titleLogo.font = Font(.installed(.bakersfieldBold), size: .custom(40)).instance
        titleLogo.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        titleLogo.text = "Haligrove"
        titleLogo.textAlignment = .center
        return titleLogo
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9450980392, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9450980392, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.isSecureTextEntry = true
        tf.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9450980392, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.titleLabel?.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let transitionButton: UIButton = {
        let button = UIButton(type: .custom)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(16)).instance, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        attributedTitle.append(NSAttributedString(string: "Login", attributes: [NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(16)).instance, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]))
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    // MARK: - textField delegate
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    // MARK: - Class Methods
    fileprivate func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.anchor(top: nil, right: view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 25, paddingBottom: 0, paddingLeft: 25, width: 0, height: 200)
        
        view.addSubview(titleLabel)
        titleLabel.anchor(top: nil, right: view.safeAreaLayoutGuide.rightAnchor, bottom: stackView.topAnchor, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 20, paddingLeft: 0, width: 0, height: 0)
        
        view.addSubview(transitionButton)
        transitionButton.anchor(top: nil, right: view.rightAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingRight: 0, paddingBottom: 0, paddingLeft: 0, width: 0, height: 50)
    }
    
    private func setupVideoBackground() {
        guard let theUrl = Bundle.main.url(forResource: "smoke", withExtension: "mov") else { return }
        avPlayer = AVPlayer(url: theUrl)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = .none
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).withAlphaComponent(0.06)
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        avPlayerLayer.frame = view.layer.bounds
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc func viewDidRotate() {
        if UIDevice.current.orientation.isLandscape {
            avPlayerLayer.frame = view.layer.bounds
        } else {
            avPlayerLayer.frame = view.layer.bounds
        }
    }
    
    @objc func playerItemDidReachEnd(notification: Notification) {
        let p: AVPlayerItem = notification.object as! AVPlayerItem
        p.seek(to: kCMTimeZero, completionHandler: nil)
    }
    
    @objc func handleShowLogin() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInputChange() {
        guard let email = emailTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        let isFormValid = username.count > 0 && password.count > 6 && email.count > 0 && email.contains("@")
        
        if isFormValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            signUpButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            signUpButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text, email.count > 0 else { return }
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 6 else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print(err._code)
                self.handleError(err)
                return
            }
            print("Successfully created user: ", user?.user.uid ?? "")
            guard let uid = user?.user.uid else { return }
            let userData = ["username": username, "email": email]
            let values = [uid: userData]
            
            Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
                if let err = err {
                    print("Failed to save user info into database: ", err)
                    // TODO: - Present Notification of failure to user
                }
                print("Successfully saved user into database")
                // TODO: - Notify user of success
                
                guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                mainTabBarController.setupViewControllers()
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    // MARK: - viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        avPlayer.play()
        paused = false
    }
    
    // MARK: - viewDidDisappear
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: - Check for internet connection and notify user if none
        setupViews()
        setupVideoBackground()
    }
}

