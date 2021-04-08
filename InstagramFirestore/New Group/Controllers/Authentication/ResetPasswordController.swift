//
//  ResetPasswordController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/8/21.
//

import UIKit

protocol ResetPasswordControllerDelegate: class {
  func controllerDidSendResetPasswordLink(_ controller: ResetPasswordController)
}

class ResetPasswordController: UIViewController {
  
  // MARK: - Properties
  
  private var viewModel = ResetPasswordViewModel()
  
  weak var delegate: ResetPasswordControllerDelegate?
  
  private let emailTextField: CustomTextField = {
    let tf = CustomTextField(placeholder: "Email")
    tf.keyboardType = .emailAddress
    return tf
  }()
  
  private let iconImage: UIImageView = {
    let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
    iv.contentMode = .scaleAspectFill
    return iv
    }()
  
  private let resetPasswordButton: UIButton = {
    let button = UIButton()
    button.basicButton(title: "Reset Password")
    button.addTarget(self, action: #selector(handleResetPassword), for: .touchUpInside)
    return button
  }()
  
  private let backButton: UIButton = {
    let button = UIButton(type: .system)
    button.tintColor = .white
    button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
    return button
  }()


  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    configureUI()
    
  }
  
  // MARK: - Actions
  
  @objc func handleResetPassword() {
    guard let email = emailTextField.text else { return }
    showLoader(true)
    AuthService.resetPassword(withEmail: email) { [weak self] error in
      if let error = error {
        self?.showMessage(withTitle: "Error", message: error.localizedDescription)
        self?.showLoader(false)
        return
      }
      
      guard let strongSelf = self else { return }
      
      self?.delegate?.controllerDidSendResetPasswordLink(strongSelf)
    }
  }
  
  @objc func handleDismissal() {
    navigationController?.popViewController(animated: true)
  }
  
  @objc func textDidChange(sender: UITextField) {
    if sender == emailTextField {
      viewModel.email = sender.text
    }
    resetPasswordButton.isEnabledOnlyIf(viewModel.formIsValid)
  }
  
  // MARK: - Helpers
  private func configureUI() {
    configureGradientLayer()
    
    emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    
    view.addSubview(backButton)
    backButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                      left: view.leftAnchor,
                      paddingTop: 16,
                      paddingLeft: 16)
    
    view.addSubview(iconImage)
    iconImage.centerX(inView: view)
    iconImage.setDimensions(height: 80, width: 120)
    iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
    
    let stackView = UIStackView(arrangedSubviews: [emailTextField, resetPasswordButton])
    stackView.axis = .vertical
    stackView.spacing = 20
    
    view.addSubview(stackView)
    stackView.anchor(top: iconImage.bottomAnchor,
                     left: view.leftAnchor,
                     right: view.rightAnchor,
                     paddingTop: 32,
                     paddingLeft: 32,
                     paddingRight: 32)
  }
}


// MARK: - Extensions
