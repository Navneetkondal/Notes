//
//    NotesViewModel.swift
//    Notes
//
//    Created By Navneet on 16/11/24
//

import Foundation
import CoreData

class NotesViewModel: ObservableObject {
    
    let manager: CoreDataManager
    @Published var notes: [Notes] = []
    @Published var isDataLoaded = false
    
    init(manager: CoreDataManager) {
        self.manager = manager
        loadData()
    }
    
    func loadData() {
        manager.loadCoreData { [weak self] success in
            DispatchQueue.main.async {
                self?.isDataLoaded = success
                if success {
                    self?.fetchNotes()
                }
            }
        }
    }
    
    func fetchNotes(with searchText: String = "")  {
        let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS %@", searchText)
        }
        do {
            notes = try manager.container.viewContext.fetch(request).map({.init(note: $0)})
        } catch {
            print("Error fetching notes: \(error)")
        }
    }
    
    func deleteNote(_ note: Notes) {
        let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id CONTAINS %@", note.id?.uuidString ?? "")
        do {
            if let note = try manager.container.viewContext.fetch(request).first{
                manager.container.viewContext.delete(note)
            }
        } catch {
            print("Error fetching notes: \(error)")
        }
        saveContext()
        fetchNotes()
    }
    
    func saveAndUpdateNote(_ note: Notes) {
        var newNote: NotesEntity?
        if let _ = notes.first(where: {$0.id != nil && $0.id == note.id}){
            print("Note already exist")
            let request: NSFetchRequest<NotesEntity> = NotesEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id CONTAINS %@" , note.id!.uuidString)
            do {
                newNote = try manager.container.viewContext.fetch(request).first
            } catch {
                print("Error fetching notes: \(error)")
            }
        }else{
            print("Note new created")
            newNote = NotesEntity(context: manager.container.viewContext)
            newNote?.createdAt = Date().timeIntervalSince1970
            newNote?.id = note.id?.uuidString
        }
        newNote?.modifiedAt = note.modifiedAt
        newNote?.title = note.title
        newNote?.content = note.content
        newNote?.isPinned = note.isPinned
        saveContext()
        fetchNotes()
    }
    
    func searchNotes(with searchText: String) {
        fetchNotes(with: searchText)
    }
    
    private func saveContext() {
        do {
            try manager.container.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

