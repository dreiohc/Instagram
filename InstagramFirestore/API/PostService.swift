//
//  PostService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/25/21.
//

import UIKit
import Firebase

struct PostService {
	
	static func uploadPost(caption: String, image: UIImage, completion: @escaping (FirestoreCompletion)) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		
		ImageUploader.uploadImage(image: image) { result in
			
			switch result {
			case .success(let imageURL):
				let data = ["caption": caption,
										"timestamp": Timestamp(date: Date()),
										"likes": 0,
										"image_url": imageURL,
										"owner_uid": uid] as [String: Any]
				
				COLLECTION_POSTS.addDocument(data: data, completion: completion)
				
			case .failure(let error):
				completion(error)
			}
			
		}
	}
	
	static func fetchPosts(completion: @escaping ([Post]?, Error?) -> Void) {
		COLLECTION_POSTS.getDocuments { (snapshot, error) in
			guard let documents = snapshot?.documents else { return }
			
			if let error = error {
				completion(nil, error)
				return
			}
			
			let posts = documents.map({ Post(postID: $0.documentID, dictionary: $0.data())})
			completion(posts, nil)
			
		}
	}
}
