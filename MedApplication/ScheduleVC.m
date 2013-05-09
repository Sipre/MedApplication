//
//  ScheduleVC.m
//  MedApplication
//
//  Created by Lalo on 30/04/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "ScheduleVC.h"
#import "AppDelegate.h"

@interface ScheduleVC ()

@end

@implementation ScheduleVC{
    NSArray *medicineList;
    NSMutableArray *listForSchedule;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    medicineList = [NSArray new];
    medicineList = [self searchMedicine:@"*"];
    listForSchedule = [NSMutableArray new];
    
    
    for(int i=0;i < medicineList.count; i++){
        
        NSDate *today = [NSDate date];
        
        NSDate *medicineDate = [[medicineList objectAtIndex:i] valueForKey:@"nextDose"];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd MM yyyy"];
        
        NSString *dayString = [dateFormat stringFromDate:medicineDate];
        NSString *todayString = [dateFormat stringFromDate:today];
        
        NSString *nameMed = [[medicineList objectAtIndex:i] valueForKey:@"name"];
        NSLog(@"%@ : %@ : %@",nameMed,dayString,[medicineDate description]);
        NSLog(@"%@ : %@ : %@",nameMed,todayString,[today description]);
        
        
        if([dayString isEqualToString:todayString]){
          //put this medicine in the Schedule. GO
            [listForSchedule addObject:[medicineList objectAtIndex:i]];
            //[listForSchedule sortUsingComparator:[[listForSchedule objectAtIndex:0] valueForKey:@"nextDose"],[[listForSchedule objectAtIndex:1] valueForKey:@"nextDose"]];
            for(int j=0; j < listForSchedule.count-1;j++){
                int h=j;
                NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
                [dateFormater setDateFormat:@"hhmm"];
                int a = [[dateFormater stringFromDate:[[listForSchedule objectAtIndex:h++] valueForKey:@"nextDose"]] intValue];
                int b = [[dateFormater stringFromDate:[[listForSchedule objectAtIndex:h] valueForKey:@"nextDose"]] intValue];
                if (b<a) {
                    [listForSchedule exchangeObjectAtIndex:h withObjectAtIndex:--h];
                }
            }
           
        }
        //is the list correctly seted?
        
    }
}




- (IBAction)back:(id)sender {
    NSLog(@"Back to Main Menu");
    [self openNewViewController:@"MainMenu"];
}

#pragma mark - Another Methods


- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
}


#pragma mark - TableView Cell


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listForSchedule.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScheduleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleCell"];
    
    NSManagedObject *medicineForToday = [listForSchedule objectAtIndex:indexPath.row];

    cell.nameScheduleLabel.text = [medicineForToday valueForKey:@"name"];
    
    NSDate *todayMedicine = [medicineForToday valueForKey:@"nextDose"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm aa"];
    
    NSString *timeString = [dateFormat stringFromDate:todayMedicine];

    NSString *nameMed = [medicineForToday valueForKey:@"name"];
    NSLog(@"%@ : %@ : %@",nameMed,timeString,[todayMedicine description]);
    cell.timeScheduleLabel.text = timeString;
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[[medicineList objectAtIndex:indexPath.row ] valueForKey:@"image"]];
    
    [cell.medicineImage setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

//this method is used when the user select a cell in the "tableview"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    //[tableView beginUpdates];
    //[tableView reloadData];
    //[tableView endUpdates];
}




@end
