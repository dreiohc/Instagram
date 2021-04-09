//
//  SearchController.swift
//  InstagramFirestore
//
//  Created by Myron Dulay on 3/15/21.
//

import UIKit

private let reuseIdentifier = "UserCell"
private let postCellIdentifier = "ProfileCell"

private typealias UserDataSource = UITableViewDiffableDataSource<SearchController.Section, User>
private typealias UsersSnapshot = NSDiffableDataSourceSnapshot<SearchController.Section, User>
private typealias PostDataSource = UICollectionViewDiffableDataSource<SearchController.Section, Post>
private typealias PostsSnapshot = NSDiffableDataSourceSnapshot<SearchController.Section, Post>

class SearchController: UIViewController {

	// MARK: - Properties
  
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
    tv.rowHeight = 64
    tv.delegate = self
    return tv
  }()
  
  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
    cv.delegate = self
    cv.backgroundColor = .white
    cv.register(ProfileCell.self, forCellWithReuseIdentifier: postCellIdentifier)
    return cv
  }()

	private var users = [User]()
  private var posts = [Post]()
	private var filteredUsers = [User]()

	private let searchController = UISearchController(searchResultsController: nil)

	private var inSearchMode: Bool {
		return searchController.isActive && !searchController.searchBar.text!.isEmpty
	}

	private var userDataSource: UserDataSource!
  private var postDataSource: PostDataSource!

	// MARK: - Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureSearchController()
    configureUI()
    configureUserDataSource()
    configurePostDataSource()
		fetchUsers()
    fetchPosts()
	}

	// MARK: - API

	private func fetchUsers() {
		showLoader(true)
		UserService.fetchUsers { [weak self] users in
			self?.showLoader(false)
			self?.users = users
			self?.createUserSnapshot(from: users)
		}
	}
  
  func fetchPosts() {
    PostService.fetchPosts { [weak self] (posts, error) in
      guard error == nil else {
        self?.showMessage(withTitle: "Error loading posts",
                          message: "\(error?.localizedDescription ?? "")")
                          return }
      
      guard let posts = posts else { return }
      
      self?.posts = posts
      self?.createPostSnapshot(from: posts)
    }
  }
  
	// MARK: - Helpers

	private func configureUI() {
		view.backgroundColor = .white
    navigationItem.title = "Explore"
    
    view.addSubview(tableView)
    tableView.fillSuperview()
    tableView.isHidden = true
    
    view.addSubview(collectionView)
    collectionView.fillSuperview()
	}

  private func configureSearchController() {
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.searchBar.placeholder = "Search"
    searchController.searchBar.delegate = self
    navigationItem.searchController = searchController
    definesPresentationContext = false
  }

  // MARK: - DataSource
  
	private func configureUserDataSource() {
		userDataSource = UserDataSource(tableView: tableView, cellProvider: { (tableView, indexPath, user) -> UITableViewCell? in
			guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserCell else { fatalError() }
			let user = self.inSearchMode ? self.filteredUsers[indexPath.row] : self.users[indexPath.row]
			cell.viewModel = UserCellViewModel(user: user)
			return cell
		})
	}
  
  private func configurePostDataSource() {
    postDataSource = PostDataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, post) -> UICollectionViewCell? in
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: postCellIdentifier, for: indexPath) as? ProfileCell else { fatalError() }
      let post = self.posts[indexPath.row]
      cell.viewModel = PostViewModel(post: post)
      return cell
    })
  }


  // MARK: - Snapshots
  
	private func createUserSnapshot(from users: [User]) {
		var snapshot = UsersSnapshot()
		snapshot.appendSections([.main])
		snapshot.appendItems(users)
    userDataSource.apply(snapshot, animatingDifferences: false)
	}
  
  private func createPostSnapshot(from users: [Post]) {
    var snapshot = PostsSnapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems(users)
    postDataSource.apply(snapshot, animatingDifferences: false)
  }
  
}

// MARK: - Sections

extension SearchController {
  fileprivate enum Section {
    case main
  }
}

// MARK: - UITableViewDelegate

extension SearchController: UITableViewDelegate {
  
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let nonFilteredUser = userDataSource.itemIdentifier(for: indexPath) else { return }
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

		self.createUserSnapshot(from: users)
	}
}

// MARK: - UISearchBarDelegate

extension SearchController: UISearchBarDelegate {
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
    collectionView.isHidden = true
    tableView.isHidden = false
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
    searchBar.showsCancelButton = false
    searchBar.text = nil
    collectionView.isHidden = false
    tableView.isHidden = true
  }
}

// MARK: - UICollectionViewDelegate

extension SearchController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let post = postDataSource.itemIdentifier(for: indexPath) else { return }
    let controller = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
    controller.post = post
    navigationController?.pushViewController(controller, animated: true)
    
  }
  
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SearchController: UICollectionViewDelegateFlowLayout {

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
}
