//
//  AddMedicineVC.h
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMedicineVC : UIViewController

#pragma mark - Name and Type View
@property (strong, nonatomic) IBOutlet UIView *firstView;
- (IBAction)back1:(id)sender;
- (IBAction)next1:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *testLabel;

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

#pragma mark - Quantity, Frecuency and Duration
@property (strong, nonatomic) IBOutlet UIView *secondView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *next2Button;
- (IBAction)back2:(id)sender;
- (IBAction)next2:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UITextField *frecuencyTextField;
@property (strong, nonatomic) IBOutlet UITextField *durationTextField;

#pragma mark - Summary
@property (strong, nonatomic) IBOutlet UIView *ThirdView;
- (IBAction)back3:(id)sender;
- (IBAction)done:(id)sender;

@end
