//
//  LaunchServices.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import Foundation
import Combine

/**
 * Keep track of launch service settings.
 *
 * Currently keeps a URL scheme/handler map.
 */
final class LaunchServices : ObservableObject {
  
  static let shared = LaunchServices()
  
  @Published private(set) var entries = [ Entry ]()
  
  private var subscription    : NSObjectProtocol?
  private var refreshThrottle : DispatchWorkItem?

  private init() {
    let nc = DistributedNotificationCenter.default()
    
    subscription = nc.addObserver(forName: .lsAppRegistered, object: nil,
                                  queue: nil)
    {
      [weak self] notification in
      self?.refreshSchemesAndHandlerURLs()
    }
    
    DispatchQueue.global().async {
      self.refreshSchemesAndHandlerURLs()
    }
  }
  
  deinit {
    let nc = DistributedNotificationCenter.default()
    subscription.flatMap(nc.removeObserver(_:))
  }
  
  
  // MARK: - Accessors
  
  func entries(for handler: URL) -> [ Entry ] {
    entries.filter { $0.handler == handler }
  }
  
  func allSchemes() -> Set<String> { Set(entries.map(\.scheme)) }

  
  // MARK: - Refresh
  
  public func refresh() {
    refreshThrottle?.cancel(); refreshThrottle = nil

    let wi = DispatchWorkItem {
      self.refreshThrottle = nil
      self.refreshSchemesAndHandlerURLs()
    }
    self.refreshThrottle = wi
    DispatchQueue.global().asyncAfter(deadline: .now() + .milliseconds(100),
                                      execute: wi)
  }
  
  private func refreshSchemesAndHandlerURLs() { // Q: Any
    // Presumably those are autoreleased? Or do we need to release them? It is
    // called `copy` after all?
    var cSchemes     : NSArray?
    var cHandlerURLs : NSArray?
    
    print("Refreshing data...")
    let status = LSCopySchemesAndHandlerURLs(&cSchemes, &cHandlerURLs)
    assert(status == 0, "LSCopySchemesAndHandlerURLs failed")
    guard status == 0 else { return }
    
    guard let schemes = cSchemes as? [ String ] else {
      assertionFailure("LSCopySchemesAndHandlerURLs schemes, unexpected type!")
      return
    }
    guard let handlerURLs = cHandlerURLs as? [ URL ] else {
      assertionFailure("LSCopySchemesAndHandlerURLs urls, unexpected type!")
      return
    }
    
    assert(schemes.count == handlerURLs.count,
           "LSCopySchemesAndHandlerURLs schemes and handler count mismatch?!")
    
    DispatchQueue.main.async {
      self.entries = zip(schemes, handlerURLs).map(Entry.init)
    }
  }
}

extension Notification.Name {
  
  /**
   * The distributed notification that gets posted when an app is registered.
   */
  static let lsAppRegistered =
    Self("com.apple.LaunchServices.applicationRegistered")
  
  // TBD: is there an "unregister"?
}
