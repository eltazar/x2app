//
//  Notizia.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMHTTPAccess.h"

@interface Notizia : UIViewController <UIWebViewDelegate, UIAlertViewDelegate, WMHTTPAccessDelegate> {
    
@private
    NSInteger _idNotizia;
    NSMutableDictionary *_dataModel;
    UIActivityIndicatorView *_activityIndicator;
}

@property (nonatomic, retain) IBOutlet UIWebView *webV;
@property (nonatomic, assign) NSInteger idNotizia;
@property (nonatomic, assign) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
