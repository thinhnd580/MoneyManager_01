//
//  AddTransactionViewController.h
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HomeViewController.h"
#import "Wallet.h"
#import "Transaction.h"
#import "Category.h"

@interface AddTransactionViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtCategory;
@property (weak, nonatomic) IBOutlet UITextField *txtCost;
@property (weak, nonatomic) IBOutlet UITextField *txtNote;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInWeek;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInMonth;
@property (weak, nonatomic) IBOutlet UILabel *lbMonthYear;
@property (weak, nonatomic) IBOutlet UIButton *btnWallet;
@property (weak, nonatomic) IBOutlet UIButton *btnPicture;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIImageView *imgAdded;
@property (assign, nonatomic) NSUInteger transactionMode;
@property (strong, nonatomic) Transaction *transaction;

- (void)didAddTransactionWithBlock:(void (^)())completion;

@end
