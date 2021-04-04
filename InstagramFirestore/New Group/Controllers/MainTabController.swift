//
//  MainTabController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {

	// MARK: - Properties

	var user: User? {
		didSet {
			guard let user = user else { return }
			configureViewControllers(withUser: user) }
	}

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		checkIfUserIsLoggedIn()
		fetchUser()
	}

	// MARK: - API

	private func fetchUser() {
		guard let uid = Auth.auth().currentUser?.uid else { return }
		UserService.fetchUser(withUid: uid) { [weak self] user in
			self?.user = user
		}
	}

	func checkIfUserIsLoggedIn() {
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let controller = LoginController()
				controller.delegate = self
				let nav = UINavigationController(rootViewController: controller)
				nav.modalPresentationStyle = .fullScreen
				self.present(nav, animated: true, completion: nil)
			}
		}
	}

	// MARK: - Helpers

	func configureViewControllers(withUser user: User) {

		view.backgroundColor = .white
		self.delegate = self

		let feedLayout = UICollectionViewFlowLayout()
		let profileController = ProfileController(user: user)

		let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),
																						selectedImage: #imageLiteral(resourceName: "home_selected"),
																						rootViewController: FeedController(collectionViewLayout: feedLayout))

		let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"),
																							selectedImage: #imageLiteral(resourceName: "search_selected"),
																						 rootViewController: SearchController())

		let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"),
																										 selectedImage: #imageLiteral(resourceName: "plus_unselected"),
																										 rootViewController: ImageSelectorController())

		let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"),
																										 selectedImage: #imageLiteral(resourceName: "like_selected"),
																										 rootViewController: NotificationController())

		let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"),
																							 selectedImage: #imageLiteral(resourceName: "profile_selected"),
																							rootViewController: profileController)

		viewControllers = [feed, search, imageSelector, notifications, profile]

		tabBar.tintColor = .black

	}

	func templateNavigationController(unselectedImage: UIImage,
																		selectedImage: UIImage,
																		rootViewController: UIViewController) -> UINavigationController {

		let navVC = UINavigationController(rootViewController: rootViewController)
		navVC.tabBarItem.image = unselectedImage
		navVC.tabBarItem.selectedImage = selectedImage
		navVC.navigationBar.tintColor = .black
		return navVC

	}

	private func didfinishPickingMedia(_ picker: YPImagePicker) {
		picker.didFinishPicking { items, _ in
			picker.dismiss(animated: false) {
				guard let selectedImage = items.singlePhoto?.image else { return }

				let controller = UploadPostController()
				controller.selectedImage = selectedImage
				controller.delegate = self
				controller.currentUser = self.user
				let nav = UINavigationController(rootViewController: controller)
				nav.modalPresentationStyle = .fullScreen
				self.present(nav, animated: false, completion: nil)
			}
		}
	}
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
	func authenticationComplete() {
		fetchUser()
		self.dismiss(animated: true, completion: nil)
	}
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		let index = viewControllers?.firstIndex(of: viewController)

		if index == 2 {
			var config = YPImagePickerConfiguration()
			config.library.mediaType = .photo
			config.shouldSaveNewPicturesToAlbum = false
			config.startOnScreen = .library
			config.screens = [.library]
			config.hidesStatusBar = false
			config.library.maxNumberOfItems = 1

			let picker = YPImagePicker(configuration: config)
			picker.modalPresentationStyle = .fullScreen
			present(picker, animated: true, completion: nil)

			didfinishPickingMedia(picker)
		}
		return true
	}
}

// MARK: - UploadPostControllerDelegate

extension MainTabController: UploadPostControllerDelegate {
	func controllerDidFinishUploadingPost(_ controller: UploadPostController) {
		guard let feedNav = viewControllers?.first as? UINavigationController else { return }
		guard let feed = feedNav.viewControllers.first as? FeedController else { return }
		selectedIndex = 0
		feed.handleRefresh()
		controller.dismiss(animated: true, completion: nil)
	}
}
