//
//  DatePickerViewController.m
//  MoneyManager
//
//  Created by Thinh on 6/22/16.
//  Copyright © 2016 Thinh. All rights reserved.
//

#import "DatePickerViewController.h"
#import "KDCalendarView.h"

@interface DatePickerViewController () <KDCalendarDataSource,KDCalendarDelegate>

@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UILabel *lbMonthYear;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) KDCalendarView *calendar;
@property (copy,nonatomic) void(^callBackBlock)(NSDate* date);

@end

@implementation DatePickerViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Add gesture to background view , when user click on background view, the view will disappear
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [self.backgroundView addGestureRecognizer:tap];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Add calendar after view didappear to get correct frame
    self.calendar = [[KDCalendarView alloc] initWithFrame:self.calendarView.bounds];
    self.calendar.delegate = self;
    self.calendar.dataSource = self;
    [self.view layoutIfNeeded];
    [UIView transitionWithView:self.calendarView duration:0.5
                       options:UIViewAnimationOptionTransitionCurlUp //change to whatever animation you like
                    animations:^ {
                        [self.calendarView addSubview:self.calendar];
                    }
                    completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissView {
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - KDClendarView implementation
- (void)calendarController:(KDCalendarView*)calendarViewController didScrollToMonth:(NSDate*)date {
    // Set title to the month displayed
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM yyyy"];
    self.lbMonthYear.text = [formatter stringFromDate:date];
}

- (void)calendarController:(KDCalendarView*)calendarViewController didSelectDay:(NSDate*)date {
}

- (NSDate*)startDate {
    return [NSDate date];
}

- (IBAction)btnChoose:(id)sender {
    self.callBackBlock([self.calendar dateSelected]);
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Button Handler
- (IBAction)btnCancelClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnNextMonthClick:(id)sender {
    [self.calendar setMonthDisplayed:[self.calendar monthDisplayed] animated:true];
}

- (IBAction)btnPreviousMonthClick:(id)sender {
}

- (void)didSelectDateWithBlock:(void (^)(NSDate* date))completion {
    self.callBackBlock = completion;
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
