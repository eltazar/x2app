//
//  Coupon.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 12/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CJSONDeserializer.h"
#import "PerDueCItyCardAppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "DettaglioRistoCoupon.h"
#import "DettaglioEsercenteCoupon.h"
#import "DettaglioEsercenteGenerico.h"
#import "AltreOfferte.h"
#import "Pagamento2.h"
#import "OpzioniCoupon.h"
#import "AsyncImageView.h"
#import "Reachability.h"
#import "FBConnect.h"
#import "Facebook.h"

@interface Coupon : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,  FBSessionDelegate, FBDialogDelegate, FBRequestDelegate>{
        
	NSInteger identificativoesercente;
	IBOutlet UIViewController *insintesi;
	IBOutlet UIViewController *termini;
	IBOutlet UIViewController *dipiu;
	IBOutlet UIViewController *contatti;

	NSMutableArray *rows;
	NSDictionary *dict2;
	NSURL *url;
	NSURL *url2;
	NSDictionary *dict;
	UIViewController *detail;

	IBOutlet UILabel *titolo;
	IBOutlet UILabel *riepilogo;

	IBOutlet UILabel *sconto;
	IBOutlet UILabel *risparmio;

	IBOutlet UIButton *compra;
	IBOutlet UIButton *compratermini;
	IBOutlet UIButton *comprasintesi;
	IBOutlet UIButton *compradipiu;

	IBOutlet UIActivityIndicatorView *CellSpinner;

	
	UITableView *tableview;
	IBOutlet UITableViewCell *cellacoupon;
	IBOutlet UITableViewCell *cellainfocoupon;
	IBOutlet UITableViewCell *cellanomesercente;

	NSString *sintesitxt;
	IBOutlet UIWebView *insintesitext;
	

	
	NSString *condizionitext;
	IBOutlet UIWebView *condizionitxt;
	
	NSString *dipiutxt;
	IBOutlet UIWebView *dipiutext;
	NSInteger identificativo;
	int tipodettaglio;
	
	IBOutlet UILabel *tempo;
	NSTimer *timer;
	int secondsLeft;
	
	/*facebook*/
    NSArray *permissions;    
	UIAlertView *facebookAlert;
	NSString *username;
	BOOL post;
    PerDueCItyCardAppDelegate *appDelegate;	
	Reachability* internetReach;
	Reachability* wifiReach;
	UIActionSheet *aSheet;
	UIActionSheet *aSheet2;
	IBOutlet UIViewController *fotoingrandita;
	IBOutlet UIImageView *photobig;
	IBOutlet UIViewController *faq;
	IBOutlet UIWebView *faqwebview;
	IBOutlet UILabel *titololabel; //nella view "In sintesi"
    BOOL waitingForFacebook;
		
}

@property (nonatomic,retain) IBOutlet UILabel *titolo;
@property (nonatomic,retain) IBOutlet UILabel *titololabel;

@property (nonatomic,retain) IBOutlet UILabel *riepilogo;
@property (nonatomic,retain) IBOutlet UILabel *tempo;

@property (nonatomic,retain) IBOutlet UILabel *sconto;
@property (nonatomic,retain) IBOutlet UILabel *risparmio;
@property (nonatomic, retain) IBOutlet UIButton *compra;
@property (nonatomic, retain) IBOutlet UIButton *compratermini;
@property (nonatomic, retain) IBOutlet UIButton *comprasintesi;
@property (nonatomic, retain) IBOutlet UIButton *compradipiu;

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *CellSpinner;
@property (nonatomic,retain) UIViewController *fotoingrandita;
@property (nonatomic,retain) UIViewController *faq;

@property (nonatomic,retain) IBOutlet UIImageView *photobig;

@property(nonatomic,retain) NSTimer *timer;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) UIWebView *faqwebview;


/*facebook*/
@property(nonatomic,retain) UIAlertView *facebookAlert;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,assign) BOOL post;

/*facebook*/
-(void)getFacebookName;
-(void)postToWall;




- (IBAction)AltreOfferte:(id)sender;
- (IBAction)Opzioni:(id)sender;
- (void)countDown;
-(void)Paga:(id)sender;
-(int)check:(Reachability*) curReach;
- (void) spinTheSpinner;
- (void) doneSpinning;
- (IBAction)chiudi:(id)sender;
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
