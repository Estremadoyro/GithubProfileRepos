//
//  HomeSearchBar.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 11/04/22.
//

import UIKit

final class HomeSearchBar: UISearchController {
  init() {
    super.init(searchResultsController: SearchResultsVC())
    configureSearchBar()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeSearchBar {
  /// # Only runs when user has tapped on the SearchBar
  /// Default configurations should be done in the init() method
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

private extension HomeSearchBar {
  func configureSearchBar() {
    showsSearchResultsController = true
    searchBar.placeholder = "Search Github"
  }
}

extension HomeSearchBar: UISearchControllerDelegate {
  func didPresentSearchController(_ searchController: UISearchController) {
  }
}
