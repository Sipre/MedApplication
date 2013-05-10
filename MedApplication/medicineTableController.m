//
//  medicineTableController.m
//  MedApplication
//
//  Created by Lalo on 03/05/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "medicineTableController.h"

@interface medicineTableController (){
    int countNextDose;
    NSDateFormatter *dateFormat;
    NSDate *customDate;
    
    UIView *backView;
}

@end

@implementation medicineTableController
@synthesize medicineAttributes;

- (void)viewDidLoad
{
    [super viewDidLoad];
    countNextDose = 0;
    editable = 0;
    
   
}

-(void) editing:(int) editab{
    if (editab == 0) {
        editable = 0;
         NSLog(@"edicion desactivada");
    }
    else if(editab == 1){
        editable = 1;
         NSLog(@"edicion activada");
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 5) {
        return 3; //Next Doses Date & Hour
    }
    else if (section == 6){
        return 1; //Delete and Suspend Buttons
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*Returns the cell that will be insert in the tableView*/
    /*The type of cell depends on the section of the indexPath*/

    Cell *cell = [[Cell alloc] init];
    ProgressCell *progressCell;
    
    switch (indexPath.section) {
        case 0:
        {
            ImageCell *imageCell;
            //Image Cell
            imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
            NSString *imageName = [NSString stringWithFormat:@"%@.png",[medicineAttributes objectForKey:@"image"]];

            [imageCell.medicineImage setImage:[UIImage imageNamed:imageName]];
            return imageCell;
            break;
        }
        case 1:
            //Quantity Cell

            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if (editable == 1) {
                [cell.image setImage:[UIImage imageNamed:@"editableParameter.png"]];
            }
            else{
                [cell.image setImage:[UIImage imageNamed:nil]];
            }
            cell.label.text = [NSString stringWithFormat:@"Take %@ %@ per dose",[medicineAttributes objectForKey:@"quantity"],@"pills"];
            return cell;
            break;
        case 2:
            //Frecuency Cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if (editable == 1) {
                [cell.image setImage:[UIImage imageNamed:@"editableParameter.png"]];
            }
            else{
                [cell.image setImage:[UIImage imageNamed:nil]];
            }
            cell.label.text = [NSString stringWithFormat:@"Every %@ %@", [medicineAttributes objectForKey:@"frecuency"], @"hours"];
            return cell;
            break;
        case 3:
            //Duration cell
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if (editable == 1) {
                [cell.image setImage:[UIImage imageNamed:@"editableParameter.png"]];
            }
            else{
                [cell.image setImage:[UIImage imageNamed:nil]];
            }            cell.label.text = [NSString stringWithFormat:@"For %@ %@", [medicineAttributes objectForKey:@"duration"], @"days"];
            return cell;
            break;
        case 4:
            //Progress cell
            progressCell = [tableView dequeueReusableCellWithIdentifier:@"progressCell"];
            progressCell.label.text =  [NSString stringWithFormat:@"Remaining doses: %@", [medicineAttributes objectForKey:@"remainingDoses"]];
            
            float frecuency = [[medicineAttributes objectForKey:@"frecuency"] floatValue];
            float duration = [[medicineAttributes objectForKey:@"duration"] floatValue];
            float remainingDoses  = [[medicineAttributes objectForKey:@"remainingDoses"] floatValue];
            progressCell.progressBar.progress = 1-remainingDoses/(24.0/frecuency*duration);
            return progressCell;
            break;
        case 5:
            //Next doses dates
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            
            if ([[medicineAttributes objectForKey:@"remainingDoses"] intValue]-countNextDose > 0) {
                dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"cccc, MMM d   -   hh:mm aa"];
                customDate =[NSDate dateWithTimeInterval:(3600*countNextDose)*[[medicineAttributes objectForKey:@"frecuency"] intValue] sinceDate:[medicineAttributes objectForKey:@"nextDose"]];
                
                cell.label.text =[NSString stringWithFormat:@"%@",[dateFormat stringFromDate:customDate]];
                
                if (++countNextDose > 2) {
                    countNextDose = 0;
                }
            }
            else{
                cell.label.text = @"No remainig doses";
            }
          
            
            return cell;
            break;
        case 6:
            //Suspend and delete buttons
            cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
           // if (indexPath.row ==0) {
             //   cell.label.text = @"Suspend";
            //}
            //else{
             cell.selectionStyle = UITableViewCellSelectionStyleGray;
            if (editable == 1) {
                [cell.image setImage:[UIImage imageNamed:@"editableParameter.png"]];
            }
            else{
                [cell.image setImage:[UIImage imageNamed:nil]];
            }
            //cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"deleteMedicineButton.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            //cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:@"deleteMedicineButton.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:5.0] ];
            cell.label.text = @"Delete";
            //}
            return cell;
            break;
    }

    return NULL;
}



- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }

    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 8, 320, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    //label.shadowColor = [UIColor grayColor];
    //label.shadowOffset = CGSizeMake(-1.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    UIView *view = [[UIView alloc] init];
    [view addSubview:label];
    
    return view;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *sectionName;
    switch (section)
    {
        case 1:
            sectionName = @"Quantity";
            break;
        case 2:
            sectionName = @"Frequency";
            break;
        case 3:
            sectionName = @"Duration";
            break;
        case 4:
            sectionName = @"Treatment progress";
            break;
        case 5:
            sectionName = @"Next doses dates";
            break;
        default:
            break;
    }
    return sectionName;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        return 78;
    }
    else if (indexPath.section == 0){
        return 160;
    }
    else{
        return 44;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    if (editable == 1) {
        if(indexPath.section == 6 && indexPath.row == 0){
            NSLog(@"Delete selected");
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"WARNING"
                        message: [NSString stringWithFormat:@"The medicine %@ is going to be erased",[medicineAttributes objectForKey:@"name"]]
                                       delegate: self
                                    cancelButtonTitle:@"Cancel"
                                    otherButtonTitles:@"Erase the medicine", nil];
            [alert show];
                        
            }
    
        if (indexPath.section == 1) {
            NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"quantity", @"type",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showEditView" object:[medicineAttributes objectForKey:@"name"] userInfo:dict ];
        }
        if (indexPath.section == 2) {
            NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"frecuency", @"type",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showEditView" object:[medicineAttributes objectForKey:@"name"] userInfo:dict ];

        }
        if (indexPath.section == 3) {
            NSDictionary *dict=[[NSDictionary alloc] initWithObjectsAndKeys:@"duration", @"type",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showEditView" object:[medicineAttributes objectForKey:@"name"] userInfo:dict ];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        NSLog(@"Skip 0");
        
    }else if(buttonIndex==1){
        NSLog(@"Skip 1");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteMedicine" object:[medicineAttributes objectForKey:@"name"] ];
        
    }
    
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




@end