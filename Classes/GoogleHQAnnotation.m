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

- (id)init:(CLLocationDegrees)latitudine:(CLLocationDegrees)longitudine:(NSString*)nome:(NSString*)indirizzo:(int)identificativo{
    self = [super init];
    self.coordinate = CLLocationCoordinate2DMake(latitudine, longitudine);
	title = [nome retain];
	subtitle = [indirizzo retain];
	ide = identificativo;
    return self;
}


- (NSString *)title{
    return title;
}


- (NSString *)subtitle {
    return subtitle;
}

- (int)ide{
    return ide;
}


- (void)dealloc {
    [title release];
    [subtitle release];
}


@end
