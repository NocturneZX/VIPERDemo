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
    
    
    
    var coreDataStore: CoreDataStack?
    var dataManager: DataManager?
    var modelDecoder = JSONDecoder()
    
    var presenter: AchievementsPresenterProtocol!
    var interactor: AchievementsInteractorProtocol!
    var router: AchievementsRouter!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        XCTAssertNoThrow( try self.verifyJSON())
        XCTAssertNoThrow(try self.testModel())
        XCTAssertNoThrow( try self.testCoreDataFetch())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        coreDataStore = nil
        dataManager = nil
    }
    
    func verifyJSON() throws{
        // Verify that the JSON can be decoded. It shoudl not crash no matter how
        guard let url = Bundle.main.url(forResource: "achievements", withExtension: "json") else {
            //XCTAssert("NO file of that JSON exists")
            return XCTFail()
        }
        guard let data: Data = NSData(contentsOf: url) as Data? else {
            //XCTAssert("This file's data is corrupt.")
            return XCTFail()
        }
        
        // Verify that the JSON is in the correct format
        let json = try! JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String: Any]
        
        // if overview and achievements key/value pair are in the correct format on the JSON file
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
    }
    
    func testModel() throws{

        let overviewModel = try Overview.init(String(data: overviewData, encoding: String.Encoding.utf8)!)
        let achievementModel = try Achievements.init(String(data: achievementData, encoding: String.Encoding.utf8)!)
        
        XCTAssertNotNil(overviewModel)
        XCTAssertNotNil(achievementModel)
        XCTAssertNoThrow(try dataManager?.savePost(overview: overviewModel, achievements: [achievementModel]))
        
    }
    func testCoreDataFetch() throws{
        
        let predicate = NSPredicate(format: "accessible == true")
        let sortDescriptors = [NSSortDescriptor.init(key: "level", ascending: true)]
        var entries: [Investor] = []
        coreDataStore?.fetchEntriesWithPredicate(predicate: predicate, sortDescriptors: sortDescriptors, completionBlock: { entry in
            entries += entry
            print("Number of rows (Test): \(entry)") // Prints 0
            
        })
        XCTAssert(0 == entries.count, "This should not be empty.")
        
    }
    
    // MARK: - Testing Architecture
    func testArchitecture(){
        
        let testExpectation = expectation(description: #function)
        interactor = AchievementsInteractor()
        router = AchievementsRouter()
        presenter = AchievementsPresenter()
        
        let overviewModel = try! Overview.init(String(data: overviewData, encoding: String.Encoding.utf8)!)
        let achievementModel = try! Achievements.init(String(data: achievementData, encoding: String.Encoding.utf8)!)
        
        let investorModel = InvestorModel(overview: overviewModel, achievements: [achievementModel])

        XCTAssertNotNil(router)
        interactor.retrieveInvestorList()
        presenter.didRetrieveAchievements([investorModel])
        testExpectation.fulfill()
        
        waitForExpectations(timeout: 10.0, handler: nil)
    }
}


extension ProjectStashTests {
    class AchievementsPresenter: AchievementsPresenterProtocol{
        var view: AchievementsViewProtocol?
        
        var wireFrame: AchievementsWireframeProtocol?
        
        var interactor: AchievementsInteractorProtocol?
        
        var investor: InvestorModel?
        
        var didRetrieve  = false
        var didLoad = false
        
        func viewDidLoad() {
            didLoad = true
        }
        
        func didRetrieveAchievements(_ investor: [InvestorModel]) {
            didRetrieve = true
        }
        

    
    }
    
    class testInteractor: AchievementsInteractorProtocol{
        var presenter: AchievementsPresenterProtocol?
        
        var dataManager: LocalDataManagerInputProtocol?
        
        var didRetrieveList = false
        
        func retrieveInvestorList() {
            didRetrieveList = true
        }
        
    }
    
    class TestRouter: AchievementsWireframeProtocol{
        static func createAchievementsModule() -> UIViewController {
            return UIViewController()
        }
    }

}
