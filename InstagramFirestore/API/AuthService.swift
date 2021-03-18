//
//  AuthService.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import UIKit
import Firebase

struct AuthCredentials {
	let email: String
	let password: String
	let fullname: String
	let username: String
	let profileImage: UIImage?
}

struct AuthService {
	
	static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
		Auth.auth().signIn(withEmail: email, password: password, completion: completion)
	}
	
	static func registerUser(withCredential credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
		
		Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
			
			if let error = error {
				print("DEBUG: Failed to register user \(error.localizedDescription)")
				return
			}
			
			guard let uid = result?.user.uid else { return }

			var data: [String: Any] = ["email": credentials.email,
																 "fullname": credentials.fullname,
																 "uid": uid,
																 "username": credentials.username]
			
			if credentials.profileImage != nil {
				
				ImageUploader.uploadImage(image: credentials.profileImage) { result in
					switch result {
					case .success(let imageURL):
						data["profile_image_url"] = imageURL
					default:
						break
					}
					COLLECTION_USERS.document(uid).setData(data, completion: completion)
					return
				}
				
			}
			COLLECTION_USERS.document(uid).setData(data, completion: completion)
		
		}
		
		
		
	}
}
