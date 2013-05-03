//
//  AddMedicineVC.h
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataVC.h"

@interface AddMedicineVC : CoreDataVC

#pragma mark - Name and Type View
@property (strong, nonatomic) IBOutlet UIView *firstView;
- (IBAction)back1:(id)sender;
- (IBAction)next1:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

#pragma mark - Quantity, Frecuency and Duration
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UITextField *frecuencyTextField;
@property (strong, nonatomic) IBOutlet UITextField *durationTextField;
- (IBAction)back2:(id)sender;
- (IBAction)next2:(id)sender;
- (IBAction)increaseQuantity:(id)sender;
- (IBAction)decreaseQuantity:(id)sender;
- (IBAction)increaseFrecuency:(id)sender;
- (IBAction)decreaseFrecuency:(id)sender;
- (IBAction)increaseDuration:(id)sender;
- (IBAction)decreaseDuration:(id)sender;

#pragma mark - Summary
@property (strong, nonatomic) IBOutlet UIView *ThirdView;
- (IBAction)back3:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)dateButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *firstHourLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondHourLabel;

@end
