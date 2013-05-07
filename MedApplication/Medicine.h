//
//  Medicine.h
//  MedApplication
//
//  Created by Lalo on 01/05/2013.
//  Copyright (c) 2013 Lalo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Medicine : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString *frecuency;
@property (nonatomic, strong) NSString *duration;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *doseUnit;
@property (nonatomic, strong) NSString *remainingDoses;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *nextDose;

@end
