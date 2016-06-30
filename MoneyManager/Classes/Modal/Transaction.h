//
//  Transaction.h
//  MoneyManager
//
//  Created by Thinh on 6/30/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Category, Wallet;

NS_ASSUME_NONNULL_BEGIN

@interface Transaction : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Transaction+CoreDataProperties.h"
