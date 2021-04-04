//
//  CommentCell.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/1/21.
//

import UIKit

class CommentCell: UICollectionViewCell {

	// MARK: - Properties

	var viewModel: CommentViewModel? {
		didSet { configure() }
	}

	private let profileImageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .lightGray
		return iv
	}()

	private let commentLabel = UILabel()

	// MARK: - Lifecycle

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(profileImageView)
		profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
		profileImageView.setDimensions(height: 40, width: 40)
		profileImageView.layer.cornerRadius = 20

		commentLabel.numberOfLines = 0
		addSubview(commentLabel)
		commentLabel.centerY(inView: profileImageView,
												 leftAnchor: profileImageView.rightAnchor,
												 paddingLeft: 8)

		commentLabel.anchor(right: rightAnchor, paddingRight: 8)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Helpers

	private func configure() {
		guard let viewModel = viewModel else { return }
		profileImageView.sd_setImage(with: viewModel.profileImageURL, completed: nil)
		commentLabel.attributedText = viewModel.commentLabelText()
	}

}
