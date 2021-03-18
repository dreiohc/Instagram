//
//  UserService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/18/21.
//

import Firebase
import FirebaseFirestoreSwift

struct UserService {
	
	static func fetchUser(completion: @escaping (User) -> Void) {
		guard let uid = Auth.auth().currentUser?.uid else { return }
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
	
}
