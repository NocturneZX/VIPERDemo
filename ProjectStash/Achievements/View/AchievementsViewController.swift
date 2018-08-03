//
//  AchievementsViewController.swift
//  ProjectStash
//
//  Created Julio Reyes on 7/25/18.
//  Copyright © 2018 Julio Reyes. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
class AchievementsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
	var presenter: AchievementsPresenterProtocol?
    
    var overview: Overview?
    var achievements: [Achievements] = []
    
	override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

}

extension AchievementsViewController: AchievementsViewProtocol {
    // Looking at how the challenge was set up, operating as if this view represents the detailed information of the investor since achievements are an assumed attribute of the investor
    func showAchievements(forInvestor investor: [InvestorModel]) {
        overview = investor[0].overview
        achievements = investor[0].achievements
        tableView.reloadData()
    }
}

extension AchievementsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementsIdentifier", for: indexPath) as! AchievementsTableViewCell
        cell.prepareForReuse()
        
        let post = achievements[indexPath.row]
        cell.setCell(forAchievements: post)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return achievements.count > 0 ? achievements.count : 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.masksToBounds = true;
        cell.contentView.layer.cornerRadius = 9.0;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 225
    }
}
