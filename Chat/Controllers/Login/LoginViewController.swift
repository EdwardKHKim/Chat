//
//  LoginViewController.swift
//  Chat
//
//  Created by Edward Kim on 2021-01-20.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    //
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    //
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FBMessengerLogo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "Connect with your favorite people."
        textLabel.textAlignment = .center
        textLabel.textColor = .black
        textLabel.font = .boldSystemFont(ofSize: 20)
        return textLabel
    }()

    //
    private let emailField: UITextField = {
        let emailField = UITextField()
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.returnKeyType = .continue
        emailField.layer.cornerRadius = 5
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.lightGray.cgColor
        emailField.placeholder = "Email"
        emailField.leftView = UIView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 20,
                                                   height: 0))
        emailField.leftViewMode = .always
        emailField.backgroundColor = .white
        return emailField
    }()
    
    //
    private let passwordField: UITextField = {
        let passwordField = UITextField()
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.returnKeyType = .done
        passwordField.layer.cornerRadius = 5
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.lightGray.cgColor
        passwordField.placeholder = "Password"
        passwordField.leftView = UIView(frame: CGRect(x: 0,
                                                      y: 0,
                                                      width: 20,
                                                      height: 0))
        passwordField.leftViewMode = .always
        passwordField.backgroundColor = .white
        passwordField.isSecureTextEntry = true
        return passwordField
    }()
    
    //
    private let continueButton: UIButton = {
        let continueButton = UIButton(type: .system)
        continueButton.tintColor = UIColor.white
        continueButton.backgroundColor = UIColor.link
        continueButton.layer.cornerRadius = 5
        continueButton.layer.masksToBounds = true
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = .systemFont(ofSize: 18,
                                                      weight: UIFont.Weight.medium)
        continueButton.addTarget(self,
                                 action: #selector(tapContinue),
                                 for: .touchUpInside)
        return continueButton
    }()
    
    //
    private let createAccountButton: UIButton = {
        let createAccountButton = UIButton(type: .system)
        createAccountButton.setTitle("Create account",
                                     for: .normal)
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 18,
                                                           weight: UIFont.Weight.medium)
        createAccountButton.addTarget(self,
                                      action: #selector(tapCreateAccount),
                                      for: .touchUpInside)
        return createAccountButton
    }()
    
    //
    @objc private func tapCreateAccount() {
        let viewController = CreateAccountViewController()
        viewController.title = "Create account"
        navigationController?.pushViewController(viewController,
                                                 animated: true)
    }
    
    //
    @objc private func tapContinue() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              !email.isEmpty else {
            alertLoginError()
            return
        }
        
        guard let password = passwordField.text,
              !password.isEmpty,
              password.count > 5 else {
            alertLoginError()
            return
        }
        
        spinner.show(in: view)
        
        // 
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authDataResult, error in
            
            guard let strongSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let dataResult = authDataResult, error == nil else {
                print("Incorrect email or password")
                return
            }
            
            let user = dataResult.user
            
            let safeEmail = DatabaseManager.safeEmail(email: email)
            DatabaseManager.shared.getUserData(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                          let firstName = userData["first_name"] as? String,
                          let lastName = userData["last_name"] as? String else {
                        return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case .failure(let error):
                    print("\(error)")
                }
            })
            
            UserDefaults.standard.set(email, forKey: "email")
            print("\(user) information is correct")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    //
    func alertLoginError() {
        let alert = UIAlertController(title: nil,
                                      message: "Incorrect email or password",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    //
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(textLabel)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(continueButton)
        scrollView.addSubview(createAccountButton)
    }
    
    //
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        // Size of the FB Messenger Icon
        let imageSize = scrollView.width/4
        imageView.frame = CGRect(x: (scrollView.width-imageSize)/2,
                                 y: scrollView.height/7,
                                 width: imageSize,
                                 height: imageSize)
        
        textLabel.frame = CGRect(x: 0,
                                 y: imageView.bottom+25,
                                 width: scrollView.width,
                                 height: 25)
        
        emailField.frame = CGRect(x: 30,
                                  y: textLabel.bottom+25,
                                  width: scrollView.width-60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                    y: emailField.bottom+15,
                                    width: scrollView.width-60,
                                    height: 52)
        
        continueButton.frame = CGRect(x: 30,
                                      y: passwordField.bottom+25,
                                      width: scrollView.width-60,
                                      height: 52)
        
        createAccountButton.frame = CGRect(x: 100,
                                           y: continueButton.bottom+5,
                                           width: scrollView.width-200,
                                           height: 52)
    }
}

//
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            tapContinue()
        }
        return true
    }
}
