//
//  CommentController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 4/1/21.
//

import UIKit

private let reuseIdentifier = "CommentCell"

class CommentController: UICollectionViewController {

	// MARK: - Properties

	private let post: Post
	private var comments = [Comment]()

	private lazy var commentInputView: CommentInputAccessoryView = {
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		let cv = CommentInputAccessoryView(frame: frame)
		cv.delegate = self
		return cv
	}()

	// MARK: - Lifecycle

	init(post: Post) {
		self.post = post
		super.init(collectionViewLayout: UICollectionViewFlowLayout())
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
		fetchComments()
	}

	override var inputAccessoryView: UIView? {
		return commentInputView
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.tabBarController?.tabBar.isHidden = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.tabBarController?.tabBar.isHidden = false
	}

	// MARK: - API

	func fetchComments() {
		CommentService.fetchComments(forPost: post.postID) { [weak self] comments in
			self?.comments = comments
			self?.collectionView.reloadData()
		}
	}

	// MARK: - Actions

	// MARK: - Helpers

	private func configureCollectionView() {
		navigationItem.title = "Comments"
		collectionView.backgroundColor = .white
		collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		collectionView.alwaysBounceVertical = true
		collectionView.keyboardDismissMode = .interactive
	}

}

// MARK: - UICollectionViewDataSource

extension CommentController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return comments.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CommentCell else { fatalError() }
		cell.viewModel = CommentViewModel(comment: comments[indexPath.row])
		return cell
	}
}

// MARK: - UICollectionViewDelegate

extension CommentController {
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let uid = comments[indexPath.row].uid
		UserService.fetchUser(withUid: uid) { [weak self] user in
			let controller = ProfileController(user: user)
			self?.navigationController?.pushViewController(controller, animated: true)
		}
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let viewModel = CommentViewModel(comment: comments[indexPath.row])
		let height = viewModel.size(forWidth: view.frame.width).height + 32
		return CGSize(width: view.frame.width, height: height)
	}
}

// MARK: - CommentInputAccessoryViewDelegate

extension CommentController: CommentInputAccessoryViewDelegate {
	func inputView(_ inputView: CommentInputAccessoryView, wantsToUploadComment comment: String) {
		guard let tab = self.tabBarController as? MainTabController else { return }
		guard let currentUser = tab.user else { return }

		showLoader(true)

		CommentService.uploadComment(comment: comment, postID: post.postID, user: currentUser) { [weak self] _ in
			self?.showLoader(false)
			inputView.clearCommentsTextView()

			NotificationService.uploadNotification(toUid: self?.post.ownerUID ?? "", fromUser: currentUser, type: .comment, post: self?.post)
		}
	}

}
