//
//  Utils.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 5/04/22.
//

import Foundation
import UIKit

enum Utils {
  fileprivate static let errorColorByLanguage: ColorByLanguage.Element = ("Error language", LanguageColors.defaultColor)
  fileprivate static let errorNoLanguages: ColorByLanguage.Element = ("No languages", LanguageColors.defaultColor)

  public static func getMostUsedLanguage(languages: RepoLanguage) -> ColorByLanguage.Element {
    guard languages.count > 0 else { return errorNoLanguages } // No languages
    guard languages.count >= 2 else { return getColorByRepoLanguage(repoLanguage: languages.first) } // 1 language
    let mostUsedLanguage = languages.max { first, second in first.value > second.value }
    return getColorByRepoLanguage(repoLanguage: mostUsedLanguage)
  }

  fileprivate static func getColorByRepoLanguage(repoLanguage: RepoLanguage.Element?) -> ColorByLanguage.Element {
    guard let language = repoLanguage, let color = LanguageColors.colors[language.key] else {
      return errorColorByLanguage
    }
    return (language.key, color)
  }
}
