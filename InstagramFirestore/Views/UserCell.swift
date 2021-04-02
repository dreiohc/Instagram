//
//  UserCell.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/23/21.
//

import UIKit

class UserCell: UITableViewCell {

	// MARK: - Properties

	var viewModel: UserCellViewModel? {
		didSet {
			configure()
		}
	}

	private let profileImageView: UIImageView = {
		let iv = UIImageView()
		iv.contentMode = .scaleAspectFill
		iv.clipsToBounds = true
		iv.backgroundColor = .lightGray
		iv.image = #imageLiteral(resourceName: "venom-7")
		return iv
	}()

	private let usernameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 14)
		label.text = "venom"
		return label
	}()

	private let fullnameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.text = "Eddie Brock"
		return label
	}()

	// MARK: - Lifecycle

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Helpers

	private func setupUI() {
		addSubview(profileImageView)
		profileImageView.setDimensions(height: 48, width: 48)
		profileImageView.layer.cornerRadius = 24
		profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)

		let stackView = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
		stackView.axis = .vertical
		stackView.spacing = 4
		stackView.alignment = .leading

		addSubview(stackView)
		stackView.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
	}

	private func configure() {
		guard let viewModel = viewModel else { return }
		profileImageView.sd_setImage(with: viewModel.profileImageUrl)
		usernameLabel.text = viewModel.username
		fullnameLabel.text = viewModel.fullname
	}
}
