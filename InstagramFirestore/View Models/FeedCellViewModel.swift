//
//  FeedViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/25/21.
//

import Foundation

struct FeedCellViewModel {
	
	private let post: Post
	
	var postImageURL: URL? { return URL(string: post.imageURL) }
	
	var likesCount: String { return String(post.likes) }
	
	var caption: String { return post.caption }
	
//	var timestamp: String {
//		return "\(post.timestamp)"
//	}
	
	init(post: Post) {
		self.post = post
	}
}
