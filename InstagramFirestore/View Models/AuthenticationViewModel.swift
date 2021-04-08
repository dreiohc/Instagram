//
//  LoginViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/16/21.
//

import UIKit

struct LoginViewModel {

	var email: String?
	var password: String?

	var formIsValid: Bool {
		return email?.isEmpty == false && password?.isEmpty == false
	}
}

struct RegistrationViewModel {

	var email: String?
	var password: String?
	var fullName: String?
	var userName: String?

	var formIsValid: Bool {
		return email?.isEmpty == false && password?.isEmpty == false
			&& fullName?.isEmpty == false && userName?.isEmpty == false
	}

}

struct ResetPasswordViewModel {
  var email: String?
  var formIsValid: Bool { return email?.isEmpty == false }
}
