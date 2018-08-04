//
//  DataManager.swift
//  ProjectStash
//
//  Created by Julio Reyes on 7/27/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import Foundation
import CoreData

class DataManager: LocalDataManagerInputProtocol{

    var CoreDataStore: CoreDataStack?
    var outputHandler: LocalDataManagerOutputProtocol?

    func retrieveInvestorList() throws -> [Investor] {
        guard ((CoreDataStore?.mainmanagedObjectContext) != nil) else {
            throw CoreDataError.managedObjectContextNotFound
        }
        let predicate = NSPredicate(format: "investorAchievements!=nil")
        let sortDescriptors = [] as [AnyObject]
        
        
       var investorList: [Investor] = []
        CoreDataStore?.fetchEntriesWithPredicate(predicate: predicate, sortDescriptors: sortDescriptors, completionBlock: { entries in
         investorList = entries
       })
        
        return investorList
    }

    
    func retrieveInformationFromJSON(){
        if let path = Bundle.main.path(forResource: "achievements", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try InvestorModel.init(data: data)
                try outputHandler?.onAchievementsRetrieved([jsonObj])
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
    }
}

extension DataManager{
    func savePost(overview: Overview, achievements: [Achievements]) throws {
        guard let moc = CoreDataStore?.mainmanagedObjectContext else {
            throw CoreDataError.managedObjectContextNotFound
        }
        
        guard let newInvestor = NSEntityDescription.entity(forEntityName: "Investor", in: moc) else {
            throw CoreDataError.objectNotFound
        }
        
        // To expidiate the process, I set up my structs so that it can be easily formatted and encoded into a JSON string that the data model can pull up 
        let coredataModel = try InvestorModel(overview: overview, achievements: achievements).jsonString()
        let investor = Investor(entity: newInvestor, insertInto: moc)
        investor.investorAchievements = coredataModel

        if moc.hasChanges {
            do {
                try moc.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(String(describing: nserror.localizedFailureReason))")
            }
        }
    }
}
