//
//  Wallet+CoreDataProperties.m
//  MoneyManager
//
//  Created by Thinh on 6/24/16.
//  Copyright © 2016 Thinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet+CoreDataProperties.h"

@implementation Wallet (CoreDataProperties)

@dynamic name;
@dynamic currency;
@dynamic cash;
@dynamic sumToTotal;
@dynamic transactions;

@end
