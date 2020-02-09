//
//  CoreDataManager.swift
//  CoreDataTesting
//
//  Created by God Save The King on 1/30/20.
//  Copyright © 2020 Webcash. All rights reserved.
//

import Foundation
import CoreData

let DatabaseName    =   "Database"

class CoreDataManager {
    private init() {}
    static var shared : CoreDataManager {
        return CoreDataManager()
    }
    
    /// Database name
    let persistentContainer = NSPersistentContainer(name: DatabaseName)
    
    /// context
    var context : NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    /// Load data base
    func initalizeStack() {
        self.persistentContainer.loadPersistentStores { (description, error) in
            guard error == nil else {
                print("######## CoreDataManager ######## ~ Error : ",error?.localizedDescription ?? "")
                return
            }
            print("######## CoreDataManager ######## ~ Store Loaded")
        }
    }
    
    /// Insert object in to a database
    /// - Parameter obj: object to insert into a database
    func insert(obj : NSManagedObject) {
        self.context.insert(obj)
        do {
            try self.context.save()
            print("######## CoreDataManager ######## ~ Success - Save ")
        } catch {
            print("######## CoreDataManager ######## ~ Error - Save  : \(error.localizedDescription)")
        }
    }
    
    /// Get all record from a database
    /// - Parameter responseType: record type to get from a database
    func fetchAll<T:NSManagedObject>(responseType : T.Type, entityName : String) -> [T]? {
        
        
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        do {
            let fetchedResults = try self.context.fetch(fetchRequest)
            print("######## CoreDataManager ######## ~ Success - Fetch All")
            return fetchedResults
        } catch let error as NSError {
            // something went wrong, print the error.
            print("######## CoreDataManager ######## ~ Error - Fetch All : \(error.localizedDescription)")
            return nil
        }
//        
//        do {
//            let records = try self.context.fetch(responseType.fetchRequest() as! NSFetchRequest<T>)
//            print("######## CoreDataManager ######## ~ Success - Fetch All")
//            return records
//        } catch {
//            print("######## CoreDataManager ######## ~ Error - Fetch All : \(error.localizedDescription)")
//            return nil
//        }
    }
    
    /// Get records from a database
    /// - Parameters:
    ///   - predicate: condition to fetch
    ///   - responseType: record type to get from a database
    ///   - name: Entity (table) name
    func fetch<T:NSManagedObject> (withPredicate predicate : NSPredicate, responseType : T.Type, andEntityName name : String) -> [T]? {
        
        let request = NSFetchRequest<T>(entityName: name)
        request.predicate = predicate
        
        do {
            let records = try self.context.fetch(request)
            print("######## CoreDataManager ######## ~ Success - Fetch with Predicate")
            return records
        } catch {
            print("######## CoreDataManager ######## ~ Error - Fetch with Predicate : \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Update
    func update() -> Bool {
        do {
            try self.context.save()
            print("######## CoreDataManager ######## ~ Success - Update ")
            return true
        } catch {
            print("######## CoreDataManager ######## ~ Error - Update  : \(error.localizedDescription)")
            return false
        }
    }
    
    /// discards all changes since last save
    func rollBack() {
        self.context.rollback()
    }
    
    /// reverts last change
    func updo() {
        self.context.undo()
    }
    
    /// reverts last undo action
    func redo() {
        self.context.redo()
    }
    
}
