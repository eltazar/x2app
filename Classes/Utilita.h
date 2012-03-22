//
//  Utilita.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



@interface Utilita : NSObject

+(BOOL)isNumeric:(NSString*)inputString;
+(BOOL)isStringEmptyOrWhite:(NSString*)string;
+(BOOL)isEmailValid:(NSString*)email;
+(BOOL)isDateFormatValid:(NSString*)data;
# warning TODO: rimuovere isDateExpired
+(BOOL)isDateExpired:(NSString*)data;
+(BOOL)networkReachable;
@end
