//
//  SchemesUIApp.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

@main
struct SchemesUIApp: App {
  
  @StateObject private var launchServices = LaunchServices.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(launchServices)
    }
    .windowToolbarStyle(.unified(showsTitle: true))
    .commands {
      // This adds Cmd-F, but it doesn't work for the `.searchable` toolbar.
      #if false
        TextEditingCommands()
      #endif
    }
  }
}
