//
//  DatePickerViewController.h
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DatePickerViewController : UIViewController

@property (strong, nonatomic) NSDate *dateWillDisplay;
- (void)didSelectDateWithBlock:(void (^)(NSDate* date))completion;

@end
