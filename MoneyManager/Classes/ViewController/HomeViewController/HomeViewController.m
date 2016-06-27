//
//  ViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@property (strong,nonatomic) NSMutableArray *arrTransactions;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInMonth;
@property (weak, nonatomic) IBOutlet UILabel *lbDayInWeek;
@property (weak, nonatomic) IBOutlet UILabel *lbDate;
@property (weak, nonatomic) IBOutlet UILabel *lbCashSumary;

@end

@implementation HomeViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //Setup tableview will cel lis TransactionCell
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionCell" bundle:nil] forCellReuseIdentifier:@"TransactionCell"];
    self.arrTransactions = [[NSMutableArray alloc] init];
    //Init Fake Data for tableview
    [self loadDataForTableView];
    //Load data for date
    [self loadDataForDate:[NSDate date]];
    [self.tableView reloadData];
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
- (void)loadDataForDate:(NSDate*)date {
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
}

- (void)loadDataForTableView {
    //Add 8 cell data to arrTransactions
    for (int i=0 ; i<8 ; i++) {
        TransactionModal *transasction = [[TransactionModal alloc] initWithCategory:@"Category test" note:@"Test Note" cost:1234.0];
        [self.arrTransactions addObject:transasction];
    }
}

#pragma mark - TableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrTransactions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Create Cell
    TransactionCell *cell = (TransactionCell *)[tableView dequeueReusableCellWithIdentifier:@"TransactionCell" forIndexPath:indexPath];
    TransactionModal *tran = (TransactionModal*)[self.arrTransactions objectAtIndex:indexPath.row];
    //Assign String to cell's label
    cell.lbCost.text = [NSString stringWithFormat:@"%.3f", tran.cost];
    cell.lbNote.text = tran.note;
    cell.lbCategory.text = tran.category;
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
            // Set title for button date picker
            [self loadDataForDate:date];
        }];
    }
}

@end
