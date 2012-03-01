//
//  GoogleHQAnnotation.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 10/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GoogleHQAnnotation.h"

@implementation GoogleHQAnnotation
@synthesize coordinate;

- (id)init:(double)latitudine:(double)longitudine:(NSString*)nome:(NSString*)indirizzo:(int)identificativo{
    coordinate.latitude = latitudine;
    coordinate.longitude = longitudine;
	title=nome;
	subtitle=indirizzo;
	ide=identificativo;
    return [super init];
}


- (NSString *)title{
    return title;
}

- (NSString *)subtitle {
    return subtitle;
}

- (int)ide{
    return ide;;
}

@end