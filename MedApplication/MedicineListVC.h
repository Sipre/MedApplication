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

@interface MedicineListVC : CoreDataVC  

- (IBAction)back:(id)sender;
- (IBAction)rightNavButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *medicineTableView;

@end
