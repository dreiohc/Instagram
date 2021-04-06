//
//  NotificationController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

private typealias NotificationDataSource = UITableViewDiffableDataSource<NotificationController.Section, Notification>
private typealias NotificationSnapshot = NSDiffableDataSourceSnapshot<NotificationController.Section, Notification>

class NotificationController: UITableViewController {

	// MARK: - Properties

	private var dataSource: NotificationDataSource!

	private var notifications = [Notification]() {
		didSet { createSnapshot(from: notifications) }
	}

	private let refresher = UIRefreshControl()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		configureDataSource()
		fetchNotifications()
	}

	// MARK: - API

	private func fetchNotifications() {
		NotificationService.fetchNotifications { [weak self] notifications in
			self?.notifications = notifications
			self?.checkIfUserIsFollowed()
		}
	}

	func checkIfUserIsFollowed() {
		self.notifications.forEach { notification in
			guard notification.type == .follow else { return }

			UserService.checkIfUserIsFollowed(uid: notification.uid) { [weak self] isFollowed in
				if let index = self?.notifications.firstIndex(where: { $0.id == notification.id }) {
					self?.notifications[index].userIsFollowed = isFollowed
				}
			}
		}
	}

	// MARK: - Actions

	@objc func handleRefresh() {
		fetchNotifications()
		refresher.endRefreshing()
	}

	// MARK: - Helpers

	private func configureTableView() {
		view.backgroundColor = .white
		navigationItem.title = "Notifications"

		tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
		tableView.rowHeight = 80
		tableView.separatorStyle = .none

		refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		tableView.refreshControl = refresher
	}
}

// MARK: - UITableViewDataSource

extension NotificationController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return notifications.count
	}

	private func configureDataSource() {
		dataSource = NotificationDataSource(tableView: tableView) { (tableView, indexPath, _) -> UITableViewCell? in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NotificationCell else {
				fatalError()
			}
			cell.delegate = self
			cell.viewModel = NotificationViewModel(notification: self.notifications[indexPath.row])
			return cell
		}
	}

	private func createSnapshot(from notifications: [Notification]) {
		var snapshot = NotificationSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(notifications)
		dataSource.apply(snapshot, animatingDifferences: false)
	}
}

	// MARK: - UITableViewDelegate

extension NotificationController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let uid = notifications[indexPath.row].uid
		showLoader(true)
		UserService.fetchUser(withUid: uid) { [weak self] user in
			self?.showLoader(false)
			let controller = ProfileController(user: user)
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}
}

  // MARK: - Sections

extension NotificationController {
	fileprivate enum Section {
		case main
	}
}

	// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {

	func cell(_ cell: NotificationCell, wantsToFollow uid: String) {
		showLoader(true)
		UserService.follow(uid: uid) { error in
			self.showLoader(false)
			if let error = error {
				print("DEBUG: Error trying to follow user \(error.localizedDescription)")
				return
			}
			cell.viewModel?.notification.userIsFollowed.toggle()
		}
	}

	func cell(_ cell: NotificationCell, wantsToUnfollow uid: String) {
		showLoader(true)
		UserService.unfollow(uid: uid) { error in
			self.showLoader(false)
			if let error = error {
				print("DEBUG: Error trying to unfollow user \(error.localizedDescription)")
				return
			}
			cell.viewModel?.notification.userIsFollowed.toggle()
		}
	}

	func cell(_ cell: NotificationCell, wantsToViewPost postID: String) {
		showLoader(true)
		PostService.fetchPost(withPostID: postID) { [weak self] post in
			self?.showLoader(false)
			let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
			controller.post = post
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}

}
