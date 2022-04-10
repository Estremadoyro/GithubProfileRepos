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
    let mostUsedLanguage = languages.max { first, second in first.value < second.value }
    return getColorByRepoLanguage(repoLanguage: mostUsedLanguage)
  }

  fileprivate static func getColorByRepoLanguage(repoLanguage: RepoLanguage.Element?) -> ColorByLanguage.Element {
    guard let language = repoLanguage, let color = LanguageColors.colors[language.key.lowercased()] else {
      return errorColorByLanguage
    }
    return (language.key, color)
  }
}

extension Utils {
  public static func getUserAccumulatedStars(repos: [Repo]) -> Int {
    let reposStars = repos.map { $0.stars }
    return reposStars.reduce(0) { current, next in
      current + next
    }
  }

  public static func getUserTotalLinesOfCode(repos: [Repo]) -> Int {
    return 1
  }
}

extension Utils {
  public static func getImageFromSource(source: String?, completion: @escaping (UIImage) -> Void)  {
    let placeholderImage = UIImage(named: "loading-image.png")!
    guard let source = source else { completion(placeholderImage); return }
    let session = URLSession.shared
    defer {
      session.invalidateAndCancel()
      session.finishTasksAndInvalidate()
    }
    guard let url = URL(string: source) else { completion(placeholderImage); return }
    print("IMAGE URL \(url)")

    session.dataTask(with: url) { data, _, error in
      guard error == nil else {
        completion(placeholderImage)
        return
      }
      guard let data = data, let image = UIImage(data: data) else { return }
      completion(image)
    }.resume()
  }
}
