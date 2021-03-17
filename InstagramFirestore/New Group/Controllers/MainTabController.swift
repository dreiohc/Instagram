//
//  MainTabController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
	
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureViewControllers()
		checkIfUserIsLoggedIn()
	}
	
	// MARK: - API
	
	func checkIfUserIsLoggedIn() {
		if Auth.auth().currentUser == nil {
			DispatchQueue.main.async {
				let controller = LoginController()
				let nav = UINavigationController(rootViewController: controller)
				nav.modalPresentationStyle = .fullScreen
				self.present(nav, animated: true, completion: nil)
			}
		}
	}
	
	// MARK: - Helpers
	
	func configureViewControllers() {
		
		view.backgroundColor = .white
	
		let layout = UICollectionViewFlowLayout()
		let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"),
																						selectedImage: #imageLiteral(resourceName: "home_selected"),
																						rootViewController: FeedController(collectionViewLayout: layout))
		
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
																							rootViewController: ProfileController())
		
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
	
}
