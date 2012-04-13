//
//  Info.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 02/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface Info : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, UIWebViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>  {
	UIButton *_closeBtn;
	UIButton *_creditsBtn;
	UITableView *_tableview;
	
    UIWebView   *_infoWebView;
    UIView      *_sitoPerDueView;
    UIWebView   *_sitoPerDueWebView;
	UIView      *_contattiView;
}


@property (nonatomic, retain) IBOutlet UIButton *closeBtn;
@property (nonatomic, retain) IBOutlet UIButton *creditsBtn;
@property (nonatomic, retain) IBOutlet UITableView *tableview;

@property (nonatomic, retain) IBOutlet UIWebView *infoWebView;
@property (nonatomic, retain) IBOutlet UIView    *sitoPerDueView;
@property (nonatomic, retain) IBOutlet UIWebView *sitoPerDueWebView;
@property (nonatomic, retain) IBOutlet UIView    *contattiView;



- (IBAction)apriContattiView:(id)sender;
- (IBAction)chiudiContattiView:(id)sender;
- (IBAction)chiudiSitoPerDueView:(id)sender;
- (IBAction)chiudi:(id)sender;


@end
