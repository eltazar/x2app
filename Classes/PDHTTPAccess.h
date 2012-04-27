//
//  PDHTTPAccess.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMHTTPAccess.h"
#import "CartaPerDue.h"


@interface PDHTTPAccess : NSObject

+ (void)registerUserOnServer:(NSArray*)userData delegate:(id<WMHTTPAccessDelegate>)delegate;

+ (void)checkUserFields:(NSArray*)usr delegate:(id<WMHTTPAccessDelegate>)delegate;

+ (void)sendRetrievePswForUser:(NSString*)usr delegate:(id<WMHTTPAccessDelegate>)delegate;

+ (void)buyCouponRequest:(NSString*)string delegate:(id<WMHTTPAccessDelegate>)delegate;

+ (void)requestACard:(NSArray*)data delegate:(id<WMHTTPAccessDelegate>)delegate;

+ (void)getAltreOfferteFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate;

+ (void)getCouponFromServerWithId:(NSInteger)idCoupon delegate:(id<WMHTTPAccessDelegate>) delegate ;

+ (void)getCouponFromServer:(NSString*)prov delegate:(id<WMHTTPAccessDelegate>)delegate;

@end
