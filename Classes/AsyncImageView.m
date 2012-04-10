//
//  AsyncImageView.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 16/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"


@implementation AsyncImageView


@synthesize delegate=_delegate;


- (void)loadImageFromURL:(NSURL*)url {
    
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    if (connection!=nil) { 
        [connection cancel];
        [connection release];
        connection = nil;
        [data release]; 
        data = nil;
    }
    NSURLRequest* request = [NSURLRequest requestWithURL:url
											 cachePolicy:NSURLRequestUseProtocolCachePolicy
										 timeoutInterval:60.0];
    connection = [[NSURLConnection alloc]
				  initWithRequest:request delegate:self];
	
		//TODO error handling, what if connection is nil?
}

- (void)connection:(NSURLConnection *)theConnection
	didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
		data =
		[[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    NSLog(@"%@::connectionDidFinishLoading", [self class]);
    [connection release];
    connection=nil;
	
    
	
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
	
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );
	
    [self addSubview:imageView];
    imageView.frame = self.bounds;
    [imageView setNeedsLayout];
    [self setNeedsLayout];
    [data release];
    data = nil;
    if (self.delegate) {
        [self.delegate didLoadImageInAysncImageView:self];
    }
}

- (UIImage*) image {
    UIImageView* iv = [[self subviews] objectAtIndex:0];
    return [iv image];
}

- (void)dealloc {
    self.delegate = nil;
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}

@end