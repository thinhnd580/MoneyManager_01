//
//  AddTransactionViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "DatePickerViewController.h"

@interface AddTransactionViewController ()

@property (strong,nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation AddTransactionViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the
    //Add tap recognizer to dismiss keyboard when touch outside textfield
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDate:(NSDate*)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"vi_VN"];
    [formatter setLocale:locale];
    //Set Date string for tableview header
    [formatter setDateFormat:@"dd"];
    self.lbDayInMonth.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"EEEE"];
    self.lbDayInWeek.text = [formatter stringFromDate:date];
    [formatter setDateFormat:@"MM yyyy"];
    self.lbMonthYear.text = [NSString stringWithFormat:@"Tháng %@",[formatter stringFromDate:date]];
}

#pragma mark - Button handler
- (IBAction)btnCancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnDoneClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - Text Input handler
- (void)dismissKeyboard {
    //Dismiss All keyboard for all textfield
    [self.txtCost resignFirstResponder];
    [self.txtNote resignFirstResponder];
    [self.txtCategory resignFirstResponder];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DatePickerViewController *dateVC = (DatePickerViewController*)[segue destinationViewController];
    //Update date when user done select date
    [dateVC didSelectDateWithBlock:^(NSDate *date) {
        NSLog(@"Date picked");
        // Set title for button date picker
        [self updateDate:date];
    }];
}

@end
