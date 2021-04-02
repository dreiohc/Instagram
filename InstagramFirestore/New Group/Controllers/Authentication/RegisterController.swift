//
//  RegisterController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit

class RegistrationController: UIViewController {

	// MARK: - Properties

	private var viewModel = RegistrationViewModel()
	private var profileImage: UIImage?
	weak var delegate: AuthenticationDelegate?

	private let plusPhotoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
		button.tintColor = .white
		button.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
		return button
	}()

	private let emailTextField: UITextField = {
		let tf = CustomTextField(placeholder: "Email")
		tf.keyboardType = .emailAddress
		return tf
	}()

	private let passwordTextField: UITextField = {
		let tf = CustomTextField(placeholder: "Password")
		tf.isSecureTextEntry = true
		return tf
	}()

	private let fullNameTextField: CustomTextField = {
		let tf = CustomTextField(placeholder: "Fullname")
		tf.autocapitalizationType = .words
		return tf
	}()

	private let usernameTextField = CustomTextField(placeholder: "Username")

	private let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.basicButton(title: "Sign Up")
		button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
		return button
	}()

	private let alreadyHaveAccountButton: UIButton = {
		let button = UIButton(type: .system)
		button.attributedTitle(firstPart: "Already have an account?", secondPart: "Log In")
		button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
		return button
	}()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		configureNotificationObservers()
	}

	// MARK: - Actions

	@objc func handleShowLogin() {
		navigationController?.popViewController(animated: true)
	}

	@objc func textDidChange(sender: UITextField) {

		switch sender {
		case emailTextField:
			viewModel.email = sender.text
		case passwordTextField:
			viewModel.password = sender.text
		case fullNameTextField:
			viewModel.fullName = sender.text
		case usernameTextField:
			viewModel.userName = sender.text
		default:
			break
		}
		signUpButton.isEnabledOnlyIf(viewModel.formIsValid)
	}

	@objc func handleProfilePhotoSelect() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}

	@objc func handleSignUp() {

		guard let email = emailTextField.text else { return }
		guard let password = passwordTextField.text else { return }
		guard let fullname = fullNameTextField.text else { return }
		guard let username = usernameTextField.text else { return }

		let profileImage = self.profileImage

		let credentials = AuthCredentials(email: email,
																			password: password,
																			fullname: fullname,
																			username: username,
																			profileImage: profileImage)

		AuthService.registerUser(withCredential: credentials) { [weak self] error in
			if let error = error {
				fatalError("DEBUG: Failed to register user \(error.localizedDescription)")
			}
			self?.delegate?.authenticationComplete()
		}
	}

	// MARK: - Helpers

	func configureUI() {

		configureGradientLayer()

		view.addSubview(plusPhotoButton)
		plusPhotoButton.centerX(inView: view)
		plusPhotoButton.setDimensions(height: 140, width: 140)
		plusPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)

		let stackView = UIStackView(arrangedSubviews: [emailTextField,
																									 passwordTextField,
																									 fullNameTextField,
																									 usernameTextField,
																									 signUpButton])
		view.addSubview(stackView)
		stackView.axis = .vertical
		stackView.spacing = 20
		stackView.centerX(inView: view)
		stackView.anchor(top: plusPhotoButton.bottomAnchor,
										 left: view.leftAnchor,
										 right: view.rightAnchor,
										 paddingTop: 32,
										 paddingLeft: 32,
										 paddingRight: 32)

		view.addSubview(alreadyHaveAccountButton)
		alreadyHaveAccountButton.centerX(inView: view)
		alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
	}

	func configureNotificationObservers() {
		emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
		passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
		usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
		fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
	}
}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

		guard let selectedImage = info[.editedImage] as? UIImage else { return }
		profileImage = selectedImage
		plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
		plusPhotoButton.layer.masksToBounds = true
		plusPhotoButton.layer.borderColor = UIColor.white.cgColor
		plusPhotoButton.layer.borderWidth = 2
		plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
		self.dismiss(animated: true, completion: nil)
	}
}
