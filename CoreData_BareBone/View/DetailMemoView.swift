//
//  DetailMemoView.swift
//  CoreData_BareBone
//
//  Created by 이로운 on 2022/07/05.
//

import SwiftUI

struct DetailMemoView: View {
    @ObservedObject var memo: Memo
    
    @ObservedObject var memoViewModel: MemoViewModel
    @State private var updateViewPresented = false
    
    var body: some View {
        Form {
            Section(header: Text("Title")) {
                Text(memo.title ?? "")
            }
            Section(header: Text("Content")) {
                Text(memo.content ?? "")
            }
            Section {
                Text(memoViewModel.dateToString(date: memo.date ?? Date()))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Section {
                Button {
                    updateViewPresented = true
                } label: {
                    Text("Update")
                }
            }
        }
        .sheet(isPresented: $updateViewPresented) {
            UpdateMemoView(memo: memo, title: memo.title ?? "", content: memo.content ?? "") { title, content in
                memo.title = title
                memo.content = content
                memo.date = Date()
                memoViewModel.saveContext()
                memoViewModel.fetchMemo()
                updateViewPresented = false
            }
        }
        .navigationTitle("Memo Detail")
    }
}
