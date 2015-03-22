//
//  SteamGeniusTests.m
//  SteamGeniusTests
//
//  Created by Erik Lopez on 9/10/14.
//  Copyright (c) 2014 Erik Lopez. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "SGDataImport.h"
#import "SGGenericRepository.h"
#import "SGRepository.h"

@interface SteamGeniusTests : XCTestCase

@property (strong, nonatomic) NSManagedObjectContext *moc;

@end

@implementation SteamGeniusTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _moc = [self managedObjectContextForTests];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    _moc = nil;
}

- (void)testAddGame {
    // Act
    [SGDataImport importDataForEntityNamed:@"Game" version:1 entityType:SGEntityType_Game plistFileNamed:@"Game" context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Game"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(2, [arr count]);
}

- (void)testAddFaction {
    // Act
    [SGDataImport importDataForEntityNamed:@"Game" version:1 entityType:SGEntityType_Game plistFileNamed:@"Game" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Faction" version:1 entityType:SGEntityType_Faction plistFileNamed:@"Faction" context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Game"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(2, [arr count]);
}

- (void)testAddModel {
    // Act
    [SGDataImport importDataForEntityNamed:@"Game" version:1 entityType:SGEntityType_Game plistFileNamed:@"Game" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Faction" version:1 entityType:SGEntityType_Faction plistFileNamed:@"Faction" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Model" version:1 entityType:SGEntityType_Model plistFileNamed:@"Model" context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Model"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(149, [arr count]);
}

- (void)testAddResult {
    // Act
    [SGDataImport importDataForEntityNamed:@"Result" version:1 entityType:SGEntityType_Result plistFileNamed:@"Result" context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Result"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(19, [arr count]);
}

- (void)testAddOpponent {
    // Act
    [SGRepository initWithOpponentNamed:@"Nathan" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jimmy" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jeff" context:_moc];
    [SGRepository initWithOpponentNamed:@"Clayton" context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(4, [arr count]);
}

- (void)testUpdateOpponent {
    // Arrange
    [SGRepository initWithOpponentNamed:@"Nathan" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jimmy" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jeff" context:_moc];
    [SGRepository initWithOpponentNamed:@"Clayton" context:_moc];
    
    // Act
    Opponent *jeff = [SGGenericRepository findOneEntityOfType:@"Opponent" entityKey:@"Jeff" keyField:@"name" context:_moc];
    jeff.name = @"Ian";
    Opponent *ian = [SGGenericRepository findOneEntityOfType:@"Opponent" entityKey:@"Ian" keyField:@"name" context:_moc];
    
    // Assert
    XCTAssertEqual(jeff, ian);
}

- (void)testDeleteOpponent {
    // Arrange
    [SGRepository initWithOpponentNamed:@"Nathan" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jimmy" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jeff" context:_moc];
    [SGRepository initWithOpponentNamed:@"Clayton" context:_moc];
    
    // Act
    Opponent *jeff = [SGGenericRepository findOneEntityOfType:@"Opponent" entityKey:@"Jeff" keyField:@"name" context:_moc];
    [_moc deleteObject:jeff];
    
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Opponent"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(3, [arr count]);
}

- (void)testDeleteOpponentInBattles {
    // Arrange
    [SGDataImport importDataForEntityNamed:@"Game" version:1 entityType:SGEntityType_Game plistFileNamed:@"Game" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Faction" version:1 entityType:SGEntityType_Faction plistFileNamed:@"Faction" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Model" version:1 entityType:SGEntityType_Model plistFileNamed:@"Model" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Caster" version:1 entityType:SGEntityType_Caster plistFileNamed:@"Caster" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Result" version:1 entityType:SGEntityType_Result plistFileNamed:@"Result" context:_moc];
    
    [SGRepository initWithOpponentNamed:@"Nathan" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jimmy" context:_moc];
    [SGRepository initWithOpponentNamed:@"Jeff" context:_moc];
    [SGRepository initWithOpponentNamed:@"Clayton" context:_moc];
    
    Model *playerModel = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:@"Issyria, Sibyl of Dawn" keyField:@"name" context:_moc];
    Caster *playerCaster = [SGGenericRepository findOneEntityOfType:@"Caster" entityKey:playerModel keyField:@"model" context:_moc];
    Model *opponentModel = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:@"Makeda" keyField:@"name" context:_moc];
    Caster *opponentCaster = [SGGenericRepository findOneEntityOfType:@"Caster" entityKey:opponentModel keyField:@"model" context:_moc];
    Result *result = [SGGenericRepository findOneEntityOfType:@"Result" entityKey:@3 keyField:@"displayOrder" context:_moc];
    Opponent *opponent = [SGGenericRepository findOneEntityOfType:@"Opponent" entityKey:@"Jeff" keyField:@"name" context:_moc];
    
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:opponent date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    
    // Act
    [_moc deleteObject:opponent];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Battle"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"opponent = %@", nil];
    [req setPredicate:pred];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(7, [arr count]);
}

- (void)testAddEvent {
    // Act
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Journeyman" location:@"Game Store" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Steamroller 2014" location:@"Gencon" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Fun time" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(5, [arr count]);
}

- (void)testUpdateEvent {
    // Arrange
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Journeyman" location:@"Game Store" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Steamroller 2014" location:@"Gencon" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Fun time" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    
    // Act
    Event *journeyman = [SGGenericRepository findOneEntityOfType:@"Event" entityKey:@"Journeyman" keyField:@"name" context:_moc];
    journeyman.name = @"Saturday night";
    Event *saturday = [SGGenericRepository findOneEntityOfType:@"Event" entityKey:@"Saturday night" keyField:@"name" context:_moc];
    
    // Assert
    XCTAssertEqual(journeyman, saturday);
}

- (void)testDeleteEvent {
    // Arrange
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Journeyman" location:@"Game Store" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Steamroller 2014" location:@"Gencon" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Fun time" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    
    // Act
    Event *event = [SGGenericRepository findOneEntityOfType:@"Event" entityKey:@"Steamroller 2014" keyField:@"name" context:_moc];
    [_moc deleteObject:event];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Event"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(4, [arr count]);
}

- (void)testDeleteEventInBattles {
    // Arrange
    [SGDataImport importDataForEntityNamed:@"Game" version:1 entityType:SGEntityType_Game plistFileNamed:@"Game" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Faction" version:1 entityType:SGEntityType_Faction plistFileNamed:@"Faction" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Model" version:1 entityType:SGEntityType_Model plistFileNamed:@"Model" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Caster" version:1 entityType:SGEntityType_Caster plistFileNamed:@"Caster" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Result" version:1 entityType:SGEntityType_Result plistFileNamed:@"Result" context:_moc];
    
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Tournament" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    [SGRepository initWithEventNamed:@"Journeyman" location:@"Game Store" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Steamroller 2014" location:@"Gencon" date:[NSDate date] isTournament:YES context:_moc];
    [SGRepository initWithEventNamed:@"Fun time" location:@"Basement" date:[NSDate date] isTournament:NO context:_moc];
    
    Model *playerModel = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:@"Issyria, Sibyl of Dawn" keyField:@"name" context:_moc];
    Caster *playerCaster = [SGGenericRepository findOneEntityOfType:@"Caster" entityKey:playerModel keyField:@"model" context:_moc];
    Model *opponentModel = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:@"Makeda" keyField:@"name" context:_moc];
    Caster *opponentCaster = [SGGenericRepository findOneEntityOfType:@"Caster" entityKey:opponentModel keyField:@"model" context:_moc];
    Result *result = [SGGenericRepository findOneEntityOfType:@"Result" entityKey:@3 keyField:@"displayOrder" context:_moc];
    Event *event = [SGGenericRepository findOneEntityOfType:@"Event" entityKey:@"Steamroller 2014" keyField:@"name" context:_moc];
    
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:nil controlPoints:nil opponentControlPoints:nil event:event notes:nil context:_moc];
    
    // Act
    [_moc deleteObject:event];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Battle"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"event = %@", nil];
    [req setPredicate:pred];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(7, [arr count]);
}

- (void)testAddScenario {
    // Act
    [SGRepository initWithScenarioNamed:@"Mangled Metal" context:_moc];
    [SGRepository initWithScenarioNamed:@"Bunny Foo Foo" context:_moc];
    [SGRepository initWithScenarioNamed:@"Attack!" context:_moc];
    [SGRepository initWithScenarioNamed:@"Mother Goose" context:_moc];
    [SGRepository initWithScenarioNamed:@"Burned Popcorn" context:_moc];
    [SGRepository initWithScenarioNamed:@"Misdirected Rage" context:_moc];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Scenario"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(6, [arr count]);
}

- (void)testUpdateScenario {
    // Arrange
    [SGRepository initWithScenarioNamed:@"Mangled Metal" context:_moc];
    [SGRepository initWithScenarioNamed:@"Bunny Foo Foo" context:_moc];
    [SGRepository initWithScenarioNamed:@"Attack!" context:_moc];
    [SGRepository initWithScenarioNamed:@"Mother Goose" context:_moc];
    [SGRepository initWithScenarioNamed:@"Burned Popcorn" context:_moc];
    [SGRepository initWithScenarioNamed:@"Misdirected Rage" context:_moc];
    
    // Act
    Scenario *bunnyFooFoo = [SGGenericRepository findOneEntityOfType:@"Scenario" entityKey:@"Bunny Foo Foo" keyField:@"name" context:_moc];
    bunnyFooFoo.name = @"Forest hopping";
    Scenario *forest = [SGGenericRepository findOneEntityOfType:@"Scenario" entityKey:@"Forest hopping" keyField:@"name" context:_moc];
    
    // Assert
    XCTAssertEqual(bunnyFooFoo, forest);
}

- (void)testDeleteScenario {
    // Arrange
    [SGRepository initWithScenarioNamed:@"Mangled Metal" context:_moc];
    [SGRepository initWithScenarioNamed:@"Bunny Foo Foo" context:_moc];
    [SGRepository initWithScenarioNamed:@"Attack!" context:_moc];
    [SGRepository initWithScenarioNamed:@"Mother Goose" context:_moc];
    [SGRepository initWithScenarioNamed:@"Burned Popcorn" context:_moc];
    [SGRepository initWithScenarioNamed:@"Misdirected Rage" context:_moc];
    
    // Act
    Scenario *scenario = [SGGenericRepository findOneEntityOfType:@"Scenario" entityKey:@"Mangled Metal" keyField:@"name" context:_moc];
    [_moc deleteObject:scenario];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Scenario"];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(5, [arr count]);
}

- (void)testDeleteScenarioInBattles {
    // Arrange
    [SGDataImport importDataForEntityNamed:@"Game" version:1 entityType:SGEntityType_Game plistFileNamed:@"Game" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Faction" version:1 entityType:SGEntityType_Faction plistFileNamed:@"Faction" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Model" version:1 entityType:SGEntityType_Model plistFileNamed:@"Model" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Caster" version:1 entityType:SGEntityType_Caster plistFileNamed:@"Caster" context:_moc];
    [SGDataImport importDataForEntityNamed:@"Result" version:1 entityType:SGEntityType_Result plistFileNamed:@"Result" context:_moc];
    
    [SGRepository initWithScenarioNamed:@"Mangled Metal" context:_moc];
    [SGRepository initWithScenarioNamed:@"Bunny Foo Foo" context:_moc];
    [SGRepository initWithScenarioNamed:@"Attack!" context:_moc];
    [SGRepository initWithScenarioNamed:@"Mother Goose" context:_moc];
    [SGRepository initWithScenarioNamed:@"Burned Popcorn" context:_moc];
    [SGRepository initWithScenarioNamed:@"Misdirected Rage" context:_moc];
    
    Model *playerModel = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:@"Issyria, Sibyl of Dawn" keyField:@"name" context:_moc];
    Caster *playerCaster = [SGGenericRepository findOneEntityOfType:@"Caster" entityKey:playerModel keyField:@"model" context:_moc];
    Model *opponentModel = [SGGenericRepository findOneEntityOfType:@"Model" entityKey:@"Makeda" keyField:@"name" context:_moc];
    Caster *opponentCaster = [SGGenericRepository findOneEntityOfType:@"Caster" entityKey:opponentModel keyField:@"model" context:_moc];
    Result *result = [SGGenericRepository findOneEntityOfType:@"Result" entityKey:@3 keyField:@"displayOrder" context:_moc];
    Scenario *scenario = [SGGenericRepository findOneEntityOfType:@"Scenario" entityKey:@"Mangled Metal" keyField:@"name" context:_moc];
    
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    [SGRepository initWithPlayerCaster:playerCaster opponentCaster:opponentCaster opponent:nil date:[NSDate date] points:@25 result:result killPoints:nil scenario:scenario controlPoints:nil opponentControlPoints:nil event:nil notes:nil context:_moc];
    
    // Act
    [_moc deleteObject:scenario];
    
    // Assert
    NSFetchRequest *req = [[NSFetchRequest alloc] initWithEntityName:@"Battle"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"scenario = %@", nil];
    [req setPredicate:pred];
    NSArray *arr = [_moc executeFetchRequest:req error:nil];
    XCTAssertEqual(7, [arr count]);
}


/*- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}*/

#pragma mark - Class Methods

- (NSManagedObjectContext *)managedObjectContextForTests {
    static NSManagedObjectModel *model = nil;
    if (!model) {
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
    }
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    NSAssert(store, @"Should have store");
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    context.persistentStoreCoordinator = coordinator;
    return context;
}

@end
