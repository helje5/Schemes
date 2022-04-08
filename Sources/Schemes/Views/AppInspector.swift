//
//  AppInspector.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

struct AppInspector: View {

  let entry      : Entry?
  let allEntries : [ Entry ]
  let unregister : (() -> Void)?
  
  private var iconSize : CGSize { CGSize(width: 128, height: 128) }
  
  var body: some View {
    if let entry = entry {
      VStack(spacing: 0) {
        VStack {
          Image(nsImage: entry.handler.fileIcon(with: iconSize))

          Text(verbatim: entry.handler.lastPathComponent)
            .font(.title2)
        }
        .padding()
        
        Divider()
        
        Text(verbatim: entry.handler.path)
          .font(.footnote)
          .padding(.horizontal, 4)
          .padding(.vertical,   8)

        Divider()
        
        List(allEntries.map(\.scheme).sorted(), id: \.self) {
          SchemeCell(scheme: $0)
        }

        if let unregister = unregister {
          Divider()
          Button("Unregister", role: .destructive, action: unregister)
            .buttonStyle(.borderedProminent)
            .padding()
        }
      }
      .multilineTextAlignment(.leading)
      .background(Color(NSColor.textBackgroundColor))
    }
    else {
      VStack {
        Text("No Application Selected")
          .foregroundColor(.secondary)
          .padding()
        Spacer()
      }
    }
  }
}
