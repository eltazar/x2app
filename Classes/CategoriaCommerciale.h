//
//  CategoriaCommerciale.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 23/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "GeoDecoder.h"


@interface CategoriaCommerciale : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate, MKAnnotation, UIAlertViewDelegate, GeoDecoderDelegate> {
    NSMutableArray *rows;
    
    IBOutlet UISearchBar *searchBar;
    IBOutlet UITableView *tableView;
    IBOutlet MKMapView *mapView;
    IBOutlet UIView *footerView;
    IBOutlet UISegmentedControl *searchSegCtrl;
    IBOutlet UISegmentedControl *mapTypeSegCtrl;
}


@property (nonatomic, retain) NSMutableArray *rows;

@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *searchSegCtrl;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapTypeSegCtrl;


- (id)initWithTitle:(NSString *)title phpFile:(NSString *)phpFile phpSearchFile:(NSString *)phpSearchFile latitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (void)spinTheSpinner;
- (void)doneSpinning;

- (IBAction)didChangeSearchSegCtrlState:(id)sender;
- (IBAction)didChangeMapTypeSegCtrlState:(id)sender;


@end
