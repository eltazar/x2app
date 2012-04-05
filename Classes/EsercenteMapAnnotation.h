//
//  GoogleHQAnnotation.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 10/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface EsercenteMapAnnotation : NSObject <MKAnnotation>  {
	CLLocationCoordinate2D _coordinate;
	NSString *_title;
	NSString *_subtitle;
	NSInteger _idEsercente;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly) NSInteger idEsercente;

- (id)initWithLatitudine:(CLLocationDegrees)lati longitudine:(CLLocationDegrees)longi insegna:(NSString *)ins indirizzo:(NSString* )ind idEsercente:(int)idEserc;



@end