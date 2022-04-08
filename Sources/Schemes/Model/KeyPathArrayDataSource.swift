//
//  KeyPathArrayDataSource.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import Combine
import Foundation

public protocol Qualifier {
  
  associatedtype Element

  func evaluateWithObject(_ entry: Element) -> Bool
}

/**
 * A non-generic datasource object that peeks into a Collection property.
 * (a real thing would have a more generic class)
 *
 * Note: Requires macOS 12 for `SortComperator`.
 */
@available(macOS 12, *)
public final class KeyPathArrayDataSource<S, C, SC, Q>: ObservableObject
                     where S: ObservableObject, C: Collection,
                           SC: SortComparator, // requires macOS 12
                           SC.Compared == C.Element,
                           Q: Qualifier, Q.Element == C.Element
{
  
  public let source  : S
  public let keyPath : KeyPath<S, C>
  
  // https://useyourloaf.com/blog/sortcomparator-and-sortdescriptor/
  var sortOrder : [ SC ] {
    willSet {
      objectWillChange.send()
      setNeedsArrangeObjects()
    }
  }
  
  var qualifier : Q? = nil {
    willSet {
      objectWillChange.send()
      setNeedsArrangeObjects()
    }
  }
  
  public var objects  : [ C.Element ] {
    if let objects = _objects { return objects }
    arrangeObjects()
    return _objects ?? []
  }
  private var _objects : [ C.Element ]?

  private var subscription : AnyCancellable?
  
  init(_ source: S, _ keyPath: KeyPath<S, C>, sortBy: SC? = nil) {
    self.source    = source
    self.keyPath   = keyPath
    self.sortOrder = sortBy.flatMap { [ $0 ] } ?? []
    
    subscription = source.objectWillChange.sink { [weak self] _ in
      guard let me = self else { return }
      me.objectWillChange.send()
      me.setNeedsArrangeObjects()
    }
  }
  
  private func setNeedsArrangeObjects() {
    _objects = nil
  }
  
  func arrangeObjects() {
    var newObjects = source[keyPath: keyPath].filter {
      qualifier?.evaluateWithObject($0) ?? true
    }
    
    newObjects.sort(using: sortOrder)
    
    _objects = newObjects
  }
}
