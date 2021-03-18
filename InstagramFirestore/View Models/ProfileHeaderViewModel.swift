//
//  ProfileHeaderViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/18/21.
//

import Foundation

struct ProfileHeaderViewModel {
	
	let user: User
	
	var fullname: String {
		return user.fullname
	}
	
	var profileImageUrl: URL? {
		return URL(string: user.profileImageUrl)
	}
	
	init(user: User) {
		self.user = user
	}
	
}
