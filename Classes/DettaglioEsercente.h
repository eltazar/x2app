//
//  DettaglioEsercente.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 04/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MessageUI/MessageUI.h>
#import "WMHTTPAccess.h"

@class IndexPathMapper;

@interface DettaglioEsercente : UIViewController <UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate, CLLocationManagerDelegate,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate, WMHTTPAccessDelegate> {
    NSInteger _idEsercente;
    // IBOutlets:
    UITableView *_tableview;
    UIActivityIndicatorView *_activityIndicator;
    UIViewController *_mapViewController;
    MKMapView *_mkMapView;
    UISegmentedControl *_mapTypeSegCtrl;
    UIViewController *_condizioniViewController;
    UITextView *_condizioniTextView;
    UIViewController *_sitoViewController;
    UIWebView *_sitoWebView;

    
@private
    IndexPathMapper *_idxMap;
    NSDictionary *_dataModel;
    BOOL isDataModelReady;
    
@protected
    BOOL isGenerico;
    BOOL isCoupon;
    NSString *urlString;
    NSString *urlStringCoupon;
    NSString *urlStringGenerico;
    NSString *urlStringValiditaCarta;
}


@property (nonatomic, assign) NSInteger idEsercente; 
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UIViewController *mapViewController;
@property (nonatomic, retain) IBOutlet MKMapView *mkMapView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *mapTypeSegCtrl;
@property (nonatomic, retain) IBOutlet UIViewController *condizioniViewController;
@property (nonatomic, retain) IBOutlet UITextView *condizioniTextView;
@property (nonatomic, retain) IBOutlet UIViewController *sitoViewController;
@property (nonatomic, retain) IBOutlet UIWebView *sitoWebView;


// property "protected" (na mezza specie): nell'interfaccia pubblica non ha l'ivar corrispondente, che è solo nella privata. nella privata viede ridefinita come readwrite.
@property (nonatomic, retain, readonly) NSDictionary *dataModel;
@property (nonatomic, retain, readonly) IndexPathMapper *idxMap;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil couponMode:(BOOL)couponMode genericoMode:(BOOL)genericoMode;
- (IBAction)mostraTipoMappa:(id)sender;


@end


/*********************************************************************/


@interface IndexPathMapper : NSObject {}

- (void)setTitle:(NSString *)title forSection:(NSInteger)section;
- (NSString *)titleForSection:(NSInteger)section;
- (void)setKey:(NSString *)key forSection:(NSInteger)section row:(NSInteger)row;
- (NSString *)keyForSection:(NSInteger)section row:(NSInteger)row; 
- (void)removeKeyAtSection:(NSInteger)section row:(NSInteger)row;
- (void)removeKey:(NSString *)key;

- (NSInteger)sections;
- (NSInteger)rowsInSection:(NSInteger)section;

- (void)setKey:(NSString *)key forIndexPath:(NSIndexPath *)indexPath;
- (NSString *)keyForIndexPath:(NSIndexPath *)indexPath;
- (void)removeKeyAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForKey:(NSString *) key;


@end






