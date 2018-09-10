//
//  CoreDataUtil.swift
//  TechReviewCoreData
//
//  Created by jhunter on 2018/9/10.
//  Copyright © 2018 jhunter. All rights reserved.
//

import UIKit
import CoreData

class CoreDataUtil: NSObject {
    static let shared = CoreDataUtil()
    
    /// delete all records in core data database
    func resetCoreData(completion: @escaping (UInt64) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(0)
            return
        }
//        let stores = appDelegate.persistentContainer.persistentStoreCoordinator.persistentStores
//        for store in stores {
//            if let url = store.url {
//                print("\(url)")
//            }
//        }
        let contex = appDelegate.persistentContainer.viewContext
        let fetchReq = NSFetchRequest<Person>(entityName: "Person") as! NSFetchRequest<NSFetchRequestResult>
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchReq)
        do {
            try contex.execute(batchDeleteRequest)
            appDelegate.saveContext()
        } catch {
            print("\(error)")
        }
        completion(0)
    }
    
    /// insert 1000000 records to benchmark insert performance
    func testInsertOperation(completion: @escaping (UInt64) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(0)
            return
        }
        let context = appDelegate.persistentContainer.viewContext

        let beginNano = Ticktock.shared.absluteTime()
        for index in 0..<10000 {
            let person = newPerson(context)
            person.id = Int64(index)
            person.address = "我是一个地址"
            person.age = 10
            person.gender = index % 2 == 0
            person.cellphone = "13800000001"
            person.name = String(format: "人名: %06ld", index)
        }
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        let endNano = Ticktock.shared.absluteTime()
        let cost = Ticktock.shared.convert(beginNano, end: endNano)
        print("[Core Data] - Insert cost is \(cost) ms")
        completion(cost)
    }

    /// query from 1000000 records to benchmark query performance
    func testQueryOperation(completion: @escaping (UInt64) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(0)
            return
        }

        let fetchRequest = Person.personFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == \(true)", #keyPath(Person.gender))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Person.id), ascending: true)]
        let contex = appDelegate.persistentContainer.viewContext
        do {
            let beginNano = Ticktock.shared.absluteTime()
            let result: [Person] = try contex.fetch(fetchRequest)
//            for person in result {
//                print("Name: \(String(describing: person.name)), mobile: \(String(describing: person.cellphone)), age: \(person.age), gender: \(person.gender ? "male" : "female")")
//            }
            print("[Core Data] - Fetch result count: \(result.count)")
            let endNano = Ticktock.shared.absluteTime()
            let cost = Ticktock.shared.convert(beginNano, end: endNano)
            print("[Core Data] - Query cost is \(cost) ms")
            completion(cost)
        } catch {
            print("[Core Data] - Fetch error: \(error.localizedDescription)")
            completion(0)
        }
    }
    
    /// update some records from 1000000 records to benchmark update performance
    func testUpdateOperation(completion: @escaping (UInt64) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(0)
            return
        }

        let fetchRequest = Person.personFetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == \(true)", #keyPath(Person.gender))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Person.id), ascending: true)]
        let contex = appDelegate.persistentContainer.viewContext
        do {
            let beginNano = Ticktock.shared.absluteTime()
            let result: [Person] = try contex.fetch(fetchRequest)
            for person in result {
                person.cellphone = String(format: "13800%06ld", person.id)
                person.age = Int16(person.id % 32767)
            }
            appDelegate.saveContext()
            let endNano = Ticktock.shared.absluteTime()
            let cost = Ticktock.shared.convert(beginNano, end: endNano)
            print("[Core Data] - Update cost is \(cost) ms, count is \(result.count)")
            completion(cost)
        } catch {
            print("[Core Data] - Fetch error: \(error.localizedDescription)")
            completion(0)
        }
    }
    
    // MARK: - Private methods
    private func newPerson(_ context: NSManagedObjectContext) -> Person {
        let entityDecription = NSEntityDescription.entity(forEntityName: "Person", in: context)!
        let entity = Person(entity: entityDecription, insertInto: context)
        return entity
    }
}
