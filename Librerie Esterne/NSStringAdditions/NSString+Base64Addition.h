//
//  NSString+Base64Addition.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Base64Addition)
+ (NSString *)base64StringFromData:(NSData *)data length:(int)length;
@end
