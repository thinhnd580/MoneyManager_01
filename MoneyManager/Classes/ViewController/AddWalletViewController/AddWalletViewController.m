//
//  AddWalletViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "AddWalletViewController.h"

@interface AddWalletViewController ()

@property (strong,nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation AddWalletViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //Add tap recognizer to dismiss keyboard when touch outside textfield
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Input handler
- (void)dismissKeyboard {
    [self.txtCash resignFirstResponder];
    [self.txtCurrency resignFirstResponder];
    [self.txtWalletName resignFirstResponder];
}

#pragma mark - Button handler
- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)btnDoneClick:(id)sender {
    //TODO : Add block to call back update
    [self dismissViewControllerAnimated:true completion:nil];
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
