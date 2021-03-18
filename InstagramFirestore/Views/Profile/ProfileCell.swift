//
//  ProfileCell.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {
	
	// MARK: - Properties
	
	private let postImageView = CustomImageView(image: #imageLiteral(resourceName: "venom-7"))

	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(postImageView)
		postImageView.fillSuperview()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
