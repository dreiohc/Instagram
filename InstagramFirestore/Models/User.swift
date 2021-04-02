//
//  User.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/18/21.
//

import UIKit
import Firebase

struct User: Codable {

	let email: String
	let fullname: String
	let username: String
	let profileImageUrl: String?
	let uid: String
	var isFollowed: Bool = false
	var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
	var stats: UserStats?

	enum CodingKeys: String, CodingKey {
		case email
		case fullname
		case username
		case uid
		case profileImageUrl = "profile_image_url"
	}
}

extension User: Hashable {
	static func == (lhs: User, rhs: User) -> Bool {
		return
			lhs.isCurrentUser == rhs.isCurrentUser &&
			lhs.isFollowed == rhs.isFollowed &&
			lhs.email == rhs.email &&
			lhs.fullname == rhs.fullname &&
			lhs.profileImageUrl == rhs.profileImageUrl &&
			lhs.stats == rhs.stats &&
			lhs.isCurrentUser == rhs.isCurrentUser &&
			lhs.uid == rhs.uid
	}
}

struct UserStats: Hashable {
	let followers: Int
	let following: Int
	let posts: Int
}
