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

@interface ScheduleVC : CoreDataVC
@property (strong, nonatomic) IBOutlet UITableView *ScheduleTableView;

- (IBAction)back:(id)sender;

@end
