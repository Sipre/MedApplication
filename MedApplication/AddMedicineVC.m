//
//  AddMedicineVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "AddMedicineVC.h"
#import "AppDelegate.h"

@interface AddMedicineVC ()

@end

@implementation AddMedicineVC

@synthesize firstView;
@synthesize secondView;
@synthesize ThirdView;
@synthesize nameTextField;
@synthesize quantityTextField;
@synthesize frecuencyTextField;
@synthesize durationTextField;
@synthesize datePicker;
@synthesize firstHourLabel;
@synthesize secondHourLabel;
@synthesize startDateTextField;
@synthesize firstDoseTextField;
@synthesize secondDoseTextField;
@synthesize thirdDosetextField;

#pragma mark - Local Variables

int quantity = 1;
int frecuency = 1;
int duration = 1;
NSDate *startDate;

int quantityLowerLimit = 1;
int quantityUpperLimit = 15;
int frecuencyLowerLimit = 1;
int frecuencyUpperLimit = 24;
int durationLowerLimit = 1;
int durationUpperLimit = 31;

#pragma mark - View Did Load

- (void)viewDidLoad{
    [super viewDidLoad];
    
    NSArray *tempData = [self searchMedicine:@"*"];
    NSString *conteo = [NSString stringWithFormat:@"Medicine count: %d",tempData.count];
    NSLog(@"%@",conteo);
    quantityTextField.enabled = NO;
    frecuencyTextField.enabled = NO;
    durationTextField.enabled = NO;
    startDateTextField.enabled = NO;
    firstDoseTextField.enabled = NO;
    secondDoseTextField.enabled = NO;
    thirdDosetextField.enabled = NO;
    
    //notification
    //[self CreateLocalNotification:[NSDate dateWithTimeIntervalSinceNow:10]];
   
    
}

#pragma mark - Name And Type View

- (IBAction)back1:(id)sender {
    NSLog(@"Back to Main Menu");
    [self openNewViewController:@"MainMenu"];
}

- (IBAction)next1:(id)sender {
    NSArray *data = [self searchMedicine:nameTextField.text];
    
    if ([self isTextFieldEmpty:nameTextField:@"name" ] == NO){
        if(data.count > 0){
            [self medicineNameRepeated];
            NSLog(@"Repeated medicine name");            
        }
        else{
            [self.nameTextField resignFirstResponder];
            [self slideView:firstView direction:YES];
        }
    }
    
}

#pragma mark - Q F & D View
- (IBAction)back2:(id)sender {
    [self.quantityTextField resignFirstResponder];
    [self.frecuencyTextField resignFirstResponder];
    [self.durationTextField resignFirstResponder];
    [self slideView:firstView direction:NO];
}

- (IBAction)next2:(id)sender {
    [self.quantityTextField resignFirstResponder];
    [self.frecuencyTextField resignFirstResponder];
    [self.durationTextField resignFirstResponder];
    [self initDatePicker];
    [self slideView:secondView direction:YES];
}

- (IBAction)increaseQuantity:(id)sender {
    quantity = [quantityTextField.text intValue];
    if (quantity < quantityUpperLimit) {
        quantity++;
    }
    quantityTextField.text = [NSString stringWithFormat:@"%d",quantity];
}

- (IBAction)decreaseQuantity:(id)sender {
    quantity = [quantityTextField.text intValue];
    if (quantity > quantityLowerLimit) {
        quantity--;
    }
    quantityTextField.text = [NSString stringWithFormat:@"%d",quantity];
}

- (IBAction)increaseFrecuency:(id)sender {
    frecuency = [frecuencyTextField.text intValue];
    if (frecuency < frecuencyUpperLimit) {
        frecuency++;
    }
    frecuencyTextField.text = [NSString stringWithFormat:@"%d",frecuency];
}

- (IBAction)decreaseFrecuency:(id)sender {
    frecuency = [frecuencyTextField.text intValue];
    if (frecuency > frecuencyLowerLimit) {
        frecuency--;
    }
    frecuencyTextField.text = [NSString stringWithFormat:@"%d",frecuency];
}

- (IBAction)increaseDuration:(id)sender {
    duration = [durationTextField.text intValue];
    if (duration < durationUpperLimit) {
        duration++;
    }
    durationTextField.text = [NSString stringWithFormat:@"%d",duration];
}

- (IBAction)decreaseDuration:(id)sender {
    duration = [durationTextField.text intValue];
    if (duration > durationLowerLimit) {
        duration--;
    }
    durationTextField.text = [NSString stringWithFormat:@"%d",duration];
}

#pragma mark - Summary View
- (IBAction)back3:(id)sender {
    [self slideView:secondView direction:NO];
}

- (IBAction)done:(id)sender {
    
    NSMutableDictionary *medicineAttributes = [[NSMutableDictionary alloc] init];
    
    NSString *remainingDoses = [NSString stringWithFormat:@"%d", ((24000/frecuency)*duration)/1000];
    NSLog(@"RemainingDoses: %@",remainingDoses);
    
    //NSString *remainingDoses = [NSString stringWithFormat:@"%d",frecuency*duration];
    
    NSDate *nextDose = startDate;
    
    NSLog(@"Ahora      : %@",[[NSDate date] description]);
    NSLog(@"startDate  : %@",[startDate description]);
    NSLog(@"nextDose   : %@",[nextDose description]);
    
    [medicineAttributes setValue:nameTextField.text        forKey:@"name"];
    [medicineAttributes setValue:quantityTextField.text    forKey:@"quantity"];
    [medicineAttributes setValue:frecuencyTextField.text   forKey:@"frecuency"];
    [medicineAttributes setValue:durationTextField.text    forKey:@"duration"];
    [medicineAttributes setValue:@"defaulImage"            forKey:@"image"];
    [medicineAttributes setValue:@"defaultUnits"           forKey:@"doseUnit"];
    [medicineAttributes setValue:remainingDoses            forKey:@"remainingDoses"];
    [medicineAttributes setValue:startDate                 forKey:@"startDate"];
    [medicineAttributes setValue:nextDose                  forKey:@"nextDose"];
    
    [self addMedicine:medicineAttributes];
    //[self CreateLocalNotification:startDate];
     [self CreateLocalNotification:[NSDate dateWithTimeIntervalSinceNow:5]]; // tests
    //[self CreateLocalNotification:nextDose];
    [self openNewViewController:@"MedicineList"];
}

- (IBAction)dateButtonAction:(id)sender {
    /*
    CGRect frame = datePicker.frame;
    frame.origin.y = 548;
    datePicker.frame = frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    frame.origin.y = 548-216;
    datePicker.frame = frame;
    [UIView commitAnimations];
    */
    NSDate *myDate = datePicker.date;
    startDate = datePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    //[dateFormat setDateFormat:@"cccc, MMM d, hh:mm aa"];
    [dateFormat setDateFormat:@"cccc, MMM d"];
    NSString *prettyVersion = [dateFormat stringFromDate:myDate];
    NSLog(@"%@",prettyVersion);
   
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"hh:mm aa"];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:6];
    [comps setMonth:5];
    [comps setYear:2004];
    [comps setHour:9];
    [comps setMinute:0];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [gregorian dateFromComponents:comps];

    
    firstHourLabel.text = [hourFormat stringFromDate:myDate];
    secondHourLabel.text = [hourFormat stringFromDate:date];
    startDateTextField.text = prettyVersion;
    //- (void)setDate:(NSDate *)date animated:(BOOL)animated
    datePicker.minimumDate = datePicker.date;
    [datePicker setDate:date animated:NO];
}

- (void) refreshDate{
    /*Method used to refresh the date of the startDateTextField*/
    NSDate *newDate = datePicker.date;
    startDate = datePicker.date;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d"];
    NSString *newDateString = [dateFormat stringFromDate:newDate];
    startDateTextField.text = newDateString;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"hh"];
    NSString *hourString = [dateFormatter stringFromDate:newDate];
    int hour = [hourString intValue];
    
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *yearString = [dateFormatter stringFromDate:newDate];
    int year = [yearString intValue];
    
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayString = [dateFormatter stringFromDate:newDate];
    int day = [dayString intValue];
    
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthString = [dateFormatter stringFromDate:newDate];
    int month = [monthString intValue];
    
    [dateFormatter setDateFormat:@"mm"];
    NSString *minuteString = [dateFormatter stringFromDate:newDate];
    int minute = [minuteString intValue];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:hour];
    [comps setMinute:minute];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *customDate = [gregorian dateFromComponents:comps];

    [dateFormatter setDateFormat:@"cccc, MMM d"];
    startDateTextField.text = [dateFormatter stringFromDate:customDate];
    /*Fill the dose text fields*/
    [dateFormatter setDateFormat:@"hh:mm aa"];
    firstDoseTextField.text = [dateFormatter stringFromDate:customDate];
    [comps setHour:hour+frecuency];
    customDate = [gregorian dateFromComponents:comps];
    secondDoseTextField.text = [dateFormatter stringFromDate:customDate];
    [comps setHour:hour+2*frecuency];
    customDate = [gregorian dateFromComponents:comps];
    thirdDosetextField.text = [dateFormatter stringFromDate:customDate];

    
}

- (void) initDatePicker{
    /*
     Adds target to allow refreshing the startDateTextField
     Sets the minimum date of the picker to the current hour
     Changes the date of the picker to the next hour with 0 minuntes
     */
    [datePicker addTarget:self action:@selector(refreshDate) forControlEvents:UIControlEventValueChanged];
    datePicker.minimumDate = datePicker.date;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh"];
    NSString *hourString = [dateFormatter stringFromDate:today];
    int hour = [hourString intValue];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString *yearString = [dateFormatter stringFromDate:today];
    int year = [yearString intValue];
    [dateFormatter setDateFormat:@"dd"];
    NSString *dayString = [dateFormatter stringFromDate:today];
    int day = [dayString intValue];
    [dateFormatter setDateFormat:@"MM"];
    NSString *monthString = [dateFormatter stringFromDate:today];
    int month = [monthString intValue];

    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:hour+1];
    [comps setMinute:0];
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *customDate = [gregorian dateFromComponents:comps];
    [datePicker setDate:customDate];
    
    [dateFormatter setDateFormat:@"cccc, MMM d"]; //day of the week, Month,#day.
    startDateTextField.text = [dateFormatter stringFromDate:customDate];
    /*Fill the dose text fields*/
    
    [dateFormatter setDateFormat:@"hh:mm aa"];
    firstDoseTextField.text = [dateFormatter stringFromDate:customDate];
    [comps setHour:hour+1+frecuency];
    customDate = [gregorian dateFromComponents:comps];
    secondDoseTextField.text = [dateFormatter stringFromDate:customDate];
    [comps setHour:hour+1+2*frecuency];
    customDate = [gregorian dateFromComponents:comps];
    startDate = customDate;
    thirdDosetextField.text = [dateFormatter stringFromDate:customDate];
}

#pragma mark - Notification
- (UILocalNotification *) CreateLocalNotification:(NSDate *) myFireDate{
    
    UILocalNotification *notification = [UILocalNotification new];
    //[notification setAlertBody:@"It's Time to Take Your Medicnie"];
    [notification setAlertBody:[NSString stringWithFormat:@"%@",nameTextField.text]]; //localized string key to show an alert
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = [NSDictionary dictionaryWithObject:@"alarm" forKey:@"alarm"];
    notification.repeatInterval = NO;
    notification.fireDate = myFireDate;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    return notification;
}

#pragma mark - User Defined Methods

- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}

- (void)slideView:(UIView*)view direction:(BOOL)isLeftToRight {
    CGRect frame = view.frame;
    frame.origin.x = (isLeftToRight) ? 0 : 320;
    view.frame = frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    frame.origin.x = (isLeftToRight) ? 320 : 0;
    view.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    NSLog(@"Entered to touches began");
    
    if([touch view] != self.nameTextField && [self.nameTextField isFirstResponder]){
        [self.nameTextField resignFirstResponder];
    }
    else if ([touch view] != self.quantityTextField && [self.quantityTextField isFirstResponder]){
        [self.quantityTextField resignFirstResponder];
    }
    else if ([touch view] != self.frecuencyTextField && [self.frecuencyTextField isFirstResponder]){
        [self.frecuencyTextField resignFirstResponder];
    }
    else if ([touch view] != self.durationTextField && [self.durationTextField isFirstResponder]){
        [self.durationTextField resignFirstResponder];
    }
    else if([touch view] == self.nameTextField){
        [self.nameTextField becomeFirstResponder];
    }
    else if([touch view] == self.quantityTextField){
        [self.quantityTextField becomeFirstResponder];
    }
    else if([touch view] == self.frecuencyTextField){
        [self.frecuencyTextField becomeFirstResponder];
    }
    else if([touch view] == self.durationTextField){
        [self.durationTextField becomeFirstResponder];
    }
    
}

- (BOOL) isTextFieldEmpty:(UITextField *) textField: (NSString *)attribute{
    if ([textField.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message: [NSString stringWithFormat:@"Complete the %@ field",attribute]
                                                      delegate: self
                                             cancelButtonTitle:@"Ok"
                                             otherButtonTitles:nil, nil];
        [alert show];
        return YES;
    }
    else{
        return NO;
    }
    
}

- (void) medicineNameRepeated{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error: name repeated"
                                                   message: [NSString stringWithFormat:@"%@ already exists in medicine list",nameTextField.text]
                                                  delegate: self
                                         cancelButtonTitle:@"Ok"
                                         otherButtonTitles:nil, nil];
    [alert show];

}

@end
