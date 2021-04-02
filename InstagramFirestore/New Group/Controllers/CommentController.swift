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

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureCollectionView()

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
