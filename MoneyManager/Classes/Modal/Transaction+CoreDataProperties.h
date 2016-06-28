//
//  Transaction+CoreDataProperties.h
//  MoneyManager
//
//  Created by Thinh on 6/24/16.
//  Copyright © 2016 Thinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Transaction.h"

NS_ASSUME_NONNULL_BEGIN

@interface Transaction (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *cost;
@property (nullable, nonatomic, retain) NSData *picture;
@property (nullable, nonatomic, retain) Category *category;
@property (nullable, nonatomic, retain) Wallet *wallet;

@end

NS_ASSUME_NONNULL_END
