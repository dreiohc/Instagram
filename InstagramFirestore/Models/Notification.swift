//
//  Notification.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/5/21.
//

import Firebase

enum NotificationType: Int {
	case like
	case follow
	case comment

	var notificationMessage: String {
		switch self {
		case .like: return " liked your post."
		case .follow: return " started following you."
		case .comment: return " commented on your post."
		}
	}
}

struct Notification: Hashable {
	let uid: String
	let postImageURL: String?
	let postID: String
	let timestamp: Timestamp
	let type: NotificationType
	let id: String
	let userProfileImageURL: String
	let username: String
	var userIsFollowed = false

	init(dictionary: [String: Any]) {
		self.postID = dictionary["post_id"] as? String ?? ""
		self.postImageURL = dictionary["post_image_url"] as? String ?? ""
		self.uid = dictionary["uid"] as? String ?? ""
		self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
		self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
		self.id = dictionary["id"] as? String ?? ""
		self.userProfileImageURL = dictionary["user_profile_image_url"] as? String ?? ""
		self.username = dictionary["username"] as? String ?? ""
	}
}
