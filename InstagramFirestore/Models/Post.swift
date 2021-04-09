//
//  Post.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/25/21.
//

import Firebase

struct Post: Hashable {
	var caption: String
	var likes: Int
	let imageURL: String
	let ownerUID: String
	let timestamp: Timestamp
	let postID: String
	let ownerImageURL: String
	let ownerUsername: String
	var didLike = false

	init(postID: String, dictionary: [String: Any]) {
		self.caption = dictionary["caption"] as? String ?? ""
		self.likes = dictionary["likes"] as? Int ?? 0
		self.imageURL = dictionary["image_url"] as? String ?? ""
		self.ownerUID = dictionary["owner_uid"] as? String ?? ""
		self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
		self.postID = postID
		self.ownerImageURL = dictionary["owner_image_url"] as? String ?? ""
		self.ownerUsername = dictionary["owner_username"] as? String ?? ""
	}
}
