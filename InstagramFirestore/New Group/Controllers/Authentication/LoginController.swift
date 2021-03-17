//
//  LoginController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit

class LoginController: UIViewController {
	
	// MARK: - Properties
	
	private var viewModel = LoginViewModel()
	
	private let iconImage: UIImageView = {
		let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
		iv.contentMode = .scaleAspectFill
		return iv
	}()
	
	private let emailTextField: UITextField = {
		let tf = CustomTextField(placeholder: "Email")
		tf.keyboardType = .emailAddress
		return tf
	}()
	
	private let passwordTextField: UITextField = {
		let tf = CustomTextField(placeholder: "Password")
		tf.isSecureTextEntry = true
		tf.keyboardType = .emailAddress
		return tf
	}()
	
	private let forgotPasswordButton: UIButton = {
		let button = UIButton(type: .system).autoshrinkButton()
		button.attributedTitle(firstPart: "Forgot your password?", secondPart: "Get help signing in.")
		return button
	}()
	
	private let dontHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign Up")
		button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
		return button
	}()
	
	private let loginButton: UIButton = {
		let button = UIButton(type: .system)
		button.basicButton(title: "Log In")
		button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		configureNotificationObservers()
	}
	
	// MARK: - Actions
	
	@objc func handleShowSignUp() {
		let controller = RegistrationController()
		navigationController?.pushViewController(controller, animated: true)
	}
	
	@objc func textDidChange(sender: UITextField) {
		if sender == emailTextField {
			viewModel.email = sender.text
		} else {
			viewModel.password = sender.text
		}
		loginButton.isEnabledOnlyIf(viewModel.formIsValid)
	}
	
	@objc func handleLogin() {
		guard let email = emailTextField.text else { return }
		guard let password = passwordTextField.text else { return }
		AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
			if let error = error {
				print("DEBUG: Failed to log user in \(error.localizedDescription)")
				return
			}
			self.dismiss(animated: true, completion: nil)
		}
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		configureGradientLayer()
		navigationController?.navigationBar.barStyle = .black
		navigationController?.navigationBar.isHidden = true
		
		view.addSubview(iconImage)
		iconImage.centerX(inView: view)
		iconImage.setDimensions(height: 80, width: 120)
		iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
		
		let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
		stackView.axis = .vertical
		stackView.spacing = 20
		
		view.addSubview(stackView)
		stackView.anchor(top: iconImage.bottomAnchor,
										 left: view.leftAnchor,
										 right: view.rightAnchor,
										 paddingTop: 32,
										 paddingLeft: 32,
										 paddingRight: 32)
		
		view.addSubview(dontHaveAccountButton)
		dontHaveAccountButton.centerX(inView: view)
		dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
	}
	
	func configureNotificationObservers() {
		emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
	}
	
}

