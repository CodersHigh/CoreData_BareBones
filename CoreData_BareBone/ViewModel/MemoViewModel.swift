//
//  MemoViewModel.swift
//  CoreData_BareBone
//
//  Created by 이로운 on 2022/07/05.
//

import Foundation
import CoreData

class MemoViewModel: ObservableObject {
    @Published var movies = [Memo]()
    
    let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Memo")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Core Data Store failed: \(error.localizedDescription)")
            }
        }
    }
    
    func updateMemo() {
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to update memo: \(error.localizedDescription)")
        }
    }
    
    func deleteMemo(memo: Memo) {
        persistentContainer.viewContext.delete(memo)
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to delete memo: \(error.localizedDescription)")
        }
    }
    
    func fetchMemo() -> [Memo] {
        let fetchRequest: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        do {
            return try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            return []
        }
    }
    
    func addMemo(title: String, content: String) {
        let memo = Memo(context: persistentContainer.viewContext)
        memo.title = title
        memo.content = content
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to add movie: \(error.localizedDescription)")
        }
    }
    
}
