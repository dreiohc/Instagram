//
//  CustomTextField.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/16/21.
//

import UIKit

class CustomTextField: UITextField {

	private let placeholderText: String

	init(placeholder: String) {
		self.placeholderText = placeholder
		super.init(frame: .zero)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupUI() {

		let spacer = UIView()
		spacer.setDimensions(height: 50, width: 12)
		leftView = spacer
		leftViewMode = .always
		autocapitalizationType = .none
		autocorrectionType = .no
		borderStyle = .none
		textColor = .white
		keyboardAppearance = .dark
		backgroundColor = UIColor(white: 1, alpha: 0.1)
		attributedPlaceholder = NSAttributedString(string: placeholderText,
																							 attributes: [.foregroundColor: UIColor(white: 1,
																																										  alpha: 0.7)])
		setHeight(50)
	}

}
