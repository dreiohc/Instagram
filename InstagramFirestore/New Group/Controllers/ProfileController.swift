//
//  ProfileController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit

private let cellIdentifier = "ProfileCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {

	// MARK: - Properties

	private var user: User
	private var posts = [Post]()

	// MARK: - Lifecycle

	init(user: User) {
		self.user = user
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		checkIfUserIsFollowed()
		configureCollectionView()
		fetchUserStats()
		fetchPosts()
	}

	// MARK: - API

	private func checkIfUserIsFollowed() {
		UserService.checkIfUserIsFollowed(uid: user.uid) { [weak self] isFollowed in
			self?.user.isFollowed = isFollowed
			self?.collectionView.reloadData()
		}
	}

	private func fetchUserStats() {
		UserService.fetchUserStats(uid: user.uid) { [weak self] stats in
			self?.user.stats = stats
			self?.collectionView.reloadData()
		}
	}

	private func fetchPosts() {
		showLoader(true)
		PostService.fetchPosts(forUser: user.uid) { [weak self] posts in
			self?.showLoader(false )
			self?.posts = posts
			self?.collectionView.reloadData()
		}
	}

	// MARK: - Helpers

	func configureCollectionView() {
		navigationItem.title = user.username
		collectionView.backgroundColor = .white
		collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: cellIdentifier)
		collectionView.register(ProfileHeader.self,
														forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
														withReuseIdentifier: headerIdentifier)
	}
}

// MARK: - UICollectionViewDataSource

extension ProfileController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return posts.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ProfileCell else { fatalError() }
		let post = posts[indexPath.row]
		cell.viewModel = PostViewModel(post: post)
		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? ProfileHeader else { fatalError() }
		header.delegate = self
		header.viewModel = ProfileHeaderViewModel(user: user)

		return header
	}
}

// MARK: - UICollectionViewDelegate

extension ProfileController {

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
		controller.post = posts[indexPath.row]
		navigationController?.pushViewController(controller, animated: true)
	}

}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = (view.frame.width - 2) / 3
		return CGSize(width: width, height: width)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		return CGSize(width: view.frame.width, height: 240)
	}
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
	func header(_ profileHeader: ProfileHeader, didTapActionButtonFor user: User) {

		guard let tab = tabBarController as? MainTabController else { return }
		guard let currentUser = tab.user else { return }

		if user.isCurrentUser {
			print("DEBUG: Show edit profile here..")
		} else if user.isFollowed {
			UserService.unfollow(uid: user.uid) { [weak self] _ in
				self?.user.isFollowed = false
				self?.collectionView.reloadData()
			}
		} else {
			UserService.follow(uid: user.uid) { [weak self] _ in
				self?.user.isFollowed = true
				self?.collectionView.reloadData()

				NotificationService.uploadNotification(toUid: user.uid,
																							 fromUser: currentUser,
																							 type: .follow)

				PostService.updateUserFeedAfterFollowing(user: user)
			}

		}
	}

}
