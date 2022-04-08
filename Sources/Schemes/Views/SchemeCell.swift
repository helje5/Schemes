//
//  SchemeCell.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct SchemeCell: View {
  
  let scheme : String
  
  private var iconName : String {
    scheme.first.flatMap { $0.lowercased() + ".square" }
    ?? "questionmark.app.dashed"
  }
  
  var body: some View {
    Label(scheme, systemImage: iconName)
      .imageScale(.large)
  }
}
