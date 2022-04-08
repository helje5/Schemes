//
//  SchemeHandlerTable.swift
//  Schemes
//
//  Created by Helge Heß. Non-SwiftUI version originally by Oliver Epper.
//  Copyright © 2022 ZeeZide GmbH. All rights reserved.
//

import SwiftUI
import Combine

struct EntryFilter: Qualifier {
  
  let string : String
  
  func evaluateWithObject(_ entry: Entry) -> Bool {
    let lc = string.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    guard !lc.isEmpty else { return true }
    return entry.scheme.lowercased().contains(lc)
        || entry.handler.path.lowercased().contains(lc)
  }
}

final class SchemeHandlerTableVC: ObservableObject {
  
  typealias DataSource =
    KeyPathArrayDataSource<LaunchServices, [ Entry ],
                           KeyPathComparator<Entry>, EntryFilter>
  
          var dataSource   : DataSource // Figure out how to make this `let` …
  private var subscription : AnyCancellable?
  
  @Published var selectedID : Entry.ID?
  
  @Published var isPresentingUnregisterPrompt = false
  
  var selectedEntry : Entry? {
    dataSource.objects.first(where: { $0.id == selectedID })
  }
  
  var searchString: String {
    set {
      let lc = newValue.lowercased()
        .trimmingCharacters(in: .whitespacesAndNewlines)
      if lc.isEmpty { dataSource.qualifier = nil }
      else { dataSource.qualifier = EntryFilter(string: lc) }
    }
    get { dataSource.qualifier?.string ?? ""}
  }

  init() {
    dataSource = DataSource(LaunchServices.shared, \.entries,
                            sortBy: .init(\.scheme))
    subscription = dataSource.objectWillChange
      .sink { [weak self] _ in self?.objectWillChange.send() }
  }
  
  
  // MARK: - Actions
  
  func refresh() {
    dataSource.source.refresh()
  }
  
  func unregister() {
    guard let entry = selectedEntry else {
      assertionFailure("Invoked \(#function) w/o selection?")
      return
    }
    let status = LSUnregisterURL(entry.handler as CFURL)
    
    let kLSApplicationNotFoundErr : OSStatus = -10814 // LaunchServices
    let permErr                   : OSStatus = -54    // CarbonCore
    switch status {
      case 0: break // ok
      case kLSApplicationNotFoundErr: break // already removed
      case permErr:
        print("Unregistration failed in Sandbox:", entry.handler.absoluteString)
        assert(status == 0, "failed to unregister URL!")
      default:
        print("Unregistration failed:", status, entry.handler.absoluteString)
        assert(status == 0, "failed to unregister URL!")
    }
    
    refresh()
  }
  
  func showUnregisterPrompt() {
    guard selectedID != nil else {
      assertionFailure("Invoked \(#function) w/o selection?")
      isPresentingUnregisterPrompt = false
      return
    }
    isPresentingUnregisterPrompt = true
  }
  
  
  // MARK: - Views
  
  /// This is just a helper View to keep the root VC around.
  @available(macOS 12, *)
  struct RootView: View {
    
    @StateObject private var viewController = SchemeHandlerTableVC()
    
    var body: some View {
      ContentView()
        .environmentObject(viewController)
    }
  }

  /// The View controlled by the ViewController.
  @available(macOS 12, *)
  struct ContentView: View {

    @EnvironmentObject private var viewController : SchemeHandlerTableVC
    
    private var otherEntriesForSelection : [ Entry ] {
      guard let entry = viewController.selectedEntry else { return [] }
      return viewController.dataSource.source.entries(for: entry.handler)
    }
    
    var body : some View {
      HSplitView {
        SchemeHandlerTableView()
          .layoutPriority(2)
        
        AppInspector(entry      : viewController.selectedEntry,
                     allEntries : otherEntriesForSelection,
                     unregister : viewController.showUnregisterPrompt)
          .frame(minWidth: 200, maxWidth: 800, alignment: .top)
      }
      .toolbar(id: "Schemes Main Toolbar") {
        Toolbar(viewController: viewController, change: UUID())
      }
    }
  }

  struct Toolbar<C>: CustomizableToolbarContent {
    
    let viewController : SchemeHandlerTableVC // OO doesn't work in here!
    let change         : C // crazy stuff to get the updating to work

    var body: some CustomizableToolbarContent {
      
      // TBD: Move to Inspector? It doesn't just remove a single mapping,
      //      but the whole app.
      ToolbarItem(id: "Unregister") {
        Button(action: viewController.showUnregisterPrompt) {
          Label("Unregister Application",
                systemImage: "trash")
        }
        .disabled(viewController.selectedID == nil)
      }
      
      ToolbarItem(id: "Refresh Button") {
        Button(action: viewController.refresh) {
          Label("Refresh", systemImage: "arrow.clockwise")
        }
        .keyboardShortcut(.init("r", modifiers: .command))
      }
    }
  }
}
