//
//  CommentService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/3/21.
//

import Firebase

struct CommentService {

	static func uploadComment(comment: String, postID: String, user: User, completion: @escaping (FirestoreCompletion)) {
		let data: [String: Any] = ["uid": user.uid,
															 "comment": comment,
															 "timestamp": Timestamp(date: Date()),
															 "profile_image_url": user.profileImageUrl ?? ""]

		COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
	}

	static func fetchComments() {

	}

}
