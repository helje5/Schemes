//
//  ContentView.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  @EnvironmentObject private var launchServices : LaunchServices

  var body: some View {
    if #available(macOS 12, *) {
      SchemeHandlerTableVC.RootView()
    }
    else {
      SchemeHandlerList(entries: launchServices.entries)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
