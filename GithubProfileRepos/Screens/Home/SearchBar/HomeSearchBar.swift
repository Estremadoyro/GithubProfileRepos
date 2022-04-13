//
//  HomeSearchBar.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 11/04/22.
//

import RxSwift
import UIKit

final class HomeSearchBar: UISearchController {
  fileprivate var searchBarDisposable: Disposable?
  fileprivate let disposeBag = CompositeDisposable()

  init() {
    print("Inited search controller")
    super.init(searchResultsController: SearchResultsVC())
    configureSearchBar()
  }

  deinit { print("\(self) deinited ") }

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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    configureBindings()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    let disposables: [Disposable?] = [searchBarDisposable]
    disposeSequences(disposables)
  }
}

private extension HomeSearchBar {
  func configureSearchBar() {
    showsSearchResultsController = true
    searchBar.placeholder = "Search Github"
  }
}

private extension HomeSearchBar {
  func configureBindings() {
    bindSearchBar()
  }

  func disposeSequences(_ disposables: [Disposable?]) {
    disposables.forEach { disposable in
      if let disposable = disposable, let disposableKey = disposeBag.insert(disposable) {
        disposeBag.remove(for: disposableKey)
      }
    }
  }
}

private extension HomeSearchBar {
  func bindSearchBar() {
    searchBarDisposable = searchBar.rx.value.subscribe(onNext: { value in
      print("value: \(value ?? "")")
    }, onDisposed: { print("Searchbar disposed") })
  }
}
