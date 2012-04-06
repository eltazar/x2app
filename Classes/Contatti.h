//
//  Contatti.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface Contatti : UIViewController <UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate>  {
	UIButton *close;
	UITableView *tableview;
	IBOutlet UIView *sito;
	IBOutlet UIWebView *webView;
	IBOutlet UIWebView *infocarta;
	
}
@property (nonatomic, retain) IBOutlet UIButton *close;
@property (nonatomic,retain) IBOutlet UITableView *tableview;
@property (nonatomic, retain) UIView *sito;


@property (nonatomic, retain) UIWebView *webView;

- (IBAction)chiudi:(id)sender;
- (IBAction)chiudisito:(id)sender;

@end
