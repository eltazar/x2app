//
//  CachedAsyncImageView.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 10/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CachedAsyncImageView : UIImageView <NSURLConnectionDelegate> {
@private
    NSString *_urlString;
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
@protected
    UIActivityIndicatorView *_activityIndicator;
}

- (void)loadImageFromURLString:(NSString *)urlString;
- (void)loadImageFromURL:(NSURL *)url;
- (void)setActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style;
+ (void)emptyCache;

@end
