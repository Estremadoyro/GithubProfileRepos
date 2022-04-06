//
//  UIViewControllerExtension.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import UIKit.UIViewController

extension UIViewController {
  func addChildVC(_ child: UIViewController) {
    self.addChild(child)
    self.view.addSubview(child.view)
    child.didMove(toParent: self)
  }
}
