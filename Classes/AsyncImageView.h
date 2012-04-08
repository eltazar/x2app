//
//  AsyncImageView.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AsyncImageViewDelegate;


@interface AsyncImageView : UIView {
    NSURLConnection* connection;
    NSMutableData* data;
    id<AsyncImageViewDelegate> _delegate;
}


@property (nonatomic, retain) id<AsyncImageViewDelegate> delegate;

- (void)loadImageFromURL:(NSURL*)url;
- (void)connection:(NSURLConnection *)theConnection;
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection;
- (UIImage*) image;

@end


@protocol AsyncImageViewDelegate <NSObject>

- (void)didLoadImageInAysncImageView:(AsyncImageView *)asyncImageView;

@end