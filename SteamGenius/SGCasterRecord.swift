//
//  SGCasterRecord.swift
//  SteamGenius
//
//  Created by Erik Lopez on 7/6/16.
//  Copyright © 2016 Erik Lopez. All rights reserved.
//

import Foundation

class SGCasterRecord: NSObject {
  let name: String
  let totalWins: Int
  let totalLosses: Int
  let totalDraws: Int
  var battleCount: Int {
    return totalWins + totalLosses + totalDraws;
  }
  
  init(name: String, totalWins: Int, totalLosses: Int, totalDraws: Int) {
    self.name = name
    self.totalWins = totalWins;
    self.totalLosses = totalLosses;
    self.totalDraws = totalDraws;
  }
}

extension SGCasterRecord {
  
  override func isEqual(object: AnyObject?) -> Bool {
    return self.name == object?.name
  }
}