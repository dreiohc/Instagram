//
//  FeedViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/25/21.
//

import Foundation

struct PostViewModel {

	var post: Post

	var postImageURL: URL? { return URL(string: post.imageURL) }

	var userProfileImageURL: URL? { return URL(string: post.ownerImageURL) }

	var username: String { return post.ownerUsername }

	var caption: String { return post.caption }

	var likesLabelText: String {
		if post.likes != 1 {
			return "\(post.likes) likes"
		} else {
			return "\(post.likes) like"
		}
	}

	init(post: Post) {
		self.post = post
	}

}
