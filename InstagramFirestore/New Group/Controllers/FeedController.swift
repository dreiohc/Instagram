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

	private var posts = [Post]() {
		didSet { collectionView.reloadData() }
	}

  var post: Post? {
    didSet { collectionView.reloadData() }
  }

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
		fetchPosts()
    
    if post != nil {
      checkIfUserLikedPosts()
    }
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
      collectionView.refreshControl?.endRefreshing()
      return
    }
    PostService.fetchFeedPosts { [weak self] posts in
      self?.showLoader(false)
      self?.collectionView.refreshControl?.endRefreshing()
      self?.posts = posts
      self?.checkIfUserLikedPosts()
    }
    
  }

	private func checkIfUserLikedPosts() {
    
    if let post = post {
      PostService.checkIfUserLikedPost(post: post) { [weak self] didLike in
        self?.post?.didLike = didLike
      }
    } else {
      self.posts.forEach { post in
        PostService.checkIfUserLikedPost(post: post) { [weak self] didLike in
          if let index = self?.posts.firstIndex(where: { $0.postID == post.postID }) {
            self?.posts[index].didLike = didLike
          }
        }
      }
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

	func cell(_ cell: FeedCell, wantsToShowProfileFor uid: String) {
		UserService.fetchUser(withUid: uid) { [weak self] user in
			let controller = ProfileController(user: user)
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}

	func cell(_ cell: FeedCell, didLike post: Post) {

		guard let tab = tabBarController as? MainTabController else { return }
		guard let user = tab.user else { return }

		cell.viewModel?.post.didLike.toggle()
		if post.didLike {
			PostService.unlikePost(post: post) { error in
				if let error = error {
					print("DEBUG: failed to unlike post \(error.localizedDescription)")
					return
				}
				cell.viewModel?.post.likes = post.likes - 1
			}
		} else {
			PostService.likePost(post: post) { error in
				if let error = error {
					print("DEBUG: failed to like post \(error.localizedDescription)")
					return
				}
				cell.viewModel?.post.likes = post.likes + 1

				NotificationService.uploadNotification(toUid: post.ownerUID,
																							 fromUser: user,
																							 type: .like,
																							 post: post)
			}
		}
	}

	func cell(_ cell: FeedCell, wantsToShowCommentsFor post: Post) {
		let controller = CommentController(post: post)
		navigationController?.pushViewController(controller, animated: true)
	}

}
