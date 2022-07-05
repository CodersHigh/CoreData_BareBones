//
//  MemoViewModel.swift
//  CoreData_BareBone
//
//  Created by 이로운 on 2022/07/05.
//

import Foundation
import CoreData

class MemoViewModel: ObservableObject {
    @Published var memos = [Memo]()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "MemoModel")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed: \(error.localizedDescription)")
            }
        }
    }
    
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func saveContext() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
    
    func deleteMemo(memo: Memo) {
        persistentContainer.viewContext.delete(memo)
        saveContext()
    }
    
    func fetchMemo() {
        let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
        let dateSort = NSSortDescriptor(key:"date", ascending: false)
        fetchRequest.sortDescriptors = [dateSort]
        
        do {
            try self.memos = persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch memo: \(error.localizedDescription)")
        }
    }
    
    func addMemo(title: String, content: String) {
        let memo = Memo(context: persistentContainer.viewContext)
        memo.title = title
        memo.content = content
        memo.date = Date()
        saveContext()
    }
    
}
