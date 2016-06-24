//
//  ViewController.h
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactionCell.h"
#import "TransactionModal.h"
#import "DatePickerViewController.h"

@interface HomeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contrainTableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lbIncom;
@property (weak, nonatomic) IBOutlet UILabel *lbExpense;
@property (weak, nonatomic) IBOutlet UILabel *lbCashInReturn;
@property (weak, nonatomic) IBOutlet UIButton *btnPickDate;

@end

