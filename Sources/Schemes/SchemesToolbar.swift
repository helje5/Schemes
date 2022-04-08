//
//  SchemesToolbar.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct SchemesToolbar: CustomizableToolbarContent {
  
  private var launchServices : LaunchServices { .shared }

  var body: some CustomizableToolbarContent {
    ToolbarItem(id: "Refresh Button") {
      Button(action: launchServices.refresh) {
        Label("Refresh", systemImage: "arrow.clockwise")
      }
      .keyboardShortcut(.init("r", modifiers: .command))
    }
  }
}
