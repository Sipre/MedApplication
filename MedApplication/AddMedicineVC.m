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
@synthesize startDateTextField;
@synthesize firstDoseTextField;
@synthesize secondDoseTextField;
@synthesize thirdDosetextField;

#pragma mark - Local Variables

int quantity = 1;
int frecuency = 1;
int duration = 1;

NSString *selectedMedicineType;
NSString *selectedDoseUnit;

NSDate *startDate;
NSDate *nextDose;

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
    
    [firstView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
    [secondView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
    [ThirdView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
    
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
    
    nextDose = startDate;
    
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
    //[self CreateLocalNotification:nextDose]; //real
    [self openNewViewController:@"MedicineList"];
}


- (void) refreshDate{
    /*Method used to refresh the date of the startDateTextField*/
    NSDate *newDate = datePicker.date;
    startDate = datePicker.date;
    
    //NSLog(@"C: %@",[[NSDate date] description]);
    //NSLog(@"C: %@",[datePicker.minimumDate description]);
    //NSLog(@"C: %@",[datePicker.date description]);
    //NSLog(@"C: %@",[startDate description]);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"cccc, MMM d"];
    NSString *newDateString = [dateFormat stringFromDate:newDate];
    startDateTextField.text = newDateString;

    NSDate *customDate =newDate;
    
     /*Fill the dose text fields*/
    
    [dateFormat setDateFormat:@"cccc, MMM d"]; //day of the week, Month,#day.
    startDateTextField.text = [dateFormat stringFromDate:customDate];
    
    [dateFormat setDateFormat:@"hh:mm aa"];
    NSString *time = [dateFormat stringFromDate:customDate];
    firstDoseTextField.text = time;
    
    customDate =[NSDate dateWithTimeInterval:3600*frecuency sinceDate:newDate];    
    time = [dateFormat stringFromDate:customDate];
    secondDoseTextField.text = time;
    
    customDate = [NSDate dateWithTimeInterval:3600*frecuency sinceDate:customDate];
    time = [dateFormat stringFromDate:customDate];
    thirdDosetextField.text = time;
    
}

- (void) initDatePicker{
    /*
     Adds target to allow refreshing the startDateTextField
     Sets the minimum date of the picker to the current hour
     Changes the date of the picker to the next hour with 0 minuntes
     */

    [datePicker addTarget:self action:@selector(refreshDate) forControlEvents:UIControlEventValueChanged];
    datePicker.minimumDate = [NSDate date];//datePicker.date;
    datePicker.date = [NSDate date];
    
    //NSLog(@"A: %@",[[NSDate date] description]);
    //NSLog(@"A: %@",[datePicker.minimumDate description]);
    //NSLog(@"A: %@",[datePicker.date description]);
    //NSLog(@"A: %@",[startDate description]);
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"mm"];
    NSString *minString = [dateFormatter stringFromDate:today];
    int min = [minString intValue];
    int minInSec = min*60;
    
    [dateFormatter setDateFormat:@"ss"];
    NSString *secString = [dateFormatter stringFromDate:today];
    int sec = [secString intValue];
    
    int LessInterval= minInSec+sec;
    
    [dateFormatter setDateFormat:@"aa"];
    

    datePicker.date = today;
    [datePicker setDate:datePicker.date];
    startDate = datePicker.date;
    
    //NSLog(@"B: %@",[customDate description]);
    //NSLog(@"B: %@",[datePicker.date description]);
    //NSLog(@"B: %@",[startDate description]);
    
    NSDate *customDate =[NSDate dateWithTimeInterval:3600-LessInterval sinceDate:today];
    
    [dateFormatter setDateFormat:@"cccc, MMM d"]; //day of the week, Month,#day.
    startDateTextField.text = [dateFormatter stringFromDate:customDate];
   
    /*Fill the dose text fields*/
    [dateFormatter setDateFormat:@"hh:mm aa"];
    
    NSString *time = [dateFormatter stringFromDate:customDate];
    firstDoseTextField.text = time;
    
    customDate = [NSDate dateWithTimeInterval:3600*frecuency sinceDate:customDate];
    time = [dateFormatter stringFromDate:customDate];
    secondDoseTextField.text = time;
    
    customDate = [NSDate dateWithTimeInterval:3600*frecuency sinceDate:customDate];
     time = [dateFormatter stringFromDate:customDate];
    thirdDosetextField.text = time;
}

#pragma mark - Notification
- (UILocalNotification *) CreateLocalNotification:(NSDate *) myFireDate{
    
    UILocalNotification *notification = [UILocalNotification new];
    //[notification setAlertBody:@"It's Time to Take Your Medicnie"];
    [notification setAlertBody:[NSString stringWithFormat:@"%@",nameTextField.text]]; //localized string key to show an alert
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.userInfo = [NSDictionary dictionaryWithObject:@"alarm" forKey:@"alarm"];
    notification.repeatInterval = NSWeekCalendarUnit;
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
