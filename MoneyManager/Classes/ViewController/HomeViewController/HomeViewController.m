//
//  ViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "HomeViewController.h"
#import "Transaction.h"
#import "Wallet.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *arrTransactions;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInMonth;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInWeek;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbCashSumary;
@property (strong, nonatomic) NSDate *dateSelected;
@property (assign, nonatomic) double cashSumaryValue;
@property (assign, nonatomic) double inComeValue;
@property (assign, nonatomic) double expenseValue;
@property (assign, nonatomic) double cashInReturnValue;

@end

@implementation HomeViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Setup tableview will cel lis TransactionCell
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    self.arrTransactions = [[NSMutableArray alloc] init];
    self.dateSelected = [NSDate date];
    self.inComeValue = 0.0;
    self.expenseValue = 0.0;
    self.cashSumaryValue = 0.0;
    self.cashInReturnValue = 0.0;
    //Call Add Wallet IF open app for the first time
    if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]) checkFirstTimeRunning]) {
        [self performSegueWithIdentifier:@"AddWallet" sender:nil];
    } else {
        [self loadDataForDate:self.dateSelected];
    }
    [self loadOverviewInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    // Set Height of tableview is content of tableview to disable scroll of tableview
    self.contrainTableViewHeight.constant = self.tableView.contentSize.height;
}

#pragma mark - Data for tableview
- (void)loadOverviewInfo {
    // Get Sumary of income
    NSArray *wallets = [Wallet MR_findAll];
    double cashSum = 0.0;
    for (Wallet *wallet in wallets) {
        cashSum += [wallet.cash doubleValue];
    }
    self.inComeValue = cashSum;
    // Get Sumary of expense
    NSArray *transactions = [Transaction MR_findAll];
    double transactionCashSum = 0.0;
    for (Transaction *tran in transactions) {
        transactionCashSum += [tran.cost doubleValue];
    }
    self.expenseValue = transactionCashSum;
    //Update label
    self.cashInReturnValue = self.inComeValue - self.expenseValue;
    self.lbIncom.text = [NSString stringWithFormat:@"%.2f",self.inComeValue];
    self.lbExpense.text = [NSString stringWithFormat:@"%.2f",self.expenseValue];
    self.lbCashInReturn.text = [NSString stringWithFormat:@"%.2f",self.cashInReturnValue];
}

- (void)loadDataForDate:(NSDate*)date {
    /* Update labels */
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    [formatter setLocale:locale];
    [self.btnPickDate setTitle:[formatter stringFromDate:date] forState:UIControlStateNormal];
    //Set Date string for tableview header
    [formatter setDateFormat:@"dd"];
    self.lbDayInMonth.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"EEEE"];
    self.lbDayInWeek.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.lbDate.text = [formatter stringFromDate:date];
    /* Update transaction tableview */
    [self loadDataForTableViewInDate:date];
    
}

- (void)loadDataForTableViewInDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.arrTransactions = nil;
    self.arrTransactions = [Transaction MR_findByAttribute:@"date" withValue:[formatter stringFromDate:self.dateSelected]];
    self.cashSumaryValue = 0.0;
    if ([self.arrTransactions count] == 0) {
        self.lbCashSumary.text = [NSString stringWithFormat:@"%.2f",self.cashSumaryValue];
    }
    [self.tableView reloadData];
    [self.view layoutIfNeeded];
    // Set Height of tableview is content of tableview to disable scroll of tableview
    self.contrainTableViewHeight.constant = self.tableView.contentSize.height;
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrTransactions count];
}

-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // IF end of loading , update Overview
    if([indexPath row] == [self.arrTransactions count] - 1){
        self.lbCashSumary.text = [NSString stringWithFormat:@"%.2f",self.cashSumaryValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Create Cell
    TransactionCell *cell = (TransactionCell *)[tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    Transaction *tran = (Transaction*)[self.arrTransactions objectAtIndex:indexPath.row];
    self.cashSumaryValue += [tran.cost doubleValue];
//    //Assign String to cell's label
    cell.lbCost.text = [NSString stringWithFormat:@"%.0f", [tran.cost doubleValue]];
    cell.lbNote.text = tran.note;
    cell.lbCategory.text = tran.category.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Button Hanlder
- (IBAction)btnAddTransactionClick:(id)sender {
}

- (IBAction)btnPickDateClick:(id)sender {
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Call Back block when picked date
    if ([@"ShowDatePicker" isEqualToString:segue.identifier]) {
        DatePickerViewController *dateVC = (DatePickerViewController*)[segue destinationViewController];
        [dateVC didSelectDateWithBlock:^(NSDate *date) {
            NSLog(@"Date picked");
            self.dateSelected = date;
            [self loadDataForDate:self.dateSelected];
        }];
    }
    if ([@"AddWallet" isEqualToString:segue.identifier]) {
        UINavigationController *nav = [segue destinationViewController];
        AddWalletViewController *walletVC = (AddWalletViewController*)[nav.viewControllers firstObject];
        [walletVC didAddWalletWithBlock:^() {
            NSLog(@"Wallet Added");
            [self loadDataForDate:self.dateSelected];
            [self loadOverviewInfo];
        }];
    }
    if ([@"AddTransaction" isEqualToString:segue.identifier]) {
        AddTransactionViewController *tranVC = [segue destinationViewController];
        [tranVC didAddTransactionWithBlock:^() {
            NSLog(@"Transaction Added");
            [self loadDataForDate:self.dateSelected];
            [self loadOverviewInfo];
        }];
    }
}

@end
