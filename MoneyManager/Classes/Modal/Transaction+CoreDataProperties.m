//
//  Transaction+CoreDataProperties.m
//  MoneyManager
//
//  Created by Thinh on 6/24/16.
//  Copyright © 2016 Thinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Transaction+CoreDataProperties.h"

@implementation Transaction (CoreDataProperties)

@dynamic date;
@dynamic note;
@dynamic cost;
@dynamic picture;
@dynamic category;
@dynamic wallet;

@end
