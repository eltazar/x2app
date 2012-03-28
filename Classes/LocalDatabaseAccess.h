//
//  LocalDatabaseAccess.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 21/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "CartaPerDue.h"

@interface LocalDatabaseAccess : NSObject


+ (LocalDatabaseAccess *) getInstance;
- (NSArray *) fetchStoredCardsAndWriteErrorIn:(NSError **)error;
- (BOOL) storeCard:(CartaPerDue *)card AndWriteErrorIn:(NSError **)error; 
//- (void) removeStoredCard:(CartaPerDue *) card;


@end
