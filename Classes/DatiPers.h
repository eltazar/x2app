//
//  DatiPers.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 30/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "Celladati.h"

@interface DatiPers : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate> {
	IBOutlet UITableView *tableinfopersonali;
	IBOutlet UITableViewCell *celladato;

	NSMutableDictionary * myAccount;
    NSString * currentKey;
    UITextField * currentField;
	IBOutlet UILabel * mytext;
	IBOutlet UITextField *campo;
	NSString *nomeSalvato;
	NSString *cognomeSalvato;
	NSString *emailSalvata;
	NSString *telefonoSalvato;




}


@property (nonatomic,retain) IBOutlet UITableView *tableinfopersonali;

@property (nonatomic,retain) IBOutlet UITextField * campo;


@end
