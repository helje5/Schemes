//
//  SchemeHandlerList.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

/**
 * Just a lame fallback, fixup w/ different View using same VC
 */
struct SchemeHandlerList: View {

  let entries : [ Entry ]

  var body: some View {
    List(entries) { entry in      
      HStack {
        Text(verbatim: entry.scheme) + Text(": ")
        Spacer()
        Text(verbatim: entry.handler.path)
      }
    }
  }
}
