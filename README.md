# CoreData_Barebones
<br/>

### 프로젝트 소개
- Core Data의 기본적인 기능 구현을 익히는 데에 도움을 주는 Bare-bones 프로젝트입니다.
- Core Data를 통해 **SwiftUI 기반의 간단한 메모장**을 구현합니다.
- Core Data를 처음 활용해 보는 경우, 이 프로젝트의 코드를 살펴보면 도움이 됩니다.


https://user-images.githubusercontent.com/74223246/177270661-357162cf-39ce-4af4-b54d-f0d89725de5b.mp4



<br/>

### Core Data 란?   
Apple이 제공하는 [Core Data Programming Guide](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreData/index.html)는 Core Data를 이렇게 설명합니다.      

*“Core Data는 모델 계층의 객체를 관리하는 데 사용하는 프레임워크입니다.    
지속성을 포함하여 객체 수명 주기 및 객체 그래프 관리와 관련된 작업에 일반화 및 자동화된 솔루션을 제공합니다.”*     

쉽게 말해 Core Data는 **디바이스에 영구적인 데이터를 저장할 수 있게 해주는 프레임워크**입니다.     
따라서 해당 프로젝트인 메모장과 같이 오프라인 영구 저장소가 필요한 앱에 활용할 수 있습니다. 

Core Data가 데이터 모델 객체의 역할을 하기 때문에 모델을 따로 정의할 필요가 없습니다.   
[Core Data에서 모델을 생성하는 방법](https://codershigh.notion.site/Core-Data-16e1c71cf0824489b37d2b6036c8c3c9)에 대해 알아보세요.   

**Core Data Stack 알아보기**
<img width="700" alt="스크린샷 2022-07-06 오전 11 29 39" src="https://user-images.githubusercontent.com/74223246/177455146-61deeece-343b-4860-9a48-9ccd10f60ff7.png">
- **NSManagedObjectModel**의 인스턴스는 앱의 유형, 속성 및 관계를 설명하는 앱의 모델 파일을 나타냅니다.
- **NSManagedObjectContext**의 인스턴스는 앱 유형의 인스턴스에 대한 변경 사항을 추적합니다.
- **NSPersistentStoreCoordinator**의 인스턴스는 스토어에서 앱 유형 의 인스턴스를 저장하고 가져옵니다.    

**→ NSPersistentContainer의 인스턴스는 Model, Context 및 StoreCoordinator를 한 번에 설정합니다.**
<br/>
<br/>
<br/>

### 핵심 코드
Core Data에서 영구저장소 컨테이너를 다루고 컨텍스트를 저장하는 코드를 살펴보세요.   
데이터를 불러오고(fetch), 추가하고, 수정하고, 삭제하는(delete) 코드도 참고해 보세요.   

```Swift
// persistentContainer 생성 및 초기화 
// persistentContainer는 
let persistentContainer: NSPersistentContainer
    
init() {
    persistentContainer = NSPersistentContainer(name: "MemoModel")
    persistentContainer.loadPersistentStores { (description, error) in
        if let error = error {
            fatalError("Core Data Store failed: \(error.localizedDescription)")
        }
    }
}
```
```Swift
// 컨텍스트 저장 
// 추가, 수정, 삭제 후 호출됩니다.  
func saveContext() {
    do {
        try persistentContainer.viewContext.save()
    } catch {
        print("Failed to save context: \(error.localizedDescription)")
    }
}
```
```Swift
// 데이터 불러오기
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
```
```Swift
// 데이터 추가하기
func addMemo(title: String, content: String) {
    let memo = Memo(context: persistentContainer.viewContext)
    memo.title = title
    memo.content = content
    memo.date = Date()
    saveContext()
}
``` 
```Swift
// 데이터 수정하기
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
```
- SwiftUI에서 Core Data에 데이터를 write(추가 및 수정)할 때는, 추가 또는 업데이트하기 위한 별도의 메소드를 호출하지 않습니다. 추가하고자 하는 또는 업데이트하고자 하는 요소에 원하는 데이터를 넣어준 후 컨텍스트를 저장하기만 하면 됩니다. 🙊
```Swift
// 데이터 삭제하기 
func deleteMemo(memo: Memo) {
   persistentContainer.viewContext.delete(memo)
   saveContext()
}
```
