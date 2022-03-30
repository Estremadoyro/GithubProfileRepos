//
//  HomeView.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 27/03/22.
//

import RxCocoa
import RxSwift
import UIKit

class HomeView: UIViewController {
  @IBOutlet private weak var tableView: UITableView!
  @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!

  private let networkManager: NetworkManager
  private lazy var viewModel = HomeViewModel(networkManager: networkManager)
  private lazy var reposObservable = viewModel.getReposFromUsername(username: "estremadoyro").share()

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
    testingRxSwift()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    loadingIndicator.startAnimating()
    loadingIndicator.alpha = 1
  }
}

extension HomeView {
  private func configureTable() {
    tableView.register(UINib(nibName: Nibs.repoCell, bundle: Bundle.main), forCellReuseIdentifier: Nibs.repoCell)
  }

  private func configureView() {
    view.backgroundColor = UIColor.systemIndigo
    navigationItem.title = "Repos"
    configureTable()
  }
}

extension HomeView {
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
      .toArray()
      .asObservable()
      .bind(to: tableView.rx.items(cellIdentifier: "RepoCell", cellType: RepoCell.self)) { [weak self] _, repo, cell in
        cell.repo = repo
//        cell.homeViewModel = self?.viewModel
//        cell.disposeBag = self?.disposeBag
//        cell.displayLanguagesFromRepo(repo: repo)
      }
      .disposed(by: disposeBag)

    reposObservable.subscribe(onCompleted: { [weak self] in
      self?.reposDidLoad()
    })
      .disposed(by: disposeBag)
  }

  private func displayLanguagesFromRepo(repo: Repo) {
    viewModel.getLanguagesFromRepo(repo: repo)
      .subscribe { languages in
        print("Language: \(languages.map { $0.key })")
      } onError: { error in
        print("Error @ VC: \(error)")
      }.disposed(by: disposeBag)
  }
}

extension HomeView: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
  }
}

private extension HomeView {
  func testingRxSwift() {
    let repo = Repo(owner: Owner(name: "Leonardo", url: "www"), name: "RxSwift", fullName: "Leonardo/RxSwift")
//    Observable.of([repo])
//    Observable.of(repo)
//      .toArray().asObservable()
  }
}
