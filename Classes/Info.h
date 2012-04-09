//
//  Info.h
//  Per Due
//
//  Created by Giuseppe Lisanti on 02/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface Info : UIViewController <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>  {
	UIButton *close;
	UIButton *credits;
	UITableView *tableview;
	IBOutlet UIView *sito;
	IBOutlet UIWebView *webView;
	IBOutlet UIWebView *infocarta;
	IBOutlet UIView *cred;	

}
@property (nonatomic, retain) IBOutlet UIButton *close;
@property (nonatomic, retain) IBOutlet UIButton *credits;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) UIView *sito;
@property (nonatomic, retain) UIView *cred;


@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) UIWebView *infocarta;

- (IBAction)opencredits:(id)sender;
- (IBAction)switchinfo:(id)sender;
- (IBAction)chiudi:(id)sender;
- (IBAction)chiudisito:(id)sender;


@end
