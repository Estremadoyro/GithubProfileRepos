//
//  HomeView.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import RxCocoa
import RxSwift
import UIKit

final class HomeView: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

  private let networkManager: NetworkManager
  private lazy var viewModel = HomeViewModel(networkManager: networkManager)

  lazy var reposObservable = viewModel.getReposFromUsername(username: "estremadoyro").share()
  private var disposeBag = DisposeBag()

  init(networkManager: NetworkManager) {
    self.networkManager = networkManager
    super.init(nibName: Nibs.homeView, bundle: Bundle.main)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension HomeView {
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.delegate = self
    configureView()
    displayReposFromUsername()
  }
}

extension HomeView {
  private func configureTable() {
    tableView.register(UINib(nibName: Nibs.repoCell, bundle: Bundle.main), forCellReuseIdentifier: Nibs.repoCell)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 100
  }

  private func configureView() {
    view.backgroundColor = UIColor.systemIndigo
    navigationItem.title = "Repos"
    reposWillLoad()
    configureTable()
  }
}

extension HomeView {
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

extension HomeView {
  private func displayReposFromUsername() {
    // Yet to concatenate with the Lanaguages API
    reposObservable
      .delay(.seconds(1), scheduler: MainScheduler.instance)
      // So, the Observable<Repo> needs to become Observable<[Repo]>, so Observable is a Sequence and it's elements need to aswell.
      // The Observable Type, in this case [Repo], must be a Sequence in order for tableView.rx.items() to be able to subscrible to it.
      // Observable: Sequence <[Repo]: Sequence>
      .bind(to: tableView.rx.items(cellIdentifier: "RepoCell", cellType: RepoCell.self)) { [weak self] _, repo, cell in
        cell.homeViewModel = self?.viewModel
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

extension HomeView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}
