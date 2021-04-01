//
//  CustomImageView.swift
//  InstagramFirestore
//
//  Created by Myrorn Dulay on 3/17/21.
//

import UIKit

class CustomImageView: UIImageView {
	
	override init(image: UIImage?) {
		super.init(image: image)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	
	func setupUI() {
		backgroundColor = .lightGray
		contentMode = .scaleToFill
		clipsToBounds = true
	}
}
