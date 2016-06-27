//
//  Wallet+CoreDataProperties.h
//  MoneyManager
//
//  Created by Thinh on 6/24/16.
//  Copyright © 2016 Thinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wallet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSNumber *cash;
@property (nullable, nonatomic, retain) NSNumber *sumToTotal;
@property (nullable, nonatomic, retain) NSManagedObject *transactions;

@end

NS_ASSUME_NONNULL_END
