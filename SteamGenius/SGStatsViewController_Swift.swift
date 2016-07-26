//
//  SGStatsViewController_Swift.swift
//  SteamGenius
//
//  Created by Erik Lopez on 7/5/16.
//  Copyright © 2016 Erik Lopez. All rights reserved.
//

import UIKit

class SGStatsViewController_Swift: UIViewController {

  static let statsCell = "StatsCell"
  @IBOutlet weak var tableView: UITableView!
  var stats: SGStatsData?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    stats = SGStatsData()
  }
  
}

extension SGStatsViewController_Swift: UITableViewDataSource, UITableViewDelegate {
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let stats = stats {
      if section == 0 {
        return stats.playerCasters.count
      } else {
        return stats.opponentCasters.count
      }
    } else {
      return 0;
    }
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(SGStatsViewController_Swift.statsCell, forIndexPath: indexPath) as! SGStatsCell
    
    if let stats = stats {
      if indexPath.section == 0 {
        let playerCasterName = (stats.playerCasters[indexPath.row] as! SGCasterRecord).name
        cell.nameLabel.text = "\(playerCasterName)"
        cell.winLabel.text = "\((stats.playerCasters[indexPath.row] as! SGCasterRecord).totalWins)"
        cell.drawLabel.text = "\((stats.playerCasters[indexPath.row] as! SGCasterRecord).totalDraws)"
        cell.lossLabel.text = "\((stats.playerCasters[indexPath.row] as! SGCasterRecord).totalLosses)"
      } else {
        let opponentCasterName = (stats.opponentCasters[indexPath.row] as! SGCasterRecord).name
        cell.nameLabel.text = "\(opponentCasterName)"
        cell.winLabel.text = "\((stats.opponentCasters[indexPath.row] as! SGCasterRecord).totalWins)"
        cell.drawLabel.text = "\((stats.opponentCasters[indexPath.row] as! SGCasterRecord).totalDraws)"
        cell.lossLabel.text = "\((stats.opponentCasters[indexPath.row] as! SGCasterRecord).totalLosses)"
      }
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "My casters";
    } else {
      return "Opponent's casters"
    }
  }
}
