//
//  PostService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/25/21.
//

import UIKit
import Firebase

struct PostService {

	static func uploadPost(caption: String,
												 image: UIImage,
												 user: User,
												 completion: @escaping (FirestoreCompletion)) {
		guard let uid = Auth.auth().currentUser?.uid else { return }

		ImageUploader.uploadImage(image: image) { result in

			switch result {
			case .success(let imageURL):
				let data = ["caption": caption,
										"timestamp": Timestamp(date: Date()),
										"likes": 0,
										"image_url": imageURL,
										"owner_uid": uid,
										"owner_image_url": user.profileImageUrl ?? "",
										"owner_username": user.username] as [String: Any]

				COLLECTION_POSTS.addDocument(data: data, completion: completion)

			case .failure(let error):
				completion(error)
			}
		}
	}

	static func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
		COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
			guard let documents = snapshot?.documents else { return }

			if let error = error {
				completion(nil, error)
				return
			}

			let posts = documents.map({ Post(postID: $0.documentID, dictionary: $0.data())})
			completion(posts, nil)
		}
	}

	static func fetchPosts(forUser uid: String, completion: @escaping ([Post]) -> Void) {
		let query = COLLECTION_POSTS.whereField("owner_uid", isEqualTo: uid)

		query.getDocuments { (snapshot, _) in
			guard let documents = snapshot?.documents else { return }

			var posts = documents.map { Post(postID: $0.documentID, dictionary: $0.data())}

			posts.sort { $0.timestamp.seconds > $1.timestamp.seconds }
			completion(posts)
		}
	}

	static func fetchPost(withPostID postID: String, completion: @escaping (Post) -> Void) {
		COLLECTION_POSTS.document(postID).getDocument { (snapshot, _) in
			guard let snapshot = snapshot else { return }
			guard let data = snapshot.data() else { return }
			let post = Post(postID: snapshot.documentID, dictionary: data)
			completion(post)
		}
	}

	static func likePost(post: Post, completion: @escaping (FirestoreCompletion)) {
		guard let uid = Auth.auth().currentUser?.uid else { return }

		COLLECTION_POSTS
			.document(post.postID)
			.updateData(["likes": post.likes + 1])

		// add users who like the post in "post" collection.
		COLLECTION_POSTS
			.document(post.postID).collection("post-likes")
			.document(uid)
			.setData([:]) { _ in

				// add post IDs of post that have been liked by the user in "user" collection.
				COLLECTION_USERS.document(uid)
					.collection("user-likes")
					.document(post.postID)
					.setData([:], completion: completion)
			}
	}

	static func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		guard post.likes > 0 else { return }

		COLLECTION_POSTS
			.document(post.postID)
			.updateData(["likes": post.likes - 1])

		// delete the uid that is inside "post" collection. Use to unlike a post.
		COLLECTION_POSTS
			.document(post.postID)
			.collection("post-likes")
			.document(uid)
			.delete { (_) in

				// delete post id that is inside "users" collection.
				COLLECTION_USERS
					.document(uid)
					.collection("user-likes")
					.document(post.postID)
					.delete(completion: completion)
			}
	}

	static func checkIfUserLikedPost(post: Post, completion: @escaping(Bool) -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }

		COLLECTION_USERS
			.document(uid)
			.collection("user-likes")
			.document(post.postID)
			.getDocument { (snapshot, _) in
				guard let didLike = snapshot?.exists else { return }
				completion(didLike)
			}
	}

	static func fetchFeedPosts(completion: @escaping([Post]) -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		var posts = [Post]()
		COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, _ in
			guard let documents = snapshot?.documents else { return }

			documents.forEach { document in
				fetchPost(withPostID: document.documentID) { post in
					posts.append(post)
				}
				completion(posts)
			}
		}
	}

	static func updateUserFeedAfterFollowing(user: User) {
		guard let uid = Auth.auth().currentUser?.uid else { return }

		// Get all post based on uid in owner_uid field.
		let query = COLLECTION_POSTS.whereField("owner_uid", isEqualTo: user.uid)
		query.getDocuments { (snapshot, _) in
			guard let documents = snapshot?.documents else { return }

			// Get all doc IDs from user posts.
			let docIDs = documents.map({ $0.documentID })

			// Upload all doc IDs of user's post to user's user-feed collection.
			docIDs.forEach { id in
				COLLECTION_USERS
					.document(uid)
					.collection("user-feed")
					.document(id)
					.setData([:])
			}

		}
	}

}
