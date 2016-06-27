//
//  AddWalletViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "AddWalletViewController.h"

@interface AddWalletViewController () <UITextFieldDelegate>

@property (strong,nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (copy,nonatomic) void(^callBackBlock)();

@end

@implementation AddWalletViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Add tap recognizer to dismiss keyboard when touch outside textfield
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapRecognizer];
    self.txtCash.delegate = self;
    self.txtCurrency.delegate = self;
    self.txtWalletName.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - assign block
- (void)didAddWalletWithBlock:(void (^)())completion {
    self.callBackBlock = completion;
}

#pragma mark - Text Input handler
- (void)dismissKeyboard {
    [self.txtCash resignFirstResponder];
    [self.txtCurrency resignFirstResponder];
    [self.txtWalletName resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Limit characters for textfield
    if (textField == self.txtWalletName) {
        if (textField.text.length >= 25 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    if (textField == self.txtCurrency) {
        if (textField.text.length >= 3 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    if (textField == self.txtCash) {
        if (textField.text.length >= 13 && range.length == 0) {
            return NO; // return NO to not change text
        }
    }
    return YES;
}

#pragma mark - Button handler
- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)btnDoneClick:(id)sender {
    if ([self checkInput]) {
        Wallet *wallet = [Wallet MR_createEntity];
        wallet.name = self.txtWalletName.text;
        wallet.currency = self.txtCurrency.text;
        // Wallet cash
        NSNumberFormatter *cash = [[NSNumberFormatter alloc] init];
        cash.numberStyle = NSNumberFormatterDecimalStyle;
        wallet.cash = [cash numberFromString:self.txtCash.text];
        //TODO : Add block to call back update
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if (!contextDidSave) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"Some thing went wrong, try again later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                self.callBackBlock();
                [self dismissViewControllerAnimated:true completion:nil];
            }
        }];
    }
}

- (BOOL)checkInput {
    //Alert for missing information
    NSString *error;
    Wallet *wallet = [Wallet MR_findFirstByAttribute:@"name" withValue:self.txtWalletName.text];
    if (wallet) {
        error = @"Name of wallet is already uses, please try another one!";
    }
    if ([self.txtWalletName.text isEqual: @""]) {
        error = @"Name is Missing" ;
    }
    if ([self.txtCurrency.text  isEqual: @""]) {
        error = @"Currency is Missing";
    }
    if ([self.txtCash.text  isEqual: @""]) {
        error = @"Cash is Missing" ;
    }
    if (error == nil) {
        return YES;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:@"Please check agian" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
