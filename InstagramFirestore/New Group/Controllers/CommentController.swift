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

	private lazy var commentInputView: CommentInputAccessoryView = {
		let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
		let cv = CommentInputAccessoryView(frame: frame)
		return cv
	}()

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()
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

	// MARK: - Actions

	// MARK: - Helpers

	private func configureCollectionView() {
		navigationItem.title = "Comments"
		collectionView.backgroundColor = .white
		collectionView.register(CommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
	}

}

// MARK: - UICollectionViewDataSource

extension CommentController {

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CommentCell else { fatalError() }

		return cell
	}
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CommentController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width, height: 80)
	}
}
