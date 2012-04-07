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
#import "AltreOfferte.h"
#import "Pagamento2.h"
#import "OpzioniCoupon.h"
#import "AsyncImageView.h"
#import "FBConnect.h"
#import "Facebook.h"

#import "DatabaseAccess.h"
#import "LoginControllerBis.h"

@interface Coupon : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,  FBSessionDelegate, FBDialogDelegate, FBRequestDelegate, DatabaseAccessDelegate,LoginControllerBisDelegate>{
        
	NSDictionary *_dataModel;
    NSInteger _idCoupon;
    
    // InfoCoupon.xib
    IBOutlet UILabel *_prezzoCouponLbl;
	IBOutlet UILabel *_scontoLbl;
	IBOutlet UILabel *_risparmioLbl;
    IBOutlet UILabel *_prezzoOrigLbl;
    IBOutlet UIActivityIndicatorView *_caricamentoImmagineSpinner;
    //
    IBOutlet UILabel *_titoloOffertaLbl; // è il testo a sx del tasto compra
    IBOutlet UIButton *_compraBtn;
    IBOutlet UIButton *_reloadBtn;
    IBOutlet UIActivityIndicatorView *_caricamentoSpinner;
    IBOutlet UILabel *_tempoLbl;    
    IBOutlet UITableView *_tableview;
    IBOutlet UIViewController *_webViewController;
    IBOutlet UIViewController *_faqViewController;
    IBOutlet UIWebView *_faqWebView;
}


@property (nonatomic, retain) NSDictionary *dataModel;
@property (nonatomic, assign) NSInteger idCoupon;

// InfoCoupon.xib
@property (nonatomic, retain) IBOutlet UILabel *prezzoCouponLbl;
@property (nonatomic, retain) IBOutlet UILabel *scontoLbl;
@property (nonatomic, retain) IBOutlet UILabel *risparmioLbl;
@property (nonatomic, retain) IBOutlet UILabel *prezzoOrigLbl;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *caricamentoImmagineSpinner;
//
@property (nonatomic, retain) IBOutlet UILabel *titoloOffertaLbl; // è il testo a sx del tasto compra
@property (nonatomic, retain) IBOutlet UIButton *compraBtn;
@property (nonatomic, retain) IBOutlet UIButton *reloadBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *caricamentoSpinner;
@property (nonatomic, retain) IBOutlet UILabel *tempoLbl;    
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIViewController *webViewContr;
@property (nonatomic, retain) IBOutlet UIViewController *faqViewController;
@property (nonatomic, retain) IBOutlet UIWebView *faqWebView;






/*facebook*/
-(void)getFacebookName;
-(void)postToWall;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOffertaDelGiorno:(BOOL)isODG;

-(IBAction)refreshView:(id)sender;
- (IBAction)AltreOfferte:(id)sender;
//- (IBAction)Opzioni:(id)sender;
- (void)countDown;
-(void)Paga:(id)sender;


- (IBAction)chiudi:(id)sender;
- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;

@end
