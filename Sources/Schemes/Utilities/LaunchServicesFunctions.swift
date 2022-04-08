//
//  LaunchServicesFunctions.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import Foundation

/**
 * TODO: document
 *
 * Seems to be deprecated and hence unavailable in Swift.
 */
func LSCopySchemesAndHandlerURLs(
  _  schemes : UnsafeMutablePointer<NSArray?>,
  _ handlers : UnsafeMutablePointer<NSArray?>) -> OSStatus
{
  typealias fnType = @convention(c) (
    UnsafeMutablePointer<NSArray?>,
    UnsafeMutablePointer<NSArray?>
  ) -> OSStatus

  let handle = dlopen(nil, RTLD_NOW)
  defer { dlclose(handle) }
  
  let fn = unsafeBitCast(dlsym(handle, "_LSCopySchemesAndHandlerURLs"),
                         to: fnType.self)
  return fn(schemes, handlers)
}

/**
 * TODO: document
 *
 * Seems to be deprecated and hence unavailable in Swift.
 * Or never was available?
 *
 * This doesn't work in a Sandbox, presumably the reason why Oli had it in an
 * XPC. If run in a Sandbox, it returns `-54` (`permErr` in CarbonCore).
 *
 * Errors seen:
 * - let kLSApplicationNotFoundErr : OSStatus = -10814 // LaunchServices
 * - let permErr                   : OSStatus = -54    // CarbonCore
 */
func LSUnregisterURL(_ url: CFURL) -> OSStatus {
  typealias fnType = @convention(c) ( CFURL ) -> OSStatus

  let handle = dlopen(nil, RTLD_NOW)
  defer { dlclose(handle) }
  
  let fn = unsafeBitCast(dlsym(handle, "_LSUnregisterURL"), to: fnType.self)
  return fn(url)
}
