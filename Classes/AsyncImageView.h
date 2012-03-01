//
//  AsyncImageView.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AsyncImageView : UIView {
    NSURLConnection* connection;
    NSMutableData* data;
}


- (void)loadImageFromURL:(NSURL*)url;
- (void)connection:(NSURLConnection *)theConnection;
- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection;
- (UIImage*) image;

@end
