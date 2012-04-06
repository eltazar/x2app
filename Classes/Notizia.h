//
//  Notizia.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 26/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatabaseAccess.h"

@interface Notizia : UIViewController<UIWebViewDelegate, UIAlertViewDelegate, DatabaseAccessDelegate> {
    
@private
    NSInteger _idNotizia;
    NSMutableDictionary *_dataModel;
    DatabaseAccess *_dbAccess;
}

@property (nonatomic, assign) NSInteger idNotizia;

@end
