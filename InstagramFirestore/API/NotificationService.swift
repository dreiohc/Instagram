//
//  NotificationService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/5/21.
//

import Firebase

struct NotificationService {

	static func uploadNotification(toUid uid: String,
																 fromUser: User,
																 type: NotificationType,
																 post: Post? = nil) {

		guard let currentUID = Auth.auth().currentUser?.uid else { return }
		guard uid != currentUID else { return }

		let docRef =
			COLLECTION_NOTIFICATIONS
			.document(uid)
			.collection("user-notifications")
			.document()

		var data: [String: Any] = ["timestamp": Timestamp(date: Date()),
															 "uid": fromUser.uid,
															 "type": type.rawValue,
															 "id": docRef.documentID,
															 "user_profile_image_url": fromUser.profileImageUrl ?? "",
															 "username": fromUser.username]

		if let post = post {
			data["post_id"] = post.postID
			data["post_image_url"] = post.imageURL
		}
		docRef.setData(data)
	}

	static func fetchNotifications(completion: @escaping ([Notification]) -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }

      COLLECTION_NOTIFICATIONS
      .document(uid)
      .collection("user-notifications")
      .order(by: "timestamp", descending: true)
			.getDocuments { (snapshot, _) in
				guard let documents = snapshot?.documents else { return }
				let notifications = documents.map { Notification(dictionary: $0.data()) }
				completion(notifications)
		}
	}

}
