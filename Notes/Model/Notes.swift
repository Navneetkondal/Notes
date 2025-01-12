//
//    Notes.swift
//    Notes
//
//    Created By Navneet on 16/11/24
//


import Foundation
 
struct Notes{
    var id: UUID?
    var title: String
    var content: String
    var createdAt: Double
    var modifiedAt:Double
    var isPinned:Bool
    
    init(note: NotesEntity){
        self.id = UUID(uuidString: note.id ?? "")
        self.title = note.title ?? ""
        self.content = note.content ?? ""
        self.createdAt = note.createdAt
        self.modifiedAt = note.modifiedAt
        self.isPinned = note.isPinned
    }
    
    init(id: UUID? = UUID(), title: String, content: String, createdAt: Double = Date().timeIntervalSince1970, modifiedAt: Double = Date().timeIntervalSince1970, isPinned: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
        self.isPinned = isPinned
    }
}
