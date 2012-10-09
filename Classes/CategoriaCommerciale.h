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
#import "WMHTTPAccess.h"
#import "PullableView.h"


@interface CategoriaCommerciale : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, MKMapViewDelegate, UIAlertViewDelegate, GeoDecoderDelegate, WMHTTPAccessDelegate, UIGestureRecognizerDelegate, PullableViewDelegate> {
@private
    BOOL lastFetchWasASearch;
    BOOL inSearchUI;
    BOOL didFetchAllRows;
    NSString *_categoria;
    GeoDecoder *_geoDec;
    NSArray* _tempBuff;
    // IBOs:
    UISearchBar *_searchBar;
    UITableView *_tableView;
    MKMapView *_mapView;
    UIView *_footerView;
    UIActivityIndicatorView *_activityIndicator;
    UIActivityIndicatorView *_searchActivityIndicator;
    UISegmentedControl *_searchSegCtrl;
    UISegmentedControl *_mapTypeSegCtrl;
    
@protected
    
    NSString *_urlString;
    NSMutableArray *_dataModel;
    CLLocationCoordinate2D location;
    BOOL queryingMoreRows;
    PullableView *leftPanel;
}
@property (nonatomic, retain) PullableView *leftPanel;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UIView *footerView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *searchActivityIndicator;
@property (nonatomic, retain) IBOutlet UISegmentedControl *searchSegCtrl;
@property (nonatomic, retain) UILabel *sortingLabel;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapTypeSegCtrl;

@property (nonatomic, retain, readonly) NSMutableArray *dataModel;


- (id)initWithTitle:(NSString *)title categoria:(NSString *)cat location:(CLLocationCoordinate2D)lo;

- (IBAction)didChangeSearchSegCtrlState:(id)sender;
- (IBAction)didChangeMapTypeSegCtrlState:(id)sender;

- (void)fetchRows;

@end
