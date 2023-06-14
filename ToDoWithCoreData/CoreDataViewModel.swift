//
//  CoreDataViewModel.swift
//  ToDoWithCoreData
//
//  Created by Dr.Mac on 14/11/22.
//

import Foundation
import CoreData

class CoreDataViewModel: ObservableObject {
    
    let container: NSPersistentContainer
    @Published var savedEntities: [ListEntity] = []
    
    init() {
        container = NSPersistentContainer(name: "ListModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                 print("ERROR LOADING CORE DARA \(error)")
            }
        }
        fetchRequest()
    }
    
    func fetchRequest() {
        let request = NSFetchRequest<ListEntity>(entityName: "ListEntity")
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("ERROR WHILE FETCHING \(error)")
        }
    }
    
    func addItem(text: String) {
        let newItem = ListEntity(context: container.viewContext)
        newItem.workDescription = text
        newItem.isCompleted = false
        saveData()
    }
    
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func markItemCompleted(entity: ListEntity) {
        entity.isCompleted.toggle()
        saveData()
    }
    
    func updateItem(text: String, entity: ListEntity) {
//        let newDescriptio = text
        entity.workDescription = text
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchRequest()
        } catch let error {
            print("ERROR WHILE SAVING COREDATA \(error)")
        }
    }
}
