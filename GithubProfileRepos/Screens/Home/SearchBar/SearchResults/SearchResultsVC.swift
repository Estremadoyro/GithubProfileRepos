//
//  SearchResultsVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 11/04/22.
//

import UIKit

final class SearchResultsVC: UIViewController {
  @IBOutlet private weak var searchHelpLabel: UILabel!
  @IBOutlet private weak var searchHelpTopAnchor: NSLayoutConstraint!
  @IBOutlet private weak var searchResultsCollection: UICollectionView!

  init() {
    super.init(nibName: Nibs.searchResultsView, bundle: Bundle.main)
  }

  deinit { print("\(self) deinited") }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SearchResultsVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    edgesForExtendedLayout = []
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureInitialConstraints()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    onAppearAnimations()
  }
}

private extension SearchResultsVC {
  func configureBindings() {
    bindResultsCollection()
  }
}

private extension SearchResultsVC {
  func bindResultsCollection() {
    searchResultsCollection
  }
}

private extension SearchResultsVC {
  func configureInitialConstraints() {
    searchHelpTopAnchor.priority = UILayoutPriority(998)
  }
}

private extension SearchResultsVC {
  func onAppearAnimations() {
    searchHelpTopAnchor.priority = UILayoutPriority(1000)
    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: []) {
      self.searchHelpLabel.superview?.layoutIfNeeded()
    }
  }
}
