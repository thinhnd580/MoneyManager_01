//
//  Category+CoreDataProperties.h
//  MoneyManager
//
//  Created by Thinh on 6/30/16.
//  Copyright © 2016 Thinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Category.h"

NS_ASSUME_NONNULL_BEGIN

@interface Category (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *type;
@property (nullable, nonatomic, retain) NSSet<Transaction *> *transactions;

@end

@interface Category (CoreDataGeneratedAccessors)

- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSSet<Transaction *> *)values;
- (void)removeTransactions:(NSSet<Transaction *> *)values;

@end

NS_ASSUME_NONNULL_END
