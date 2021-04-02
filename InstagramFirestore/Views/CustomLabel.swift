//
//  CustomLabel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import UIKit

class CustomLabel: UILabel {

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupUI() {
		numberOfLines = 0
		textAlignment = .center
	}

}
