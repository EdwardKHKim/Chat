//
//  CreateAccountViewController.swift
//  Chat
//
//  Created by Edward Kim on 2021-01-20.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    //
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle")
        imageView.tintColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    // 
    private let firstNameField: UITextField = {
        let firstNameField = UITextField()
        firstNameField.autocapitalizationType = .none
        firstNameField.autocorrectionType = .no
        firstNameField.returnKeyType = .continue
        firstNameField.layer.cornerRadius = 5
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.borderColor = UIColor.lightGray.cgColor
        firstNameField.placeholder = "First Name"
        firstNameField.leftView = UIView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 20,
                                                   height: 0))
        firstNameField.leftViewMode = .always
        firstNameField.backgroundColor = .white
        return firstNameField
    }()
    
    //
    private let lastNameField: UITextField = {
        let lastNameField = UITextField()
        lastNameField.autocapitalizationType = .none
        lastNameField.autocorrectionType = .no
        lastNameField.returnKeyType = .continue
        lastNameField.layer.cornerRadius = 5
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.borderColor = UIColor.lightGray.cgColor
        lastNameField.placeholder = "Last Name"
        lastNameField.leftView = UIView(frame: CGRect(x: 0,
                                                   y: 0,
                                                   width: 20,
                                                   height: 0))
        lastNameField.leftViewMode = .always
        lastNameField.backgroundColor = .white
        return lastNameField
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
    private let createAccountButton: UIButton = {
        let createAccountButton = UIButton(type: .system)
        createAccountButton.tintColor = UIColor.white
        createAccountButton.backgroundColor = UIColor.link
        createAccountButton.layer.cornerRadius = 25
        createAccountButton.layer.masksToBounds = true
        createAccountButton.setTitle("Create account", for: .normal)
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 18,
                                                      weight: UIFont.Weight.medium)
        createAccountButton.addTarget(self,
                                 action: #selector(tapCreateAccount),
                                 for: .touchUpInside)
        return createAccountButton
    }()
    
    //
    @objc private func tapCreateAccount() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
              !firstName.isEmpty else {
            alertCreateAccountError()
            return
        }
        
        guard let lastName = lastNameField.text,
              !lastName.isEmpty else {
            alertCreateAccountError()
            return
        }
        
        guard let email = emailField.text,
              !email.isEmpty, email.contains("@") else {
            alertCreateAccountError()
            return
        }
        
        guard let password = passwordField.text,
              !password.isEmpty,
              password.count > 5 else {
            alertCreateAccountError()
            return
        }
    }
    
    //
    func alertCreateAccountError() {
        let alert = UIAlertController(title: nil,
                                      message: "Invalid inputs. Password must be at least 6 characters",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    //
    private let toLoginViewButton: UIButton = {
        let createAccountButton = UIButton(type: .system)
        createAccountButton.setTitle("Alredy have an account? Login.",
                                     for: .normal)
        createAccountButton.titleLabel?.font = .systemFont(ofSize: 15,
                                                           weight: UIFont.Weight.regular)
        createAccountButton.addTarget(self,
                                      action: #selector(tapToLoginView),
                                      for: .touchUpInside)
        return createAccountButton
    }()
    
    //
    @objc private func tapToLoginView() {
        navigationController?.popViewController(animated: true)
    }

    // 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(createAccountButton)
        scrollView.addSubview(toLoginViewButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(tapProfilePhoto))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func tapProfilePhoto() {
        presentPhotoActionSheet()
    }
    
    //
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let imageSize = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-imageSize)/2,
                                 y: scrollView.height/8,
                                 width: imageSize,
                                 height: imageSize)
        
        imageView.layer.cornerRadius = imageView.width/2.0
    
        firstNameField.frame = CGRect(x: 30,
                                      y: imageView.bottom+25,
                                      width: scrollView.width-60,
                                      height: 52)
        
        lastNameField.frame = CGRect(x: 30,
                                     y: firstNameField.bottom+15,
                                     width: scrollView.width-60,
                                     height: 52)
        
        emailField.frame = CGRect(x: 30,
                                  y: lastNameField.bottom+15,
                                  width: scrollView.width-60,
                                  height: 52)
        
        passwordField.frame = CGRect(x: 30,
                                    y: emailField.bottom+15,
                                    width: scrollView.width-60,
                                    height: 52)
        
        createAccountButton.frame = CGRect(x: 30,
                                           y: passwordField.bottom+35,
                                           width: scrollView.width-60,
                                           height: 52)
        toLoginViewButton.frame = CGRect(x: 50,
                                         y: createAccountButton.bottom+5,
                                         width: scrollView.width-100,
                                         height: 52)
    }
}

//
extension CreateAccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            tapCreateAccount()
        }
        return true
    }
}

//
extension CreateAccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.takePhoto()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.choosePhoto()
        }))
        
        present(actionSheet, animated: true)
    }
    
    //
    func takePhoto() {
        let viewController = UIImagePickerController()
        viewController.sourceType = .camera
        viewController.delegate = self
        viewController.allowsEditing = true
        present(viewController, animated: true)
    }
    
    //
    func choosePhoto() {
        let viewController = UIImagePickerController()
        viewController.sourceType = .photoLibrary
        viewController.delegate = self
        viewController.allowsEditing = true
        present(viewController, animated: true)
    }
    
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        print(info)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage]
                as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
