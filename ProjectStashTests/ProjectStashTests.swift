//
//  ProjectStashTests.swift
//  ProjectStashTests
//
//  Created by Julio Reyes on 7/25/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//

import XCTest
import CoreData
@testable import ProjectStash

enum ReceiverError: Error {
    /**
     Error trigge when the key is missed or the type.
     - Parameter key: Key missed.
     */
    case MissingKeyOrType(key: String)
}

class ProjectStashTests: XCTestCase {
    
    var JSONexpectation: XCTestExpectation?
    var CoreDataExpectation: XCTestExpectation?
    
    var coreDataStore: CoreDataStack?
    var dataManager: DataManager?
    var modelDecoder = JSONDecoder()

    let overviewData = try! JSONSerialization.data(withJSONObject: [
        "title": "Smart Investing",
        "year" : "201564213"
        ]
        , options: .prettyPrinted)
    let achievementData = try! JSONSerialization.data(withJSONObject: ["id": 1,
                                                                       "level": "2",
                                                                       "progress": 20,
                                                                       "total": 50,
                                                                       "bg_image_url": "https://cdn.zeplin.io/5a5f7e1b4f9f24b874e0f19f/screens/C850B103-B8C5-4518-8631-168BB42FFBBD.png",
                                                                       "accessible": true ] , options: .prettyPrinted)
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        JSONexpectation?.expectationDescription = "This is to make sure our JSON file given is valid."
        CoreDataExpectation?.expectedFulfillmentCount = 2
        
        XCTAssertTrue( try self.testJSON())
        XCTAssertNoThrow(try self.testModel())
        XCTAssertTrue( try self.testCoreDataFetch())
        self.wait(for: [JSONexpectation!, CoreDataExpectation!], timeout: 10.0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        JSONexpectation = nil
        CoreDataExpectation = nil
        coreDataStore = nil
        dataManager = nil
    }
    
    func testJSON() throws -> Bool{
        
        guard let url = Bundle.main.url(forResource: "achievements", withExtension: "json") else {
            //XCTAssert("NO file of that JSON exists")
            return false
        }
        guard let data: Data = NSData(contentsOf: url) as Data? else {
            //XCTAssert("This file's data is corrupt.")
            return false
        }
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String: Any]
            
            // if overview and achievements key/value exists on the JSON file
            guard let overview = json["overview"] as? [String: AnyObject] else {
                return false
            }
            
            guard let achievements = json["achievements"] as? [[String: AnyObject]] else {
                return false
            }
            
            guard let title = overview["title"] as? String else{
                return false
            }
            guard let year = overview["year"] as? String else{
                return false
            }
            
            let overviewTest: Overview = Overview(title: title, year: year)
            var achievementsTest: [Achievements] = []

            for achievement in achievements{
                guard let aid = achievement["id"] as? Int, let level = achievement["level"] as? String, let progress = achievement["progress"] as? Int, let url = achievement["bg_image_url"] as? String, let total = achievement["total"] as? Int, let accessible = achievement["accessible"] else{
                    return false
                }
                let achievementModel: Achievements = Achievements(id: aid, level: level, progress: progress, total: total, bgImageURL: url, accessible: accessible as! Bool)
                achievementsTest.append(achievementModel)
            }
            
            
            
        } catch  {
            XCTAssertNil("JSON not parsed")
        }
        
       // let expectedModel =  InvestorModel(investorOverview: [overviewModel], investorAchievements: [achievementModel])
        if let path = Bundle.main.path(forResource: "achievements", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try modelDecoder.decode(InvestorModel.self, from: data)
                print("jsonData:\(jsonObj)")
                XCTAssertNotNil(jsonObj)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            print("Invalid filename/path.")
        }
        
        JSONexpectation?.fulfill()
        return true
    }
    
    func testModel() throws{

            let modelDecoder = JSONDecoder()
            
            let overviewModel: Overview = try! modelDecoder.decode(Overview.self, from: overviewData)
            let achievementModel: Achievements = try! modelDecoder.decode(Achievements.self, from: achievementData)
            
            //let expectedModel =  InvestorModel(investorOverview: [overviewModel], investorAchievements: [achievementModel])
            
        XCTAssertNoThrow(try dataManager?.savePost(overview: overviewModel, achievements: [achievementModel]))
          CoreDataExpectation?.fulfill()
        

    }
    func testCoreDataFetch() throws -> Bool{

            let predicate = NSPredicate(format: "")
            let sortDescriptors = [] as [AnyObject]
            var entries: [Investor] = []
            coreDataStore?.fetchEntriesWithPredicate(predicate: predicate, sortDescriptors: sortDescriptors, completionBlock: { entry in
                entries = entry
                print("Number of rows (Test): \(entry)") // Prints 0
                
            })
            XCTAssert(1 == entries.count, "Incorrect number of rows in `Person` entity.")

        CoreDataExpectation?.fulfill()
        return true
    }
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    
}
