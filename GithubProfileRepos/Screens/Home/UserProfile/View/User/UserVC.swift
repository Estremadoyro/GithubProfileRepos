//
//  UserVC.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import RxCocoa
import RxSwift
import UIKit

final class UserVC: UIViewController {
  @IBOutlet private weak var userUsername: UILabel!
  @IBOutlet private weak var userFollowing: UILabel!
  @IBOutlet private weak var userFollowers: UILabel!
  @IBOutlet private weak var userStars: UILabel!
  @IBOutlet private weak var userPicture: UIImageView!
  @IBOutlet private weak var userBio: UILabel!

  // Observable passed from ContainerVC
  fileprivate weak var reposObservable: PublishSubject<[Repo]>?
  fileprivate weak var currentUserObservable: PublishRelay<UserProfile>?

  // User View Model
  fileprivate lazy var userViewModel = UserViewModel()

  fileprivate lazy var userProfilePictureObservable: PublishSubject<UIImage> = userViewModel.userProfilePictureObservable

  fileprivate let disposeBag = DisposeBag()

  init(reposObservable: PublishSubject<[Repo]>,
       currentUserObservable: PublishRelay<UserProfile>,
       networkManager: NetworkManager)
  {
    self.reposObservable = reposObservable
    self.currentUserObservable = currentUserObservable
    super.init(nibName: Xibs.userView, bundle: Bundle.main)
    userViewModel.networkManager = networkManager
  }

  deinit {
    print("\(self) deinited")
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UserVC {
  override func viewDidLoad() {
    super.viewDidLoad()
    initialValues()
    configureBindings()
  }
}

private extension UserVC {
  // TODO: User BehaviorSubject instead? This is not reactive...
  func initialValues() {
    userUsername.text = "Loading..."
    userFollowers.text = "Loading..."
    userFollowing.text = "Loading..."
    userStars.text = "-"
    userBio.text = "Loading..."
    userPicture.image = UIImage(named: "loading-image.png")!
  }
}

private extension UserVC {
  func configureBindings() {
    bindUserProfilePicture()
    bindUsername()
    bindFollowsAndFollowers()
    bindUserStars()
    bindUserBio()
  }
}

private extension UserVC {
  func bindUsername() {
    currentUserObservable?
      .map { "@\($0.name.lowercased())" }
      .bind(to: userUsername.rx.text)
      .disposed(by: disposeBag)
  }
}

private extension UserVC {
  func bindFollowsAndFollowers() {
    bindUserFollowers()
    bindUserFollowing()
  }

  func bindUserFollowers() {
    currentUserObservable?
      .map { "\($0.followers) followers" }
      .bind(to: userFollowers.rx.text)
      .disposed(by: disposeBag)
  }

  func bindUserFollowing() {
    currentUserObservable?
      .map { "\($0.following) following" }
      .bind(to: userFollowing.rx.text)
      .disposed(by: disposeBag)
  }
}

extension UserVC {
  func bindUserStars() {
    reposObservable?
      .map { repos -> String in
        let stars = Utils.getUserAccumulatedStars(repos: repos)
        return String(stars)
      }
      .bind(to: userStars.rx.text)
      .disposed(by: disposeBag)
  }

  func bindUserProfilePicture() {
    userProfilePictureObservable
      .bind(to: userPicture.rx.image)
      .disposed(by: disposeBag)

    currentUserObservable?
      .map { $0.profilePicture }
      .subscribe(onNext: { [weak self] imageSource in
        self?.userViewModel.updateProfilePictureSequence(source: imageSource)
      })
      .disposed(by: disposeBag)
  }

  func bindUserBio() {
    currentUserObservable?
      .map { $0.bio }
      .bind(to: userBio.rx.text)
      .disposed(by: disposeBag)
  }
}
