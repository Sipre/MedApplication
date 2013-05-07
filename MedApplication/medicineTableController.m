//
//  medicineTableController.m
//  MedApplication
//
//  Created by Lalo on 03/05/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "medicineTableController.h"

@interface medicineTableController ()

@end

@implementation medicineTableController
@synthesize medicineAttributes;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Cargo .....");
    [self reloadMyData];
    
}

#pragma mark - User Defined Methods

- (void)reloadMyData{
   // [tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*Returns the cell that will be insert in the tableView*/
    /*The type of cell depends on the section of the indexPath*/

    Cell *cell;
    
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = [NSString stringWithFormat:@"Take %@ %@ per dose",[medicineAttributes objectForKey:@"quantity"],@"pills"];
            return cell;
            break;
        case 1:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = [NSString stringWithFormat:@"Every %@ %@", [medicineAttributes objectForKey:@"frecuency"], @"hours"];
            return cell;
            break;
        case 2:
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = [NSString stringWithFormat:@"For %@ %@", [medicineAttributes objectForKey:@"duration"], @"days"];
            return cell;
            break;
        default:
            break;
    }

    return NULL;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"Quantity";
            break;
        case 1:
            sectionName = @"Frecuency";
            break;
        case 2:
            sectionName = @"Duration";
            break;
        default:
            sectionName = @"Default";
            break;
    }
    return sectionName;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
