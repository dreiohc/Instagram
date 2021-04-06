//
//  NotificationViewModel.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/6/21.
//

import UIKit

struct NotificationViewModel {

	var notification: Notification

	init(notification: Notification) {
		self.notification = notification
	}

	var postImageURL: URL? { return URL(string: notification.postImageURL ?? "") }

	var profileImageURL: URL? { return URL(string: notification.userProfileImageURL)}

	var notificationMessage: NSAttributedString {
		let username = notification.username
		let message = notification.type.notificationMessage

		let attributedText = NSMutableAttributedString(string: username,
																										 attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])

		attributedText.append(NSAttributedString(string: message,
																						 attributes: [.font: UIFont.systemFont(ofSize: 14)]))

		attributedText.append(NSAttributedString(string: "  2m",
																						 attributes: [.font: UIFont.systemFont(ofSize: 12),
																													.foregroundColor: UIColor.lightGray]))

		return attributedText
	}

	var shouldHidePostImage: Bool { return self.notification.type == .follow }

	var followButtonText: String { return notification.userIsFollowed ? "Following" : "Follow" }

	var followButtonBackgroundColor: UIColor {
		return notification.userIsFollowed ? .white : .systemBlue
	}

	var followButtonTextColor: UIColor {
		return notification.userIsFollowed ? .black : .white
	}

}
