//
//  AddMedicineVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "AddMedicineVC.h"
#import "AppDelegate.h"

@interface AddMedicineVC (){
    NSManagedObjectContext *context;
}

@end

@implementation AddMedicineVC
@synthesize firstView;
@synthesize secondView;
@synthesize ThirdView;
@synthesize nameTextField;
@synthesize quantityTextField;
@synthesize frecuencyTextField;
@synthesize durationTextField;
@synthesize testLabel;

- (void)viewDidLoad{
    [super viewDidLoad];
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
    [self searchMedicine:@"*"];
}

#pragma mark - Name And Type

- (IBAction)back1:(id)sender {
    NSLog(@"Back to Main Menu");
    [self openNewViewController:@"MainMenu"];
}

- (IBAction)next1:(id)sender {
    [self.nameTextField resignFirstResponder];
    [self slideView:firstView direction:YES];
}

#pragma mark - Q F & D
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
    [self slideView:secondView direction:YES];
}

#pragma mark - Summary
- (IBAction)back3:(id)sender {
    [self slideView:secondView direction:NO];
}

- (IBAction)done:(id)sender {
    //[self addMedicine];
    [self openNewViewController:@"MainMenu"];
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

#pragma mark - Core Data Methods

- (void)addMedicine{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSManagedObject *newMedicine = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    [newMedicine setValue:self.nameTextField.text forKey:@"name"];
    [newMedicine setValue:self.quantityTextField.text forKey:@"quantity"];
    [newMedicine setValue:self.frecuencyTextField.text forKey:@"frecuency"];
    [newMedicine setValue:self.durationTextField.text forKey:@"duration"];
    NSError *error;
    [context save:&error];
    NSLog(@"Added medicine");
}

- (void)searchMedicine:(NSString *)name{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",name];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    if (matchingData.count <= 0) {
        NSLog(@"No such medicine on database");
    }
    else {
        for (NSManagedObject *obj in matchingData) {
            NSLog(@"Name: %@",[obj valueForKey:@"name"]);
        }
        testLabel.text = [NSString stringWithFormat:@"%d medicines found",matchingData.count];
    }
}

- (void) deleteMedicine:(NSString *)name{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",name];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    if(matchingData.count <= 0){
        NSLog(@"No medicine with name %@ found",name);
    }
    else{
        for (NSManagedObject *obj in matchingData) {
            [context deleteObject:obj];
            NSLog(@"Medicine with name %@ deleted",name);
        }
        [context save:&error];
    }
}

@end