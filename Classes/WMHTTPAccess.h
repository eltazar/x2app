//
//  WMHTTPAccess.h
//  WMKit
//
//  Created by Gabriele "Whisky" Visconti on 11/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    WMHTTPAccessConnectionMethodGET, 
    WMHTTPAccessConnectionMethodPOST
} WMHTTPAccessConnectionMethod;


@protocol WMHTTPAccessDelegate;



@interface WMHTTPAccess : NSObject <NSURLConnectionDelegate> {
@private
    NSMutableDictionary *_connectionDict;
    NSMutableDictionary *_dataDict;
    NSMutableDictionary *_delegateDict;
}


+ (WMHTTPAccess *)sharedInstance;
- (void)startHTTPConnectionWithURL:(NSURL *)url method:(WMHTTPAccessConnectionMethod)method parameters:(NSDictionary *)parameters delegate:(id<WMHTTPAccessDelegate>)delegate;
- (void)startHTTPConnectionWithURLString:(NSString *)urlString method:(WMHTTPAccessConnectionMethod)method parameters:(NSDictionary *)parameters delegate:(id<WMHTTPAccessDelegate>)delegate;


@end



@protocol WMHTTPAccessDelegate <NSObject>
@optional
- (void)didReceiveJSON:(NSDictionary *)jsonDict;
@optional
- (void)didReceiveString:(NSString *)receivedString;
@optional
- (void)didReceiveData:(NSMutableData *)receivedData;
@required
- (void)didReceiveError:(NSError *)error;
@end
