//
//  Wallet+CoreDataProperties.h
//  MoneyManager
//
//  Created by Thinh on 6/30/16.
//  Copyright © 2016 Thinh. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Wallet.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wallet (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *cash;
@property (nullable, nonatomic, retain) NSString *currency;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *sumToTotal;
@property (nullable, nonatomic, retain) NSOrderedSet<Transaction *> *transactions;

@end

@interface Wallet (CoreDataGeneratedAccessors)

- (void)insertObject:(Transaction *)value inTransactionsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromTransactionsAtIndex:(NSUInteger)idx;
- (void)insertTransactions:(NSArray<Transaction *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeTransactionsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInTransactionsAtIndex:(NSUInteger)idx withObject:(Transaction *)value;
- (void)replaceTransactionsAtIndexes:(NSIndexSet *)indexes withTransactions:(NSArray<Transaction *> *)values;
- (void)addTransactionsObject:(Transaction *)value;
- (void)removeTransactionsObject:(Transaction *)value;
- (void)addTransactions:(NSOrderedSet<Transaction *> *)values;
- (void)removeTransactions:(NSOrderedSet<Transaction *> *)values;

@end

NS_ASSUME_NONNULL_END
