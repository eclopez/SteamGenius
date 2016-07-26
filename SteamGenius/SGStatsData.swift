//
//  SGStatsData.swift
//  SteamGenius
//
//  Created by Erik Lopez on 7/6/16.
//  Copyright © 2016 Erik Lopez. All rights reserved.
//

import Foundation
import CoreData

struct SGStatsData {
  var playerCasters = NSMutableOrderedSet()
  var opponentCasters = NSMutableOrderedSet()
  let totalBattles: Int
  
  init() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    let moc = appDelegate.managedObjectContext
    
    let filters = SGKRepository.findAllEntitiesOfType("BattleFilter", predicate: NSPredicate(format: "isActive = %@", true), context: moc)
    var compoundPredicate: NSCompoundPredicate?
    if filters.count > 0 {
      var predicates: Array<NSPredicate> = []
      for filter in filters {
        predicates.append(filter.predicate)
      }
      compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
    }
    
    let battles = SGKRepository.findAllEntitiesOfType("Battle", predicate: compoundPredicate, context: moc)
    if battles.count > 0 {
      for battle in battles {
        let playerCasterName = "\(battle.playerCaster!.model.shortName)\(battle.playerCaster!.model.incarnation)"
        let opponentCasterName = "\(battle.opponentCaster!.model.shortName)\(battle.opponentCaster!.model.incarnation)"
        
        let playerWinPredicate = NSPredicate(format: "playerCaster == %@ && result.winValue > 0", battle.playerCaster)
        let playerLossPredicate = NSPredicate(format: "playerCaster == %@ && result.winValue < 0", battle.playerCaster)
        let playerDrawPredicate = NSPredicate(format: "playerCaster == %@ && result.winValue == 0", battle.playerCaster)
        
        let opponentWinPredicate = NSPredicate(format: "opponentCaster == %@ && result.winValue > 0", battle.opponentCaster)
        let opponentLossPredicate = NSPredicate(format: "playerCaster == %@ && result.winValue < 0", battle.playerCaster)
        let opponentDrawPredicate = NSPredicate(format: "playerCaster == %@ && result.winValue == 0", battle.playerCaster)
        
        let totalPlayerWins = battles.filter() { playerWinPredicate.evaluateWithObject($0) }.count
        let totalPlayerLosses = battles.filter() { playerLossPredicate.evaluateWithObject($0) }.count
        let totalPlayerDraws = battles.filter() { playerDrawPredicate.evaluateWithObject($0) }.count
        
        let totalOpponentWins = battles.filter() { opponentWinPredicate.evaluateWithObject($0) }.count
        let totalOpponentLosses = battles.filter() { opponentLossPredicate.evaluateWithObject($0) }.count
        let totalOpponentDraws = battles.filter() { opponentDrawPredicate.evaluateWithObject($0) }.count
        
        
//        let battleCountByPlayer = battles.filter() { $0.playerCaster! == battle.playerCaster! }.count
//        let battleCountByOpponent = battles.filter() { $0.opponentCaster! == battle.opponentCaster! }.count
        
        self.playerCasters.addObject(SGCasterRecord(name: playerCasterName, totalWins: totalPlayerWins, totalLosses: totalPlayerLosses, totalDraws: totalPlayerDraws))
        self.opponentCasters.addObject(SGCasterRecord(name: opponentCasterName, totalWins: totalOpponentWins, totalLosses: totalOpponentLosses, totalDraws: totalOpponentDraws))
      }
      
      let battleCountSort = NSSortDescriptor(key: "battleCount", ascending: false)
      self.playerCasters.sortUsingDescriptors([battleCountSort])
      self.opponentCasters.sortUsingDescriptors([battleCountSort])
    }
    
    self.totalBattles = battles.count
  }
}