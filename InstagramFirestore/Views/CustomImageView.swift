//
//  CustomImageView.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import UIKit

class CustomImageView: UIImageView {
	
	override init(image: UIImage?) {
		super.init(image: image)
		setup()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	func setup() {
		backgroundColor = .lightGray
		contentMode = .scaleToFill
		clipsToBounds = true
	}
}
