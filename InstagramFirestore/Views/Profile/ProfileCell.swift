//
//  ProfileCell.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import UIKit

class ProfileCell: UICollectionViewCell {

	// MARK: - Properties

	var viewModel: PostViewModel? {
		didSet { configure() }
	}

	private let postImageView = CustomImageView(image: nil)

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(postImageView)
		postImageView.fillSuperview()

	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configure() {
		guard let viewModel = viewModel else { return }
		postImageView.sd_setImage(with: viewModel.postImageURL, completed: nil)
	}

}
