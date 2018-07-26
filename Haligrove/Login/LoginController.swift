//
//  LoginController.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class LoginController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Class Properties
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font(.installed(.bakersfieldBold), size: .custom(40)).instance
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        label.text = "Haligrove"
        label.textAlignment = .center
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9450980392, alpha: 1)
        tf.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.keyboardType = .emailAddress
        tf.autocapitalizationType = .none
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        tf.isSecureTextEntry = true
        tf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        tf.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9647058824, blue: 0.9450980392, alpha: 1)
        tf.borderStyle = .roundedRect
        tf.delegate = self
        tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return tf
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        button.titleLabel?.font = Font(.installed(.bakersfieldBold), size: .custom(18)).instance
        button.layer.cornerRadius = 5
        button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    let transitionButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(16)).instance, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)])
        button.setAttributedTitle(attributedTitle, for: .normal)
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: Font(.installed(.bakersfieldBold), size: .custom(16)).instance, NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]))
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupVideoBackground()
        viewAnimations()
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
    
    // MARK: - Class Methods
    fileprivate func setupViews() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.anchor(top: nil, right: view.safeAreaLayoutGuide.rightAnchor, bottom: nil, left: view.safeAreaLayoutGuide.leftAnchor, paddingTop: 0, paddingRight: 25, paddingBottom: 0, paddingLeft: 25, width: 0, height: 140)
        
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
    
    fileprivate func viewAnimations() {
        UIView.animate(withDuration: 0.4, delay: 0.8, options: [.curveEaseOut], animations: {
            self.titleLabel.center.y += 400
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.2, options: [.curveEaseOut], animations: {
            self.emailTextField.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.4, options: [.curveEaseOut], animations: {
            self.passwordTextField.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.3, delay: 0.6, options: [.curveEaseOut], animations: {
            self.loginButton.center.x += self.view.bounds.width
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 1.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: [.curveEaseOut], animations: {
            self.transitionButton.center.y -= 200
        }, completion: nil)
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
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (user, err) in
            if let err = err {
                print(err._code)
                self.handleError(err)
                return
            }
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewControllers()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleTextInputChange() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        let isFormValid = password.count > 0 && email.count > 0 && email.contains("@")
        if isFormValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            loginButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            loginButton.tintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            view.endEditing(true)
        }
        return true
    }
    
    @objc func handleShowSignUp() {
        let signUpController = SignUpController()
        navigationController?.pushViewController(signUpController, animated: true)
    }
}
