//
//  InstagramFirestoreTest.swift
//  InstagramFirestoreTest
//
//  Created by Myron Dulay on 3/26/21.
//

import XCTest
import Firebase
@testable import InstagramFirestore

class InstagramFirestoreTest: XCTestCase {
	
	override func setUpWithError() throws {
		super.setUp()
	}
	
	func test_should_login_successfully() {
		let expectation = self.expectation(description: "login")
		var isLoginSuccess = false
		AuthService.logUserIn(withEmail: "shanks@gmail.com", password: "Password01") { (_, error) in
			if error == nil {
				isLoginSuccess = true
			}
			expectation.fulfill()
		}
		
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertTrue(isLoginSuccess)
	}
	
	func test_should_signout_successfully() {
		let expectation = self.expectation(description: "signout")
		var isSignOutSuccess = true
		do {
			try Auth.auth().signOut()
			expectation.fulfill()
		} catch {
				isSignOutSuccess = false
		}
		waitForExpectations(timeout: 5, handler: nil)
		XCTAssertTrue(isSignOutSuccess)
	}
	
	override func tearDownWithError() throws {
		
	}
	
}
