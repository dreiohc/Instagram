//
//  MockAuthService.swift
//  InstagramFirestoreTest
//
//  Created by Myron Dulay on 3/26/21.
//

import Foundation
import Firebase
@testable import InstagramFirestore

class MockAuthService {

	var shouldReturnError = false
	var loginWasCalled = false

	func reset() {
		shouldReturnError = false
		loginWasCalled = false
	}

	convenience init() {
		self.init(false)
	}

	init(_ shouldReturnError: Bool) {
		self.shouldReturnError = shouldReturnError
	}

}

extension MockAuthService: AuthServiceProtocol {

	static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {

	}

}
