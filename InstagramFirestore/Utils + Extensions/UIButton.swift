//
//  UIButton.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/16/21.
//

import UIKit

extension UIButton {

	func attrbutedTitle(firstPart: String, secondPart: String) {

		let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.87),
																										 .font: UIFont.systemFont(ofSize: 16)]

		let attrbutedTitle = NSMutableAttributedString(string: "\(firstPart)  ", attributes: attributes)

		let boldAttributes: [NSMutableAttributedString.Key: Any] = [.foregroundColor: UIColor(white: 1, alpha: 0.7),
																																.font: UIFont.boldSystemFont(ofSize: 16)]

		attrbutedTitle.append(NSAttributedString(string: "\(secondPart)", attributes: boldAttributes))

		setAttributedTitle(attrbutedTitle, for: .normal)

	}

	func autoshrinkButton() -> UIButton {
		self.titleLabel?.adjustsFontSizeToFitWidth = true
		self.titleLabel?.lineBreakMode = .byClipping
		self.titleLabel?.numberOfLines = 1
		self.titleLabel?.minimumScaleFactor = 0.2
		return self
	}

	func basicButton(title: String) {
		setTitle(title, for: .normal)
		setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
		backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
		layer.cornerRadius = 5
		setHeight(50)
		titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
		isEnabled = false
	}

	func isEnabledOnlyIf(_ formIsValid: Bool) {
		if formIsValid {
			backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
			setTitleColor(.white, for: .normal)
			isEnabled = true
		} else {
			backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
			setTitleColor(UIColor(white: 1, alpha: 0.67), for: .normal)
			isEnabled = false
		}
	}
}
