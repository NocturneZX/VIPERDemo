//
//  CoreDataStack.swift
//  ProjectStash
//
//  Created by Julio Reyes on 7/25/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import Foundation
import CoreData
import CoreText

enum CoreDataError: Error {
    case managedObjectContextNotFound
    case couldNotSaveObject
    case objectNotFound
    case pscNotFound
}


public final class CoreDataStack: NSObject {
    public private(set) var mainpersistentStoreCoordinator : NSPersistentStoreCoordinator?
    public private(set) var mainmanagedObjectModel : NSManagedObjectModel?
    public private(set) var mainmanagedObjectContext : NSManagedObjectContext?
    
    override init() {
        //Set up Model and PSC
        do {
            mainmanagedObjectModel = NSManagedObjectModel.mergedModel(from: nil)
            mainpersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mainmanagedObjectModel!)
            
            let options = [NSMigratePersistentStoresAutomaticallyOption : true, NSInferMappingModelAutomaticallyOption : true]
            
            try mainpersistentStoreCoordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: "", at: CoreDataStack.defaultStoreURL, options: options)
            mainmanagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            mainmanagedObjectContext!.persistentStoreCoordinator = mainpersistentStoreCoordinator
            mainmanagedObjectContext!.undoManager = nil
            
            super.init()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo), \(error.localizedDescription)")
        }
    }// end
    
    func fetchEntriesWithPredicate(predicate: NSPredicate, sortDescriptors: [AnyObject], completionBlock: (([Investor]) -> Void)!) {
        
        let fetchRequest: NSFetchRequest<Investor> = Investor.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors as? [NSSortDescriptor]
        
        mainmanagedObjectContext?.perform {
            let queryResults = try? self.mainmanagedObjectContext?.fetch(fetchRequest)
            let managedResults = queryResults as? [Investor]
            completionBlock(managedResults!)
        }
    }
    
}// end CoreDataStack

extension CoreDataStack{
    // Obtain the domains and directory of the stack and set up default names for the store. This is just a set-up mechanism that I thought I should set up to assume that this app might end up with more than one Store.
    public static var appName: String{
        let rawappName = Bundle.main.object(forInfoDictionaryKey:"CFBundleName") as! String
        return rawappName.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
    }
    public static var defaultStoreName: String{
        return "\( appName ).sqlite"
    }
    public static var defaultStoreURL: URL{
        let documentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return documentURL!.appendingPathComponent(defaultStoreName)
    }
}
