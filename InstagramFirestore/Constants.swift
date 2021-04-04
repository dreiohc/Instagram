//
//  Constants.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/17/21.
//

import Firebase

let COLLECTION_USERS = Firestore.firestore().collection("users")
let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
let COLLECTION_FOLLOWING = Firestore.firestore().collection("following")
let COLLECTION_POSTS = Firestore.firestore().collection("posts")

// MARK: - Firebase typealiases

typealias FirestoreCompletion = (Error?) -> Void

// MARK: - Error

enum NetworkError: Error {
	case failedToUploadImage
}
