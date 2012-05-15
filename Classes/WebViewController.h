//
//  WebViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 15/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController{
    
    @private
    IBOutlet UIWebView *webView;
    NSString *urlString;
}
@property(nonatomic, retain) NSString *urlString;
@property(nonatomic, retain) IBOutlet UIWebView *webView;

-(id) initWithUrlString:(NSString *)urlStr;

@end
