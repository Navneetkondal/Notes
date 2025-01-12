////
//	EditNotesView.swift
//	Notes
//
//	Created By Altametrics on 16/11/24
//

//	Hubworks: https://www.hubworks.com
//


import SwiftUI

struct EditNotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    
    @State var note: Notes
    @State var title: String = ""
    @State var content: String = ""
    @State var isAnyChange: Bool = false
    @State var isPinned: Bool = false

    @FocusState private var isFocusedField: Bool
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                TextField("Title", text: $title, axis: .vertical)
                    .focused($isFocusedField)
                    .font(.title.bold())
                    .submitLabel(.next)
                    .onChange(of: title){
                        isAnyChange = true
                    }
                TextEditorView(string: $content)
                    .focused($isFocusedField)
                    .scrollDisabled(true)
                    .font(.title3)
                    .onChange(of: content){
                        isAnyChange = true
                    }
            }
            .padding(10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    isAnyChange = true
                    isPinned = !isPinned
                    updateAndSave()
                } label: {
                    Image(systemName: isPinned ? "pin.fill" : "pin.slash")
                        .foregroundColor(Color(UIColor.systemOrange))
                }
            }
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        isFocusedField = false
                        updateAndSave()
                    }
                }
            }
        }
        .onAppear(){
            title = note.title
            content = note.content
            isPinned = note.isPinned
        }
        .onDisappear(){
            updateAndSave()
        }
    }
    
     func updateAndSave(){
        if isAnyChange{
            if title.removeSpaces().isEmpty && content.removeSpaces().isEmpty{
                return
            }
            let isModified = title != note.title || content != note.content
            note.title = title
            note.content = content
            note.isPinned = isPinned
            note.modifiedAt =  isModified ? Date().timeIntervalSince1970 : note.modifiedAt
            vm.saveAndUpdateNote(note)
            isAnyChange = false
        }
    }
}

//#Preview {
//    EditNotesView()
//}
