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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 4) {
        return 3; //Next Doses Date & Hour
    }else if (section == 5){
        return 2; //Delete and Suspend Buttons
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*Returns the cell that will be insert in the tableView*/
    /*The type of cell depends on the section of the indexPath*/

    Cell *cell;
    ProgressCell *progressCell;
    
    switch (indexPath.section) {
        case 0:
            //Quantity Cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = [NSString stringWithFormat:@"Take %@ %@ per dose",[medicineAttributes objectForKey:@"quantity"],@"pills"];
            return cell;
            break;
        case 1:
            //Frecuency Cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = [NSString stringWithFormat:@"Every %@ %@", [medicineAttributes objectForKey:@"frecuency"], @"hours"];
            return cell;
            break;
        case 2:
            //Duration cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = [NSString stringWithFormat:@"For %@ %@", [medicineAttributes objectForKey:@"duration"], @"days"];
            return cell;
            break;
        case 3:
            //Progress cell
            progressCell = [tableView dequeueReusableCellWithIdentifier:@"progressCell"];
            progressCell.label.text =  [NSString stringWithFormat:@"Remaining doses: %@", [medicineAttributes objectForKey:@"remainingDoses"]];
            
            float frecuency = [[medicineAttributes objectForKey:@"frecuency"] floatValue];
            float duration = [[medicineAttributes objectForKey:@"duration"] floatValue];
            float remainingDoses  = [[medicineAttributes objectForKey:@"remainingDoses"] floatValue];
            progressCell.progressBar.progress = 1-remainingDoses/(24.0/frecuency*duration);
            return progressCell;
            break;
        case 4:
            //Next doses dates
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.label.text = @"nextDoseTime";
            return cell;
            break;
        case 5:
            //Suspend and delete buttons
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (indexPath.row ==0) {
                cell.label.text = @"Suspend";
            }
            else{
                cell.label.text = @"Delete";
            }
            return cell;
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
        case 3:
            sectionName = @"Treatment progress";
            break;
        case 4:
            sectionName = @"Next doses dates";
            break;
        default:
            break;
    }
    return sectionName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
        return 78;
    }
    else{
        return 44;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end