//
//  HomeView.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import RxCocoa
import RxSwift
import UIKit

final class ReposTableVC: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

  fileprivate let networkManager: NetworkManager
  fileprivate lazy var viewModel = ReposTableViewModel(networkManager: networkManager)

  fileprivate lazy var reposObservable = viewModel.getReposFromUsername(username: "estremadoyro").share()
  fileprivate var disposeBag = DisposeBag()

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: Nibs.reposTableView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension ReposTableVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    configureView()
    displayReposFromUsername()
  }
}

extension ReposTableVC {
  private func configureTable() {
    tableView.register(UINib(nibName: Nibs.repoCell, bundle: Bundle.main), forCellReuseIdentifier: Nibs.repoCell)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
  }

  private func configureView() {
    reposWillLoad()
    configureTable()
  }
}

extension ReposTableVC {
  private func reposWillLoad() {
    loadingIndicator.startAnimating()
    loadingIndicator.alpha = 1
  }

  private func reposDidLoad() {
    DispatchQueue.main.async { [weak self] in
      self?.loadingIndicator.stopAnimating()
      self?.loadingIndicator.alpha = 0
    }
  }
}

extension ReposTableVC {
  private func displayReposFromUsername() {
    // Yet to concatenate with the Lanaguages API
    reposObservable
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      // So, the Observable<Repo> needs to become Observable<[Repo]>, so Observable is a Sequence and it's elements need to aswell.
      // The Observable Type, in this case [Repo], must be a Sequence in order for tableView.rx.items() to be able to subscrible to it.
      // Observable: Sequence <[Repo]: Sequence>
      .bind(to: tableView.rx.items(cellIdentifier: Nibs.repoCell, cellType: RepoCell.self)) { [weak self] _, repo, cell in
        cell.reposTableViewModel = self?.viewModel
        cell.disposeBag = self?.disposeBag
        cell.repo = repo
      }
      .disposed(by: disposeBag)

    reposObservable.delay(.seconds(1), scheduler: MainScheduler.instance).subscribe(onCompleted: { [weak self] in
      self?.reposDidLoad()
    })
      .disposed(by: disposeBag)
  }
}
