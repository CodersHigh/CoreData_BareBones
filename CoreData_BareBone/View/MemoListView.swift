//
//  MemoListView.swift
//  CoreData_BareBone
//
//  Created by 이로운 on 2022/07/05.
//

import SwiftUI

struct MemoListView: View {
    @StateObject var memoViewModel = MemoViewModel()
    @State private var addViewPresented = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(memoViewModel.memos, id: \.self) { memo in
                    NavigationLink {
                        DetailMemoView(memo: memo, memoViewModel: memoViewModel)
                    } label: {
                        Text(memo.title ?? "")
                            .foregroundColor(.primary)
                        Spacer()
                        Text(memoViewModel.dateToString(date: memo.date ?? Date()))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let memo = memoViewModel.memos[index]
                        memoViewModel.deleteMemo(memo: memo)
                        memoViewModel.fetchMemo()
                    }
                }
            }
            .listStyle(.plain)
            .sheet(isPresented: $addViewPresented) {
                AddMemoView { title, content in
                    memoViewModel.addMemo(title: title, content: content)
                    memoViewModel.fetchMemo()
                    self.addViewPresented = false
                }
            }
            .navigationTitle("Memo List")
            .navigationBarItems(trailing:
                Button(action: { self.addViewPresented.toggle() }) {
                    Image(systemName: "plus")
                })
        }
        .onAppear {
            memoViewModel.fetchMemo()
        }
    }
}
