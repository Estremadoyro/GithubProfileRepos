//
//  CacheManager.swift
//  GithubProfileRepos
//
//  Created by Leonardo  on 17/04/22.
//

import Foundation

// NSCache<AnyObject, AnyObject>
final class CacheManager<Key: Hashable, Value> {
  private let wrapped = NSCache<WrappedKey, Entry>()

  // Inserting new value
  func insert(_ value: Value, forKey key: Key) {
    let entry = Entry(value: value)
    wrapped.setObject(entry, forKey: WrappedKey(key))
  }

  // Retrieving value
  func value(forKey key: Key) -> Value? {
    let entry = wrapped.object(forKey: WrappedKey(key))
    return entry?.value
  }

  // Deleting value
  func removeValue(forKey key: Key) {
    wrapped.removeObject(forKey: WrappedKey(key))
  }
}

private extension CacheManager {
  // Make the input Key compatible with NSCache
  final class WrappedKey: NSObject {
    let key: Key
    init(_ key: Key) {
      self.key = key
    }

    // This may not be required anymore to conform NSCache
    override var hash: Int { return key.hashValue }
    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else { return false }
      return value.key == key
    }
  }
}

private extension CacheManager {
  // Only requirement is that is needs to be a class, no need to subclass NSObject
  final class Entry {
    let value: Value
    init(value: Value) {
      self.value = value
    }
  }
}

extension CacheManager {
  // Handy subscript to retrieve/set/remove cache
  subscript(key: Key) -> Value? {
    get { return value(forKey: key) }
    set {
      guard let value = newValue else {
        // If nil was assigned for the Value
        // Then remove any value for that Key
        removeValue(forKey: key)
        return
      }
      insert(value, forKey: key)
    }
  }
}
