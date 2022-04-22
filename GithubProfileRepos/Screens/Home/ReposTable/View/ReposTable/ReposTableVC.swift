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

  fileprivate lazy var viewModel = ReposTableViewModel()

  // Observable passed from ContainerVC
  fileprivate weak var reposObservable: PublishSubject<[Repo]>?

  fileprivate let disposeBag = DisposeBag()

  init(reposObservable: PublishSubject<[Repo]>,
       networkManager: NetworkManager)
  {
    self.reposObservable = reposObservable
    super.init(nibName: Xibs.reposTableView, bundle: Bundle.main)
    viewModel.networkManager = networkManager
  }

  deinit {
    print("\(self) deinited")
    reposObservable?.dispose()
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
    configureBindings()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print("TABLE DID APPEAR")
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print("TABLE willAppear")
  }
}

extension ReposTableVC {
  private func configureTable() {
    tableView.register(UINib(nibName: Xibs.repoCell, bundle: Bundle.main), forCellReuseIdentifier: Xibs.repoCell)
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
      self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
  }
}

private extension ReposTableVC {
  func configureBindings() {
    guard let reposObservable = reposObservable else { return }
    bindRepos(reposObservable: reposObservable)
  }
}

extension ReposTableVC {
  private func bindRepos(reposObservable: PublishSubject<[Repo]>) {
    // Yet to concatenate with the Lanaguages API
    reposObservable
      .asObservable()
//      .delay(.seconds(1), scheduler: MainScheduler.instance)
      // So, the Observable<Repo> needs to become Observable<[Repo]>, so Observable is a Sequence and it's elements need to aswell.
      // The Observable Type, in this case [Repo], must be a Sequence in order for tableView.rx.items() to be able to subscrible to it.
      // Observable: Sequence <[Repo]: Sequence>
      .bind(to: tableView.rx.items(cellIdentifier: Xibs.repoCell, cellType: RepoCell.self)) { [weak self] _, repo, cell in
        cell.repoCellViewModel.networkManager = self?.viewModel.networkManager
        cell.repo = repo
      }
      .disposed(by: disposeBag)

    reposObservable
      .asObservable()
//      .delay(.seconds(1), scheduler: MainScheduler.instance)
      .subscribe(onNext: { [weak self] _ in
        self?.reposDidLoad()
      })
      .disposed(by: disposeBag)
  }
}
