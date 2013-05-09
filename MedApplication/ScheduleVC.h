//
//  ScheduleVC.h
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleCell.h"
#import "CoreDataVC.h"
#import "medicineTableController.h"

@interface ScheduleVC : CoreDataVC

# pragma mark - Table View
@property (strong, nonatomic) IBOutlet UITableView *ScheduleTableView;
- (IBAction)back:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *firstView;


# pragma mark - Second View Interface
@property (strong, nonatomic) IBOutlet UIView *secondView;
- (IBAction)back2:(id)sender;
- (IBAction)edit:(id)sender;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

# pragma mark - Second Table View
@property (strong, nonatomic) IBOutlet UITableView *attributesTableView;
@property (strong, nonatomic) medicineTableController *attributesController;

@end
