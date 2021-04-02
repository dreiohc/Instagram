//
//  SearchController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit

private let reuseIdentifier = "UserCell"

private typealias UserDataSource = UITableViewDiffableDataSource<SearchController.Section, User>
private typealias UsersSnapshot = NSDiffableDataSourceSnapshot<SearchController.Section, User>

class SearchController: UITableViewController {

	// MARK: - Properties

	private var users = [User]()

	private var filteredUsers = [User]()

	private let searchController = UISearchController(searchResultsController: nil)

	private var inSearchMode: Bool {
		return searchController.isActive && !searchController.searchBar.text!.isEmpty
	}

	private var dataSource: UserDataSource!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureSearchController()
		configureDataSource()
		configureTableView()
		fetchUsers()
	}

	// MARK: - API

	private func fetchUsers() {
		showLoader(true)
		UserService.fetchUsers { [weak self] users in
			self?.showLoader(false)
			self?.users = users
			self?.createSnapshot(from: users)
		}
	}

	// MARK: - Helpers

	private func configureTableView() {
		view.backgroundColor = .white
		tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
		tableView.rowHeight = 64
	}

	private func configureDataSource() {
		dataSource = UserDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell else { fatalError() }
			let user = self.inSearchMode ? self.filteredUsers[indexPath.row] : self.users[indexPath.row]
			cell.viewModel = UserCellViewModel(user: user)
			return cell
		})
	}

	private func configureSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
		searchController.searchBar.placeholder = "Search"
		navigationItem.searchController = searchController
		definesPresentationContext = false
	}

	private func createSnapshot(from users: [User]) {
		var snapshot = UsersSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(users)
		dataSource.apply(snapshot, animatingDifferences: false)
	}

}

// MARK: - UITableViewDataSource

extension SearchController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return inSearchMode ? filteredUsers.count : users.count
	}
}

// MARK: - UITableViewDelegate

extension SearchController {
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let nonFilteredUser = dataSource.itemIdentifier(for: indexPath) else { return }
		let user = inSearchMode ? self.filteredUsers[indexPath.row] : nonFilteredUser
		let controller = ProfileController(user: user)
		navigationController?.pushViewController(controller, animated: true)
	}
}

// MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let searchText = searchController.searchBar.text?.lowercased() else { return }

		filteredUsers = users.filter({$0.username.lowercased().contains(searchText)
																		|| $0.fullname.lowercased().contains(searchText) })

		let users = searchText.isEmpty ? self.users : filteredUsers

		self.createSnapshot(from: users)
	}
}

// MARK: - CollectionView Sections

extension SearchController {
	fileprivate enum Section {
		case main
	}
}
