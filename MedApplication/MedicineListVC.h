//
//  MedicineListVC.h
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicineCell.h"
#import "CoreDataVC.h"
#import "medicineTableController.h"
#import <QuartzCore/QuartzCore.h>

@interface MedicineListVC : CoreDataVC  

@property (strong, nonatomic) NSArray *medicineList;


# pragma mark - Table View
@property (strong, nonatomic) IBOutlet UIView *firstView;
- (IBAction)back:(id)sender;
- (IBAction)rightNavButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *medicineTableView;

# pragma mark - Second View Interface
@property (strong, nonatomic) IBOutlet UIView *secondView;
- (IBAction)back2:(id)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *edit;
- (IBAction)edit:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

# pragma mark - Second Table View
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;
@property (strong, nonatomic) medicineTableController *attributesController;

# pragma mark - edit Table view
@property (strong, nonatomic) IBOutlet UIView *editView;
@property (strong, nonatomic) IBOutlet UITextField *editTextField;
- (IBAction)increaseEdit:(id)sender;
- (IBAction)decreaseEdit:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *topEditLabel;
@property (strong, nonatomic) IBOutlet UILabel *bottomEditLabel;
- (IBAction)saveEditButton:(id)sender;
- (IBAction)cancelEditButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *protectorView;
@end
