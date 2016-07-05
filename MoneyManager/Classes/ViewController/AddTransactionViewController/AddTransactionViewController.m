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

@interface AddTransactionViewController () <UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) Wallet *walletSelected;
@property (strong, nonatomic) NSDate *dateSelected;
@property (assign, nonatomic) double costValue;
@property (copy, nonatomic) void(^callBackBlock)();

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
    self.costValue = 0.0;
    [self.txtCost addTarget:self action:@selector(textfieldCostDidChangeText) forControlEvents:UIControlEventEditingChanged];
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
        tran.cost = [NSNumber numberWithDouble:self.costValue];
        //Note
        tran.note = self.txtNote.text;
        //Image if picked
        if (self.imgAdded.image != nil) {
            NSData *imageData = UIImagePNGRepresentation(self.imgAdded.image);
            tran.picture = imageData;
        }
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
                                     } origin:sender];
}

- (IBAction)btnPictureClick:(id)sender {
    //PhotoLibrary
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)btnCameraClick:(id)sender {
    //Camera
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - ImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //Set image to view
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imgAdded.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
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
        } else if ([textField.text containsString:@"."] && [string isEqualToString:@"."]) {
            return NO;
        } else if ([textField.text length] == 0 && [string isEqualToString:@"."]) {
            //if textfield isn't have anything and string is "." , cancel
            return NO;
        }
    }
    if (textField == self.txtNote) {
        if (textField.text.length >= 25 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    return YES;
}

- (void)textfieldCostDidChangeText {
    if ([self.txtCost.text length] > 0) {
        if( ![@"." hasSuffix:[self.txtCost.text substringFromIndex:([self.txtCost.text length] - 1)]]) {
            NSString *currentCost = [[self.txtCost.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]] componentsJoinedByString:@""];
            self.costValue = [currentCost doubleValue];
            //Create NSNumber with currency format
            NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
            [currencyFormatter setMaximumFractionDigits:2];
            [currencyFormatter setMinimumFractionDigits:0];
            [currencyFormatter setAlwaysShowsDecimalSeparator:NO];
            [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyAccountingStyle];
            NSNumber *someAmount = [NSNumber numberWithDouble:self.costValue];
            //set textfield to currency style
            NSString *string = [currencyFormatter stringFromNumber:someAmount];
            self.txtCost.text = string;
        }
    }
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
