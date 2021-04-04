//
//  FeedController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit
import Firebase

private let reuseIdentifier = "cell"

class FeedController: UICollectionViewController {

	// MARK: - Properties

	private var posts = [Post]()
	var post: Post?

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		fetchPosts()
	}

	// MARK: - Actions

	@objc func handleLogout() {
		do {
			try Auth.auth().signOut()
			let controller = LoginController()
			controller.delegate = self.tabBarController as? MainTabController
			let nav = UINavigationController(rootViewController: controller)
			nav.modalPresentationStyle = .fullScreen
			self.present(nav, animated: true, completion: nil)
		} catch let error {
			print("DEBUG: \(error.localizedDescription)")
		}
	}

	@objc func handleRefresh() {
		posts.removeAll()
		fetchPosts()
	}

	// MARK: - API

	private func fetchPosts() {

		showLoader(true)
		guard self.post == nil else {
			showLoader(false)
			return
		}

		PostService.fetchPosts { [weak self] (posts, error) in
			self?.showLoader(false)
			self?.collectionView.refreshControl?.endRefreshing()

			if let error = error {
				print(error.localizedDescription)
				return
			}

			guard let posts = posts else { return }

			self?.posts = posts
			self?.collectionView.reloadData()
		}
	}

	// MARK: - Helpers

	func configureUI() {
		collectionView.backgroundColor = .white
		collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		navigationItem.title = "Feed"

		if post == nil {
			navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
																												 style: .plain,
																												 target: self,
																												 action: #selector(handleLogout))
		}

		let refresher = UIRefreshControl()
		refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
		collectionView.refreshControl = refresher
	}

}

// MARK: - UICollectionViewDataSource

extension FeedController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return post == nil ? posts.count : 1
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeedCell else { fatalError() }
		cell.delegate = self
		if let post = post {
			cell.viewModel = PostViewModel(post: post)

		} else {
			cell.viewModel = PostViewModel(post: posts[indexPath.row])
		}

		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

		let width = view.frame.width
		let height = width + 166

		return CGSize(width: width, height: height)
	}

}

// MARK: - FeedCellDelegate

extension FeedController: FeedCellDelegate {

	func cell(_ cell: FeedCell, didLike post: Post) {
		cell.viewModel?.post.didLike.toggle()
		if post.didLike {

		} else {
			PostService.likePost(post: post) { error in
				if let error = error {
					print("DEBUG: failed to like post \(error.localizedDescription)")
					return
				}
				cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
				cell.likeButton.tintColor = .systemRed
			}
		}
	}

	func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
		let controller = CommentController(post: post)
		navigationController?.pushViewController(controller, animated: true)
	}

}
