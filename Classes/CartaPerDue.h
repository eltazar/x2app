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
    NSDate *expiryDate;
    NSString *number;
}

@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* surname;
@property (nonatomic, retain) NSDate* expiryDate;
@property (nonatomic, retain) NSString* number;


- (BOOL)isValid;
- (void )queryAssociationToThisDevice;


@end
