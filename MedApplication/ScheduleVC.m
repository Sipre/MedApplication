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

@synthesize ScheduleTableView;
@synthesize secondView;
@synthesize navigationBar;

@synthesize attributesController;
@synthesize attributesTableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    /*Second table view init*/
    attributesController = [[medicineTableController alloc] init];
    attributesTableView.delegate = attributesController;
    attributesTableView.dataSource = attributesController;
    attributesController.view = attributesController.tableView;
    
    /*Core data search*/
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
            
        }
    }
    NSLog(@"para sort");
    //sort the list, please :D
    if (listForSchedule.count > 0 ) {
        for(int y=0; y < listForSchedule.count-1;y++){
            for(int j=0; j < listForSchedule.count-1;j++){
                int h=j;
                NSDate *a = [[listForSchedule objectAtIndex:h++] valueForKey:@"nextDose"];
                NSDate *b = [[listForSchedule objectAtIndex:h] valueForKey:@"nextDose"];
                int c = [a timeIntervalSinceDate:b];
                if (c > 0) {
                    [listForSchedule exchangeObjectAtIndex:h withObjectAtIndex:--h];
                }
            }
        }        
    }
    
    NSLog(@"viewDone");
    
    [ScheduleTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundPOT.png"]]];
    [attributesTableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundPOT.png"]]];

}




- (IBAction)back:(id)sender {
    NSLog(@"Back to Main Menu");
    [self openNewViewController:@"MainMenu"];
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
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png",[medicineForToday valueForKey:@"image"]];
    
    [cell.medicineImage setImage:[UIImage imageNamed:imageName]];
    
    return cell;
}

//this method is used when the user select a cell in the "tableview"
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    
    NSString *nameSelected = [NSString stringWithFormat:  @"%@",[[listForSchedule objectAtIndex:indexPath.row ] valueForKey:@"name"]];
    [navigationBar setTitle:nameSelected];
    
    attributesController.medicineAttributes = [NSMutableDictionary new];
    attributesController.medicineAttributes = [self getSelectedMedicineAttributes:indexPath.row];
    
    [attributesTableView reloadData];
    //[[attributesController tableView] reloadData];
    //[attributesController.tableView reloadData];
    [self slideView:secondView direction:NO];
}




- (IBAction)back2:(id)sender {
    [self slideView:secondView direction:YES];
}


#pragma mark - User Defined Methods

- (void) openNewViewController:(NSString*) ViewControllerIndentifier{
    //Opens the View Controller with identifier passed by the parameter
    UIViewController *newViewController = [self.storyboard instantiateViewControllerWithIdentifier:ViewControllerIndentifier];
    [self presentViewController:newViewController animated:YES completion:nil];
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

# pragma mark - User Defined Methods

- (NSMutableDictionary *) getSelectedMedicineAttributes: (int) selectedRow{
    /*Returns an NSMutableDictionary with the attributes of the selected cell*/
    NSMutableDictionary *medicineAttributes = [[NSMutableDictionary alloc] init];
    
    [[listForSchedule objectAtIndex:0] valueForKey:@"name"];
    
    NSManagedObject *medicine = [listForSchedule objectAtIndex:selectedRow];
    
    [medicineAttributes setValue: [medicine valueForKey:@"name"]        forKey:@"name"];
    [medicineAttributes setValue: [medicine valueForKey:@"frecuency"]   forKey:@"frecuency"];
    [medicineAttributes setValue: [medicine valueForKey:@"quantity"]    forKey:@"quantity"];
    [medicineAttributes setValue: [medicine valueForKey:@"duration"]    forKey:@"duration"];
    [medicineAttributes setValue: [medicine valueForKey:@"image"]       forKey:@"image"];
    [medicineAttributes setValue: [medicine valueForKey:@"doseUnit"]    forKey:@"doseUnit"];
    [medicineAttributes setValue: [medicine valueForKey:@"remainingDoses"] forKey:@"remainingDoses"];
    [medicineAttributes setValue: [medicine valueForKey:@"startDate"]   forKey:@"startDate"];
    [medicineAttributes setValue: [medicine valueForKey:@"nextDose"]   forKey:@"nextDose"];
    
    return medicineAttributes;
}


@end