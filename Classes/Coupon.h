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
#import "FBConnect.h"
#import "Facebook.h"

#import "WMHTTPAccess.h"
#import "LoginControllerBis.h"

@interface Coupon : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MFMailComposeViewControllerDelegate,UIActionSheetDelegate,  FBSessionDelegate, FBDialogDelegate, FBRequestDelegate, WMHTTPAccessDelegate,LoginControllerBisDelegate>{
        
	NSDictionary *_dataModel;
    NSInteger _idCoupon;
    
    UILabel *_tempoLbl;
    // IBOs:
    UILabel *_titoloOffertaLbl; // è il testo a sx del tasto compra
    UIButton *_compraBtn;
    UIButton *_reloadBtn;
    UIActivityIndicatorView *_caricamentoSpinner;  
    UITableView *_tableview;
    UIViewController *_webViewController;
    UIViewController *_faqViewController;
    UIWebView *_faqWebView;
}


@property (nonatomic, retain) NSDictionary *dataModel;
@property (nonatomic, assign) NSInteger idCoupon;

// IBOs:
@property (nonatomic, retain) IBOutlet UILabel *titoloOffertaLbl; // è il testo a sx del tasto compra
@property (nonatomic, retain) IBOutlet UIButton *compraBtn;
@property (nonatomic, retain) IBOutlet UIButton *reloadBtn;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *caricamentoSpinner;
@property (nonatomic, retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) IBOutlet UIViewController *webViewContr;
@property (nonatomic, retain) IBOutlet UIViewController *faqViewController;
@property (nonatomic, retain) IBOutlet UIWebView *faqWebView;






/*facebook*/
- (void)postToWall;
- (void)logoutFromFB;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil isOffertaDelGiorno:(BOOL)isODG;

-(IBAction)refreshView:(id)sender;
- (IBAction)AltreOfferte:(id)sender;
//- (IBAction)Opzioni:(id)sender;
- (void)countDown;
-(void)Paga:(id)sender;


- (IBAction)chiudi:(id)sender;

@end
