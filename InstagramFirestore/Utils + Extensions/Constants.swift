//
//  Constants.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import Firebase


let COLLECTION_USERS = Firestore.firestore().collection("users")

enum NetworkError: Error {
	case failedToUploadImage
}

