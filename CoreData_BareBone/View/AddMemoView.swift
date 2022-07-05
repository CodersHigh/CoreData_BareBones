//
//  AddMemoView.swift
//  CoreData_BareBone
//
//  Created by 이로운 on 2022/07/05.
//

import SwiftUI

struct AddMemoView: View {
    @State var title = ""
    @State var content = ""
    let onComplete: (String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $title)
                }
                Section(header: Text("Content")) {
                    TextField("Content", text: $content)
                }
                Section {
                    Button {
                        onComplete(title, content)
                    } label: {
                        Text("Add Complete")
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || content.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("New Memo")
        }
    }
}
