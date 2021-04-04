//
//  ProfileHeaderViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/18/21.
//

import UIKit

struct ProfileHeaderViewModel {

	let user: User

	private let userStats: UserStats?

	var fullname: String {
		return user.fullname
	}

	var profileImageUrl: URL? {
		return URL(string: user.profileImageUrl ?? "")
	}

	var followButtonText: String {
		if user.isCurrentUser {
			return "Edit Profile"
		}

		return user.isFollowed ? "Following" : "Follow"
	}

	var followButtonBackgroundColor: UIColor {
		return user.isCurrentUser ? .white : .systemBlue
	}

	var followButtonTextColor: UIColor {
		return user.isCurrentUser ? .black : .white
	}

	var numberOfFollowers: NSAttributedString {
		return attributedStatText(value: userStats?.followers ?? 0, label: "followers")
	}

	var numberOfFollowing: NSAttributedString {
		return attributedStatText(value: userStats?.following ?? 0, label: "following")
	}

	var numberOfPosts: NSAttributedString {
		return attributedStatText(value: userStats?.posts ?? 0, label: "posts")
	}

	init(user: User) {
		self.user = user
		self.userStats = user[keyPath: \User.stats?]
	}

	func attributedStatText(value: Int, label: String) -> NSAttributedString {
		let attributedText = NSMutableAttributedString(string: "\(value)\n", attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
		attributedText.append(NSAttributedString(string: label,
																						 attributes: [.font: UIFont.systemFont(ofSize: 14),
																													.foregroundColor: UIColor.lightGray]))
		return attributedText
	}

}
