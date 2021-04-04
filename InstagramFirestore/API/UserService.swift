//
//  UserService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/18/21.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {

	static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
		COLLECTION_USERS.document(uid).getDocument { snapshot, error in

			guard let snapshot = snapshot else { return }

			do {
				if let user = try snapshot.data(as: User.self, decoder: nil) {
					completion(user)
				}
			} catch let error {
				print("DEBUG: Failed to fetch user: \(error)")
				return
			}
		}
	}

	static func follow(uid: String, completion: @escaping (FirestoreCompletion)) {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }

		COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).setData([:]) { error in

			if let error = error {
				completion(error)
				return
			}

			COLLECTION_FOLLOWERS
				.document(uid)
				.collection("user-followers")
				.document(currentUid)
				.setData([:], completion: completion)
		}
	}

	static func unfollow(uid: String, completion: @escaping (FirestoreCompletion)) {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }

		COLLECTION_FOLLOWING.document(currentUid).collection("user-following").document(uid).delete { error in

			if let error = error {
				completion(error)
				return
			}

			COLLECTION_FOLLOWERS
				.document(uid)
				.collection("user-followers")
				.document(currentUid)
				.delete(completion: completion)
		}
	}

	static func fetchUsers(completion: @escaping([User]) -> Void) {
		COLLECTION_USERS.getDocuments { snapshot, error in
			guard let snapshot = snapshot else { return }

			do {
				let documentsDic = snapshot.documents.map({ $0.data() })
				let data = try JSONSerialization.data(withJSONObject: documentsDic, options: .prettyPrinted)
				let users = try JSONDecoder().decode([User].self, from: data)
				completion(users)
			} catch let error {
				print("DEBUG: fetching users \(error.localizedDescription)")
				return
			}
		}
	}

	static func checkIfUserIsFollowed(uid: String, completion: @escaping (Bool) -> Void) {
		guard let currentUid = Auth.auth().currentUser?.uid else { return }

		COLLECTION_FOLLOWING
			.document(currentUid)
			.collection("user-following")
			.document(uid)
			.getDocument { (snapshot, _) in
			guard let isFollowed = snapshot?.exists else { return }
			completion(isFollowed)
		}
	}

	static func fetchUserStats(uid: String, completion: @escaping (UserStats) -> Void) {
		COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
			let followers = snapshot?.documents.count ?? 0

			COLLECTION_FOLLOWING.document(uid).collection("user-following").getDocuments { (snapshot, _) in
				let following = snapshot?.documents.count ?? 0
				COLLECTION_POSTS.whereField("owner_uid", isEqualTo: uid).getDocuments { (snapshot, _) in
					let posts = snapshot?.documents.count ?? 0
					completion(UserStats(followers: followers, following: following, posts: posts))
				}

			}
		}
	}

}
