////
//	NotesView.swift
//	Notes
//
//	Created By Altametrics on 16/11/24
//

//	Hubworks: https://www.hubworks.com
//


import SwiftUI

struct NotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    var notes: [Notes] {
        vm.notes.map { $0 }.sorted(by: { $0.modifiedAt > $1.modifiedAt }).sorted(by: { $0.isPinned && !$1.isPinned })
    }
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(notes, id: \.id){ note in
                    NavigationLink(destination: EditNotesView(note: note)){
                        HStack(alignment: .top){
                            VStack(alignment: .leading, spacing: 5){
                                Text(note.title)
                                    .lineLimit(1)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                Text(note.content)
                                    .fontWeight(.light)
                            }
                            Spacer()
                            Image(systemName: note.isPinned ? "pin.fill" : "pin.slash")
                                .foregroundColor(Color(UIColor.black))
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet{
                        vm.deleteNote(notes[index])
                    }
                })
            }
            .navigationTitle("Notes")
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                vm.searchNotes(with: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    Button { } label: {
                        NavigationLink(destination: EditNotesView(note: Notes(title: "", content: ""))){
                            Image(systemName: "note.text.badge.plus")
                                .foregroundColor(Color(UIColor.orange))
                        }
                    }
                }
            }
        }
        .accentColor(.orange)
    }
}

#Preview {
    NotesView()
}

