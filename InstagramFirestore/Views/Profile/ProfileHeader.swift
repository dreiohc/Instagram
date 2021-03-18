//
//  ProfileHeader.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import UIKit
import SDWebImage

class ProfileHeader: UICollectionReusableView {
	
	// MARK: - Properties
	
	var viewModel: ProfileHeaderViewModel? {
		didSet { configure()
		}
	}
	
	private let profileImageView = CustomImageView(image: nil)
	
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	
	private lazy var editProfileFollowButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Edit Profile", for: .normal)
		button.layer.cornerRadius = 3
		button.layer.borderColor = UIColor.lightGray.cgColor
		button.layer.borderWidth = 0.5
		button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
		button.setTitleColor(.black, for: .normal)
		button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
		return button
	}()
	
	private lazy var postLabel: CustomLabel = {
		let label = CustomLabel()
		label.attributedText = attributedStatText(value: 5, label: "posts")
		return label
	}()
	
	private lazy var followersLabel: CustomLabel = {
		let label = CustomLabel()
		label.attributedText = attributedStatText(value: 3, label: "followers")
		return label
	}()
	
	private lazy var followingLabel: CustomLabel = {
		let label = CustomLabel()
		label.attributedText = attributedStatText(value: 2, label: "following")
		return label
	}()
	
	let gridButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		return button
	}()
	
	let listButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		return button
	}()
	
	let bookmarkButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
		button.tintColor = UIColor(white: 0, alpha: 0.2)
		return button
	}()
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		
		addSubview(profileImageView)
		profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
		profileImageView.setDimensions(height: 80, width: 80)
		profileImageView.layer.cornerRadius = 40
		
		addSubview(nameLabel)
		nameLabel.anchor(top: profileImageView.bottomAnchor,
										 left: leftAnchor,
										 paddingTop: 12,
										 paddingLeft: 12)
		
		addSubview(editProfileFollowButton)
		editProfileFollowButton.anchor(top: nameLabel.bottomAnchor,
																	 left: leftAnchor,
																	 right: rightAnchor,
																	 paddingTop: 16,
																	 paddingLeft: 24,
																	 paddingRight: 24)
		
		let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
		stackView.distribution = .fillEqually
		
		addSubview(stackView)
		stackView.centerY(inView: profileImageView)
		stackView.anchor(left: profileImageView.rightAnchor,
										 right: rightAnchor,
										 paddingLeft: 12,
										 paddingRight: 12,
										 height: 50)
		
		let topDivider = UIView()
		topDivider.backgroundColor = .lightGray
		
		let bottomDivider = UIView()
		bottomDivider.backgroundColor = .lightGray
		
		let buttonStackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
		buttonStackView.distribution = .fillEqually
		
		addSubview(buttonStackView)
		addSubview(topDivider)
		addSubview(bottomDivider)
		
		buttonStackView.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
		topDivider.anchor(top: buttonStackView.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
		bottomDivider.anchor(top: buttonStackView.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - Actions
	
	@objc func handleEditProfileFollowTapped() {
		
	}
	
	private func configure() {
		guard let viewModel = viewModel else { return }
		
		nameLabel.text = viewModel.fullname
		profileImageView.sd_setImage(with: viewModel.profileImageUrl)
	}
	
	// MARK: - Helpers
	
	func attributedStatText(value: Int, label: String) -> NSAttributedString {
		let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: label,
																						 attributes: [.font: UIFont.systemFont(ofSize: 14),
																													.foregroundColor: UIColor.lightGray]))
		return attributedText
	}
}
