//
//    NotesApp.swift
//    Notes
//
//    Created By Navneet on 16/11/24
//


import SwiftUI

@main
struct NotesApp: App {
    
    let coreDataManager = CoreDataManager()
    @StateObject var notesViewModel: NotesViewModel

        init() {
            let viewModel = NotesViewModel(manager: coreDataManager)
            _notesViewModel = StateObject(wrappedValue: viewModel)
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesViewModel)
        }
    }
}
