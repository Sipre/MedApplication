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
- (IBAction)edit:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;

# pragma mark - Second Table View
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;
@property (strong, nonatomic) medicineTableController *attributesController;

@end
