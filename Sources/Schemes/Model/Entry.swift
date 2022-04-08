//
//  Entry.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import struct Foundation.URL

struct Entry: Equatable {

  let scheme  : String
  let handler : URL
  
}

extension Entry {

  enum HandlerType: String, CaseIterable {
    case installedApplication    = "/Applications"
    case systemApplication       = "/System/Applications/"
    case userApplication         = "/Users/%@/Applications/"
    case localApplicationSupport = "/Library/Application Support/"
    case coreServices            = "/System/Library/CoreServices"
    case externalDisk            = "/Volumes/%@/"
    case other                   = "%@"
  }
  
  var handlerType: HandlerType {
    guard handler.isFileURL else { return .other }
    let path = handler.path
    if let item = HandlerType
      .allCases.first(where: { path.hasPrefix($0.rawValue) })
    {
      return item
    }
    if path.hasPrefix("/Users/")   { return .userApplication }
    if path.hasPrefix("/Volumes/") { return .externalDisk    }
    return .other
  }
}

extension Entry: Identifiable {
  
  // There should never be dupes, right?
  var id : String { scheme + handler.absoluteString }
}
