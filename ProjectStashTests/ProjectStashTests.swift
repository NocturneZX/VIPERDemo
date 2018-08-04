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

    var overviewData = try! JSONSerialization.data(withJSONObject: [
        "title": "Smart Investing",
        "year" : "201564213"
        ]
        , options: .prettyPrinted)
    var achievementData = try! JSONSerialization.data(withJSONObject: ["id": 1,
                                                                       "level": "2",
                                                                       "progress": 20,
                                                                       "total": 50,
                                                                       "bg_image_url": "https://cdn.zeplin.io/5a5f7e1b4f9f24b874e0f19f/screens/C850B103-B8C5-4518-8631-168BB42FFBBD.png",
                                                                       "accessible": true ] , options: .prettyPrinted)
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        JSONexpectation = XCTestExpectation.init(description: "This is to make sure our JSON file given is valid.")
        CoreDataExpectation = XCTestExpectation.init(description: "This is to ensure the PSC is stable.")
        CoreDataExpectation?.expectedFulfillmentCount = 2
        
        XCTAssertNoThrow( try self.testJSON())
        XCTAssertNoThrow(try self.testModel())
        XCTAssertNoThrow( try self.testCoreDataFetch())
        self.wait(for: [JSONexpectation!, CoreDataExpectation!], timeout: 10.0)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coreDataStore = nil
        dataManager = nil
    }
    
    func testJSON() throws {
        
        guard let url = Bundle.main.url(forResource: "achievements", withExtension: "json") else {
            //XCTAssert("NO file of that JSON exists")
            return XCTFail()
        }
        guard let data: Data = NSData(contentsOf: url) as Data? else {
            //XCTAssert("This file's data is corrupt.")
            return XCTFail()
        }
        
        
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String: Any]
            
            // if overview and achievements key/value exists on the JSON file
            guard let overview = json["overview"] as? [String: AnyObject] else {
                return XCTFail()

            }
            
            guard let achievements = json["achievements"] as? [[String: AnyObject]] else {
                return XCTFail()
            }
            
            guard (overview["title"] as? String) != nil else{
                return XCTFail()
            }

            for achievement in achievements{
                guard let _ = achievement["id"] as? Int, let _ = achievement["level"] as? String, let _ = achievement["progress"] as? Int, let _ = achievement["bg_image_url"] as? String, let _ = achievement["total"] as? Int, let _ = achievement["accessible"] else{
                    return XCTFail()
                }
            }
            
            XCTAssertNotNil(try! Overview.init(data: self.overviewData))
            XCTAssertNotNil( try! Achievements.init(data: self.achievementData))

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
    }
    
    func testModel() throws{

            let modelDecoder = JSONDecoder()
            
            let overviewModel: Overview = try! modelDecoder.decode(Overview.self, from: overviewData)
            let achievementModel: Achievements = try! modelDecoder.decode(Achievements.self, from: achievementData)
        
        XCTAssertNoThrow(try dataManager?.savePost(overview: overviewModel, achievements: [achievementModel]))
        CoreDataExpectation?.fulfill()
        

    }
    func testCoreDataFetch() throws{

            let predicate = NSPredicate(format: "accessible == true")
            let sortDescriptors = [NSSortDescriptor.init(key: "level", ascending: true)]
            var entries: [Investor] = []
            coreDataStore?.fetchEntriesWithPredicate(predicate: predicate, sortDescriptors: sortDescriptors, completionBlock: { entry in
                entries = entry
                print("Number of rows (Test): \(entry)") // Prints 0
                
            })
            XCTAssert(0 == entries.count, "This should not be empty.")

        CoreDataExpectation?.fulfill()
    }
}
