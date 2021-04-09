//
//  FeedViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/25/21.
//

import UIKit

struct PostViewModel {

	var post: Post

	var postImageURL: URL? { return URL(string: post.imageURL) }

	var userProfileImageURL: URL? { return URL(string: post.ownerImageURL) }

	var username: String { return post.ownerUsername }

	var caption: String { return post.caption }

	var likes: Int { return post.likes }

	var likeButtonTintColor: UIColor { return post.didLike ? .systemRed : .black }

	var likeButtomImage: UIImage? {
		let imageName = post.didLike ? "like_selected" : "like_unselected"
		return UIImage(named: imageName)
	}

	var likesLabelText: String {
		if post.likes != 1 {
			return "\(post.likes) likes"
		} else {
			return "\(post.likes) like"
		}
	}
  
  var timestampString: String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.second, .minute, .hour, .day, .weekday]
    formatter.maximumUnitCount = 1
    formatter.unitsStyle = .full
    return formatter.string(from: post.timestamp.dateValue(), to: Date())
  }

	init(post: Post) {
		self.post = post
	}

}
