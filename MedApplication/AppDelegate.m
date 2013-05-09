#import "AppDelegate.h"


@implementation AppDelegate {
    
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [super viewDidLoad];
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    //[self.window makeKeyAndVisible];
    
    NSNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if(localNotification){
        NSLog(@"Recieved Notification %@",localNotification);
    }
    
    
    return YES;
}

//notification
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running
    //NSLog(@"check 1");
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Time to Take your Medicine: " message:notif.alertBody delegate:self cancelButtonTitle:nil otherButtonTitles:@"Remind Me In 5 minutes",@"Skip Dose", @"Ok",nil];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (buttonIndex == 0){
        NSLog(@"Remind Me in 5 Minutes pressed");
        [self CreateLocalNotification:[NSDate dateWithTimeIntervalSinceNow:5] withString:alertView.message];
        
    }else if (buttonIndex == 1){
        NSLog(@"Skip Dose");
        
    }else if(buttonIndex==2){
        
        NSLog(@"Ok Pressed");//remindingDose--
        [self reloadEntitieAndNotification:alertView];
               
    }
    
}

-(void) reloadEntitieAndNotification:(UIAlertView *)alertView{
    NSManagedObject *medicine = [[self searchMedicine:alertView.message] objectAtIndex:0]; //notif Medicine
    
    NSString *newRemainingDoses = [NSString stringWithFormat:@"%d",([[medicine valueForKey:@"remainingDoses"] intValue]-1)]; // = remainingDoses-1
    
    if ([newRemainingDoses intValue] >= 0) {
        
        //Get ManageObject of Entitie
        
        //Back up -- entitie
        //NSLog(@"Medicine name is : %@",[medicine valueForKey:@"name"]);
        NSMutableDictionary *backUp = [[NSMutableDictionary alloc] init];
        [backUp setValue:[medicine valueForKey:@"name"]     forKey:@"name"];
        [backUp setValue:[medicine valueForKey:@"quantity"] forKey:@"quantity"];
        [backUp setValue:[medicine valueForKey:@"frecuency"] forKey:@"frecuency"];
        [backUp setValue:[medicine valueForKey:@"duration"] forKey:@"duration"];
        [backUp setValue:[medicine valueForKey:@"image"]    forKey:@"image"];
        [backUp setValue:[medicine valueForKey:@"doseUnit"] forKey:@"doseUnit"];
        [backUp setValue:[medicine valueForKey:@"startDate"] forKey:@"startDate"];
        
        //reload data --
        NSLog(@"check 2");
        //NSString *newRemainingDoses = [NSString stringWithFormat:@"%d",([[medicine valueForKey:@"remainingDoses"] intValue]-1)]; // = remainingDoses-1
        [backUp setValue:newRemainingDoses forKey:@"remainingDoses"]; //NSLog(@"rem DOSES: %@",[medicine valueForKey:@"remainingDoses"]); //NSLog(@"rem DOSES: %@",newRemainingDoses);
        
        //Date for the next Dose
        NSDate *newNextDose = [[NSDate alloc] initWithTimeInterval:(3600*[[medicine valueForKey:@"frecuency"] intValue]) sinceDate:[medicine valueForKey:@"nextDose"]];
        [backUp setValue:newNextDose forKey:@"nextDose"];
        
        NSLog(@"Ahora      : %@",[[NSDate date] description]);
        NSLog(@"nextDose   : %@",[[medicine valueForKey:@"nextDose"] description]);
        NSLog(@"newNextDose: %@",[newNextDose description]);
        
        //Delete medicine --
        //NSLog(@"pre: %d",[self searchMedicine:@"*"].count);
        [self deleteMedicine:alertView.message];
        //NSLog(@"pos: %d",[self searchMedicine:@"*"].count);
        
        //ADD the reloaded medicine :D
        NSLog(@"name of: %@",[medicine valueForKey:@"name"]);
        [self addMedicine:backUp];
        
        NSLog(@"check 3");
        
        //Create the new Notification
        [self CreateLocalNotification:newNextDose withString:alertView.message]; //check
    }
}


-(UILocalNotification *) CreateLocalNotification:(NSDate *) myFireDate withString:(NSString *) nameMessage{
    NSLog(@"check 4");
    
    UILocalNotification *notification = [UILocalNotification new];
    [notification setAlertBody:[NSString stringWithFormat: @"%@",nameMessage ]];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSLog(@"check 4.1");
    notification.userInfo = [NSDictionary dictionaryWithObject:@"alarm" forKey:@"alarm"];
    NSLog(@"check 4.2");
    notification.repeatInterval = NO;
    notification.fireDate = myFireDate;
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    NSLog(@"check 5");
    return notification;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MedApplication" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MedApplication.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

