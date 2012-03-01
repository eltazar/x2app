//
//  Commento.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"
#import "Reachability.h"


@interface Commento : UIViewController<UIAlertViewDelegate> {
	NSString *Nome;
	IBOutlet UILabel *nomeEsercente;
	NSString *data;
	IBOutlet UILabel *datalabel;
	UIViewController *detail;
	NSString *commento;
	IBOutlet UITextView *contenuto;
	Reachability* internetReach;
	Reachability* wifiReach;
}

@property (nonatomic, retain) UILabel *titolo;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *commento;
@property (nonatomic, retain) NSString *Nome;
@property (nonatomic, retain) IBOutlet UITextView *contenuto;

-(int)check:(Reachability*) curReach;


@end
