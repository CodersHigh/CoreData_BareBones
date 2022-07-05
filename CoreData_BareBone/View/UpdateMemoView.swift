//
//  UpdateMemoView.swift
//  CoreData_BareBone
//
//  Created by 이로운 on 2022/07/05.
//

import SwiftUI

struct UpdateMemoView: View {
    @ObservedObject var memo: Memo
    @State var title = ""
    @State var content = ""
    let onComplete: (String, String) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Title")) {
                    TextField(memo.title ?? "", text: $title)
                }
                Section(header: Text("Content")) {
                    TextField(memo.content ?? "", text: $content)
                }
                Section {
                    Button {
                        onComplete(title, content)
                    } label: {
                        Text("Update Complete")
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || content.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .navigationTitle("Update Memo")
        }
    }
}
