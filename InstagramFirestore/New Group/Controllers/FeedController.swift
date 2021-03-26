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
	
	private var post = [Post]()
	
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
	
	// MARK: - API
	
	private func fetchPosts() {
		
		showLoader(true)
		PostService.fetchPosts { [weak self] (post, error) in
			self?.showLoader(false)
			if let error = error {
				print("DEBUG: error fetching post in controller \(error)")
				return
			}
			guard let post = post else { return }
			
			self?.post = post
			self?.collectionView.reloadData()
		}
	}
	
	// MARK: - Helpers
	
	func configureUI() {
		collectionView.backgroundColor = .white
		collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
																											 style: .plain,
																											 target: self,
																											 action: #selector(handleLogout))
		navigationItem.title = "Feed"
	}
	
}

// MARK: - UICollectionViewDataSource

extension FeedController {
	
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return post.count
	}
	
	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
		let post = self.post[indexPath.row]
		cell.viewModel = FeedCellViewModel(post: post)
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
