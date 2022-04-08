//
//  URLExtensions.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

extension URL: Comparable {
  
  public static func < (lhs: URL, rhs: URL) -> Bool {
    lhs.absoluteString < rhs.absoluteString
  }
}

import AppKit

fileprivate struct IconCacheKey: Hashable {
  let path   : String
  let width  : CGFloat
  let height : CGFloat
}

fileprivate var iconCache = [ IconCacheKey : NSImage ]()

extension URL {
  
  /**
   * Why? Because this doesn't use the available NSImage representations
   * properly:
   * ```swift
   * Image(nsImage:
   *   NSWorkspace.shared.icon(forFile: "/Applications/Xcode.app")
   * )
   * .resizable()
   * .frame(width: 256, height: 256)
   * ```
   * It'll show up as a blurred 32×32 icon even though the representation is
   * available.
   */
  func fileIcon(with size: CGSize) -> NSImage {
    let cacheKey =
          IconCacheKey(path: path, width: size.width, height: size.height)
    if let icon = iconCache[cacheKey] { return icon }
    
    let baseIcon = fileIcon()
    guard let derived = baseIcon.copy() as? NSImage else { return baseIcon }
    derived.size = size
    iconCache[cacheKey] = derived
    return derived
  }
  
  func fileIcon() -> NSImage {
    return NSWorkspace.shared.icon(forFile: path)
  }
}
