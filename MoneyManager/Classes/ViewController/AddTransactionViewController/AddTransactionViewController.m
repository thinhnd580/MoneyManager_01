//
//  AddTransactionViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "AddTransactionViewController.h"
#import "DatePickerViewController.h"
#import "Wallet.h"
#import "Transaction.h"
#import "Category.h"
#import "ActionSheetPicker.h"

@interface AddTransactionViewController () <UITextFieldDelegate>

@property (strong,nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong,nonatomic) Wallet *walletSelected;
@property (strong,nonatomic) NSDate *dateSelected;
@property (copy,nonatomic) void(^callBackBlock)();

@end

@implementation AddTransactionViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the
    //Add tap recognizer to dismiss keyboard when touch outside textfield
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    [self updateDate:[NSDate date]];
    //Set textfield delegate to self
    self.txtCost.delegate = self;
    self.txtCategory.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateDate:(NSDate*)date {
    self.dateSelected = date;
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

#pragma mark - Call back assign
- (void)didAddTransactionWithBlock:(void (^)())completion {
    self.callBackBlock = completion;
}

#pragma mark - Button handler
- (IBAction)btnCancelClick:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)btnDoneClick:(id)sender {
    if ([self checkInput]) {
        Category *category = [Category MR_findFirstByAttribute:@"name" withValue:self.txtCategory.text];
        // If category not found, create new one
        if (category == nil) {
            category = [Category MR_createEntity];
            category.name = self.txtCategory.text;
            category.type = [NSNumber numberWithInt:1];
        }
        //Create New Transaction
        Transaction *tran = [Transaction MR_createEntity];
        tran.category = category;
        tran.wallet = self.walletSelected;
        //Date
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd/MM/yyyy"];
        tran.date = [formatter stringFromDate:self.dateSelected];
        //Cash
        NSNumberFormatter *cash = [[NSNumberFormatter alloc] init];
        cash.numberStyle = NSNumberFormatterDecimalStyle;
        tran.cost = [cash numberFromString:self.txtCost.text];
        //Note
        tran.note = self.txtNote.text;
        //Save and Dismiss viewcontroller
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (!contextDidSave) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Some thing went wrong, try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                self.callBackBlock();
                [self.navigationController popViewControllerAnimated:true];
            }
        }];
    }
}

- (IBAction)btnWalletClick:(id)sender {
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
                                           NSLog(@"Picker: %@, Index: %ld, value: %@",
                                                 picker, (long)selectedIndex, selectedValue);
                                           self.walletSelected = [wallets objectAtIndex:selectedIndex];
                                           [self.btnWallet setTitle:selectedValue forState:UIControlStateNormal];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}

#pragma mark - Text Input handler
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtCategory) {
        if (textField.text.length >= 15 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    if (textField == self.txtCost) {
        if (textField.text.length >= 15 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    if (textField == self.txtNote) {
        if (textField.text.length >= 25 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    return YES;
}

- (void)dismissKeyboard {
    //Dismiss All keyboard for all textfield
    [self.txtCost resignFirstResponder];
    [self.txtNote resignFirstResponder];
    [self.txtCategory resignFirstResponder];
}

- (BOOL)checkInput {
    // Alert for missing information
    NSString *error;
    if ([self.txtCategory.text isEqual: @""]) {
        error = @"Category is Missing" ;
    }
    if ([self.txtCost.text isEqual: @""] || [self.txtCost.text isEqual: @"0"]) {
        error = @"Cash is Missing";
    }
    if (self.walletSelected == nil) {
        error = @"Wallet is Missing" ;
    }
    if (error == nil) {
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:@"Please check agian" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
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
