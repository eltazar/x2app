//
//  ValidateCardController.h
//  PerDueCItyCard
//
//  Created by mario greco on 05/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WMHTTPAccess.h"
@class CartaPerDue;

@interface ValidateCardController : UIViewController <WMHTTPAccessDelegate> {
    UIView* _pushView;
    UILabel *_companyLabel;
    UILabel *_cardLabel;
    UIButton *_validateBtn;
    UIActivityIndicatorView *spinner;
}

@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;
@property(nonatomic, retain) IBOutlet UIButton *validateBtn;
@property(nonatomic, retain) IBOutlet UILabel *companyLabel;
@property(nonatomic, retain) IBOutlet UILabel *cardLabel;
@property(nonatomic, retain)IBOutlet UIView *pushView;

-(id) initWhitCard:(CartaPerDue*)aCard company:(NSDictionary*)aCompany;
-(IBAction)validateRequestBtn:(id)sender;
@end
