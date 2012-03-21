//
//  CartaPerDue.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 20/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CartaPerDue : NSObject {
    NSString *name;
    NSString *surname;
    NSInteger expiryMonth;
    NSInteger expiryYear;
    NSString *number;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, assign) NSInteger expiryMonth;
@property (nonatomic, assign) NSInteger expiryYear;
@property (nonatomic, retain) NSString* number;

@property (nonatomic, assign) NSString *expiryString;


- (BOOL)isValid;
- (void)queryAssociationToThisDevice;

@end
