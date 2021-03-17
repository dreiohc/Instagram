//
//  ImageUploader.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import FirebaseStorage

struct ImageUploader {
	
	static func uploadImage(image: UIImage?, completion: @escaping (Result<String, NetworkError>) -> Void) {
		
		guard let imageData = image?.jpegData(compressionQuality: 0.75) else {
			completion(.failure(.failedToUploadImage))
			return
		}
		
		let fileName = NSUUID().uuidString
		let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
		ref.putData(imageData, metadata: nil) { metadata, error in
			guard error == nil else {
				completion(.failure(.failedToUploadImage))
				return
			}
			
			ref.downloadURL { url, error in
				guard let imageURL = url?.absoluteString else { return }
				completion(.success(imageURL))
			}
		}
		
	}
}
