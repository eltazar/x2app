//
//  GoogleHQAnnotation.m
//  Per Due
//
//  Created by Giuseppe Lisanti on 10/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EsercenteMapAnnotation.h"

@implementation EsercenteMapAnnotation

@synthesize coordinate=_coordinate, title=_title, subtitle=_subtitle, idEsercente=_idEsercente;


- (id)initWithLatitudine:(CLLocationDegrees)lati longitudine:(CLLocationDegrees)longi insegna:(NSString *)ins indirizzo:(NSString *)ind idEsercente:(int)idEserc {
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake(lati, longi);
        _title = [ins copy];
        _subtitle = [ind copy];
        _idEsercente = idEserc;
    }
    return self;
}


- (void)dealloc {
    [_title release];
    [_subtitle release];
    [super dealloc];
}


@end
