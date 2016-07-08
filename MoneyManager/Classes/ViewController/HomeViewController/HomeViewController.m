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
#import "ActionSheetPicker.h"

@interface HomeViewController ()

@property (strong, nonatomic) NSArray *arrTransactions;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInMonth;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInWeek;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbCashSumary;
@property (weak, nonatomic) UIButton *walletBtn;
@property (strong, nonatomic) NSDate *dateSelected;
@property (assign, nonatomic) double cashSumaryValue;
@property (assign, nonatomic) double inComeValue;
@property (assign, nonatomic) double expenseValue;
@property (assign, nonatomic) double cashInReturnValue;
@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;
@property (strong, nonatomic) Wallet *walletSelected;

@end

@implementation HomeViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Create pick wallet at navigationbar
    self.walletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.walletBtn setTitle:@"Wallet:" forState:UIControlStateNormal];
    self.walletBtn.titleLabel.numberOfLines = 2;
    self.walletBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.walletBtn.frame = CGRectMake(50, 0, 80, 70);
    [self.walletBtn addTarget:self action:@selector(btnWalletClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.walletBtn];
    //Setup tableview will cel lis TransactionCell
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    self.arrTransactions = [[NSMutableArray alloc] init];
    //Init nsnumberformatter;
    self.currencyFormatter = [[NSNumberFormatter alloc] init];
    [self.currencyFormatter setMaximumFractionDigits:2];
    [self.currencyFormatter setMinimumFractionDigits:0];
    [self.currencyFormatter setAlwaysShowsDecimalSeparator:NO];
    [self.currencyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    //Init value
    self.dateSelected = [NSDate date];
    self.inComeValue = 0.0;
    self.expenseValue = 0.0;
    self.cashSumaryValue = 0.0;
    self.cashInReturnValue = 0.0;
    //Call Add Wallet IF open app for the first time
    if ([((AppDelegate*)[[UIApplication sharedApplication] delegate]) checkFirstTimeRunning]) {
        [self performSegueWithIdentifier:@"AddWallet" sender:nil];
    } else {
        NSString *walletSelectedString = [[NSUserDefaults standardUserDefaults] objectForKey:@"WALLET"];
        if (walletSelectedString == nil) {
            self.walletSelected = [Wallet MR_findFirst];
            // Wallet can't be nil so don't nessesary to check it
            [[NSUserDefaults standardUserDefaults] setObject:self.walletSelected.name forKey:@"WALLET"];
        } else {
            self.walletSelected = [Wallet MR_findFirstByAttribute:@"name" withValue:walletSelectedString];
            [self.walletBtn setTitle:[NSString stringWithFormat:@"Wallet: %@", walletSelectedString] forState:UIControlStateNormal];
        }
        [self loadOverviewInfoForWallet:self.walletSelected];
        [self loadDataForDate:self.dateSelected];
    }
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
- (void)loadOverviewInfoForWallet:(Wallet*)wallet {
    //Create NSNumber format with currency style
    // Get Sumary of income
    self.inComeValue = [wallet.cash doubleValue];
    // Get Sumary of expense
    NSArray *transactions = [wallet.transactions array];
    double transactionCashSum = 0.0;
    for (Transaction *tran in transactions) {
        transactionCashSum += [tran.cost doubleValue];
    }
    self.expenseValue = transactionCashSum;
    //Update label
    self.cashInReturnValue = self.inComeValue - self.expenseValue;
    self.lbIncom.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.inComeValue]];
    self.lbExpense.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.expenseValue]];
    self.lbCashInReturn.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.cashInReturnValue]];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"wallet.name == %@ AND date == %@", self.walletSelected.name,[formatter stringFromDate:date]];
    self.arrTransactions = [Transaction MR_findAllWithPredicate:predicate];
    self.cashSumaryValue = 0.0;
    if ([self.arrTransactions count] == 0) {
        self.lbCashSumary.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.cashSumaryValue]];
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
        self.lbCashSumary.text = [self.currencyFormatter stringFromNumber:[NSNumber numberWithDouble:self.cashSumaryValue]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Create Cell
    TransactionCell *cell = (TransactionCell *)[tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    Transaction *tran = (Transaction*)[self.arrTransactions objectAtIndex:indexPath.row];
    self.cashSumaryValue += [tran.cost doubleValue];
    //Assign String to cell's label
    cell.lbCost.text = [self.currencyFormatter stringFromNumber:tran.cost];
    cell.lbNote.text = tran.note;
    cell.lbCategory.text = tran.category.name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Transaction *tran = (Transaction*)[self.arrTransactions objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditTransaction" sender:tran];
}

#pragma mark - Button Hanlder
- (void)btnWalletClick:(id)sender {
    NSArray *wallets = [Wallet MR_findAll];
    // Get all Wallet name
    NSMutableArray *walletNames = [[NSMutableArray alloc] init];
    for (Wallet *wallet in wallets) {
        [walletNames addObject:wallet.name];
        NSLog(@"%@",wallet.name);
    }
    [ActionSheetStringPicker showPickerWithTitle:@"Select wallet"
                                            rows:walletNames
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           // Reload Data for selected Wallet
                                           self.walletSelected = [wallets objectAtIndex:selectedIndex];
                                           [[NSUserDefaults standardUserDefaults] setObject:self.walletSelected.name forKey:@"WALLET"];
                                           [self loadDataForDate:self.dateSelected];
                                           [self loadOverviewInfoForWallet:self.walletSelected];
                                           [self.walletBtn setTitle:[NSString stringWithFormat:@"Wallet: %@", selectedValue] forState:UIControlStateNormal];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

- (IBAction)btnAddTransactionClick:(id)sender {
}

- (IBAction)btnPickDateClick:(id)sender {
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //Call Back block when picked date
    if ([@"ShowDatePicker" isEqualToString:segue.identifier]) {
        DatePickerViewController *dateVC = (DatePickerViewController*)[segue destinationViewController];
        dateVC.dateWillDisplay = self.dateSelected;
        [dateVC didSelectDateWithBlock:^(NSDate *date) {
            NSLog(@"Date picked");
            self.dateSelected = date;
            [self loadDataForDate:self.dateSelected];
        }];
    }
    if ([@"AddWallet" isEqualToString:segue.identifier]) {
        UINavigationController *nav = [segue destinationViewController];
        AddWalletViewController *walletVC = (AddWalletViewController*)[nav.viewControllers firstObject];
        [walletVC didAddWalletWithBlock:^(Wallet *wallet) {
            NSLog(@"Wallet Added");
            self.walletSelected = wallet;
            [[NSUserDefaults standardUserDefaults] setObject:self.walletSelected.name forKey:@"WALLET"];
            [self loadDataForDate:self.dateSelected];
            [self loadOverviewInfoForWallet:self.walletSelected];
            [self.walletBtn setTitle:[NSString stringWithFormat:@"Wallet: %@", self.walletSelected.name] forState:UIControlStateNormal];
        }];
    }
    if ([@"AddTransaction" isEqualToString:segue.identifier]) {
        AddTransactionViewController *tranVC = [segue destinationViewController];
        [tranVC didAddTransactionWithBlock:^() {
            NSLog(@"Transaction Added");
            [self loadDataForDate:self.dateSelected];
            [self loadOverviewInfoForWallet:self.walletSelected];
        }];
    }
    if ([@"EditTransaction" isEqualToString:segue.identifier]) {
        AddTransactionViewController *tranVC = [segue destinationViewController];
        tranVC.transactionMode = TransactionModeEdit;
        tranVC.transaction = sender;
        [tranVC didAddTransactionWithBlock:^{
            NSLog(@"Transaction Edited");
            [self loadDataForDate:self.dateSelected];
            [self loadOverviewInfoForWallet:self.walletSelected];
        }];
    }
}

@end
