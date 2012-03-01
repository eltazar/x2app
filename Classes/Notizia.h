//
//  Notizia.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "Reachability.h"


@interface Notizia : UIViewController<UIWebViewDelegate,UIAlertViewDelegate> {
	NSInteger identificativo;
	NSMutableArray *rows;
	NSDictionary *dict;
	IBOutlet UILabel *titolo;
	UIWebView *webView;
	NSURL *url;
	Reachability* internetReach;
	Reachability* wifiReach;
}

@property (nonatomic, readwrite) NSInteger identificativo; 
@property (retain,nonatomic) NSArray *rows;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain)NSURL *url;

- (void) spinTheSpinner;
- (void) doneSpinning;
-(int)check:(Reachability*) curReach;

@end
