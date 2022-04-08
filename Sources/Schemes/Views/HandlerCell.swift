//
//  HandlerCell.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct HandlerCell: View {
  
  let handler : URL
  
  private var iconSize : CGSize { .init(width: 16, height: 16) }
  
  var body: some View {
    Label(
      title: { Text(verbatim: handler.path) },
      icon:  { Image(nsImage: handler.fileIcon(with: iconSize)) }
    )
  }
}
