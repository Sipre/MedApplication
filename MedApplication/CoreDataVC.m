//
//  CoreDataVC.m
//  MedApplication
//
//  Created by Sipre on 01/05/13.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "CoreDataVC.h"
#import "AppDelegate.h"

@interface CoreDataVC (){
    
}
@end

@implementation CoreDataVC

@synthesize context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    context = [appdelegate managedObjectContext];
}


#pragma mark - Core Data Methods

- (void)addMedicine: (NSDictionary *)medicine{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSManagedObject *newMedicine = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    
    NSLog(@"%@",[medicine valueForKey:@"name"]);
    
    [newMedicine setValue:[medicine valueForKey:@"name"] forKey:@"name"];
    [newMedicine setValue:[medicine valueForKey:@"quantity"] forKey:@"quantity"];
    [newMedicine setValue:[medicine valueForKey:@"frecuency"] forKey:@"frecuency"];
    [newMedicine setValue:[medicine valueForKey:@"duration"] forKey:@"duration"];
    
    NSError *error;
    [context save:&error];
    NSLog(@"Added medicine");
}

- (void)searchMedicine:(NSString *)name{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",name];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    if (matchingData.count <= 0) {
        NSLog(@"No such medicine on database");
    }
    else {
        for (NSManagedObject *obj in matchingData) {
            NSLog(@"Name: %@",[obj valueForKey:@"name"]);
        }
       // testLabel.text = [NSString stringWithFormat:@"%d medicines found",matchingData.count];
    }
}

- (void) deleteMedicine:(NSString *)name{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSFetchRequest *request = [NSFetchRequest new];
    [request setEntity:entityDesc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@",name];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *matchingData = [context executeFetchRequest:request error:&error];
    if(matchingData.count <= 0){
        NSLog(@"No medicine with name %@ found",name);
    }
    else{
        for (NSManagedObject *obj in matchingData) {
            [context deleteObject:obj];
            NSLog(@"Medicine with name %@ deleted",name);
        }
        [context save:&error];
    }
}

@end
