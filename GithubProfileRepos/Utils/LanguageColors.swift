//
//  LanguageColors.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 4/04/22.
//

import UIKit.UIColor

public typealias ColorByLanguage = [String: UIColor]

enum LanguageColors {
  static let colors: ColorByLanguage = [
    "swift": UIColor.systemPink,
    "javascript": UIColor.systemYellow,
    "typescript": UIColor.systemIndigo,
    "html": UIColor.systemRed,
    "css": UIColor.systemBlue,
    "python": UIColor.systemGreen,
    "scala": UIColor.systemRed,
    "java": UIColor.systemOrange,
    "php": UIColor.systemPurple,
    "ruby": UIColor.systemRed
  ]

  static let defaultColor = UIColor.systemGray6
}
