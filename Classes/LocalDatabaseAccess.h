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

// Valutare se alcuni devono essere metodi di istanza invece che di classe
+ (NSArray *) fetchStoredCardsAndWriteErrorIn:(NSError **)error;
+ (BOOL) storeCard:(CartaPerDue *)card AndWriteErrorIn:(NSError **)error; 
//+ (void) storeCard:(CartaPerDue *) card;
//+ (void) removeStoredCard:(CartaPerDue *) card;

@end
