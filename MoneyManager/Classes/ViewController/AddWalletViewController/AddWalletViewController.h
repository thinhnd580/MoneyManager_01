//
//  AddWalletViewController.h
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Wallet.h"
#import "Transaction.h"
#import "Category.h"
#import "AppDelegate.h"

@interface AddWalletViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtWalletName;
@property (weak, nonatomic) IBOutlet UITextField *txtCurrency;
@property (weak, nonatomic) IBOutlet UITextField *txtCash;

- (void)didAddWalletWithBlock:(void (^)())completion;

@end
