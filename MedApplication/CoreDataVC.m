//
//  CoreDataVC.m
//  MedApplication
//
//  Created by Sipre on 01/05/13.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import "CoreDataVC.h"


@interface CoreDataVC ()

@end

@implementation CoreDataVC

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
}


#pragma mark - Core Data Methods

- (void)addMedicine{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Medicine" inManagedObjectContext:context];
    NSManagedObject *newMedicine = [[NSManagedObject alloc] initWithEntity:entityDesc insertIntoManagedObjectContext:context];
    [newMedicine setValue:self.nameTextField.text forKey:@"name"];
    [newMedicine setValue:self.quantityTextField.text forKey:@"quantity"];
    [newMedicine setValue:self.frecuencyTextField.text forKey:@"frecuency"];
    [newMedicine setValue:self.durationTextField.text forKey:@"duration"];
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
        testLabel.text = [NSString stringWithFormat:@"%d medicines found",matchingData.count];
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
