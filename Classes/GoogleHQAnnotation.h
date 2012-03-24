//
//  GoogleHQAnnotation.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 10/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GoogleHQAnnotation : NSObject <MKAnnotation>  {
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
	int ide;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


- (id)init:(CLLocationDegrees)latitudine:(CLLocationDegrees)longitudine:(NSString *)nome:(NSString* )indirizzo:(int)identificativo;
- (NSString *)title;
- (NSString *)subtitle;
- (int)ide;

@end