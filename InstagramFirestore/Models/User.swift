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
	
	enum CodingKeys: String, CodingKey {
		case email
		case fullname
		case username
		case uid
		case profileImageUrl = "profile_image_url"
	}
	
}
