//
//  SchemeHandlerTableView.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI

extension SchemeHandlerTableVC {
  
  @available(macOS 12, *)
  struct SchemeHandlerTableView: View {

    @EnvironmentObject private var viewController : SchemeHandlerTableVC

    private func handlersWithUniqueName() -> [ (name: String, handler: URL) ] {
      var usedNames = Set<String>()
      var result    = [ ( name: String, handler: URL ) ]()
      for entry in viewController.dataSource.source.entries {
        let name = entry.handler.lastPathComponent
        guard !name.isEmpty, !usedNames.contains(name) else { continue }
        usedNames.insert(name)
        result.append( ( name: name, handler: entry.handler ) )
      }
      return result.sorted(by: { $0.name < $1.name })
    }

    let iconSize = CGSize(width: 16, height: 16)

    var body : some View {
      Table(viewController.dataSource.objects,
            selection: $viewController.selectedID,
            sortOrder: $viewController.dataSource.sortOrder)
      {
        TableColumn("Scheme", value: \.scheme) { item in
          SchemeCell(scheme: item.scheme)
        }
        .width(min: 100, ideal: 180)
        
        TableColumn("Handler", value: \.handler.path) { item in
          HandlerCell(handler: item.handler)
        }
        .width(min: 200, ideal: 480)
      }
      
      .confirmationDialog(
        "Unregister Application",
        isPresented: $viewController.isPresentingUnregisterPrompt,
        actions: {
          Button("Unregister", role: .destructive,
                 action: viewController.unregister)
          Button("Cancel", role: .cancel, action: { })
        },
        message: {
          Text(
            "Unregistering an application removes all associated schemes, " +
            "not just one."
          )
        }
      )
      
      .searchable(text: $viewController.searchString,
                  placement: .toolbar,
                  prompt: "Search for scheme or application")
      {
        ForEach(handlersWithUniqueName(), id: \.name) { entry in
          Label(
            title: { Text(verbatim: entry.name) },
            icon:  { Image(nsImage: entry.handler.fileIcon(with: iconSize)) }
          )
          .searchCompletion(entry.name)
        }
        
        Divider()
        
        ForEach(viewController.dataSource.source.allSchemes().sorted(),
                id: \.self)
        {
          SchemeCell(scheme: $0)
            .searchCompletion($0)
        }
      }
    }
  }
}
