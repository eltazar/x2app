//
//  DatiPag.h
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 02/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Celladati.h"


@interface DatiPag : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate,UITextFieldDelegate>{
	IBOutlet UITableView *tableinfopagamento;
	IBOutlet UITableViewCell *celladato;	
	
	IBOutlet UIPickerView * tipoPicker;
	NSArray *arrayTipi;
	IBOutlet UIPickerView * scadenzaPicker;
	NSArray *arrayMesi;
	NSArray *arrayAnni;
	IBOutlet UIView *tipocartaPick;
	IBOutlet UIView *scadenzacartaPick;

	IBOutlet UIToolbar *confermatipo;
	IBOutlet UIToolbar *confermadata;


    NSString * currentKey;
    UITextField * currentField;

	IBOutlet UITextField *campo;
	CGFloat animatedDistance;

	
}

@property (nonatomic,retain) IBOutlet UITableView *tableinfopagamento;


@property (nonatomic,retain) IBOutlet UITextField * campo;
@property (nonatomic,retain) NSString * key;

@property (nonatomic,retain) IBOutlet UIView *tipocartaPick;
@property (nonatomic,retain) IBOutlet UIView *scadenzacartaPick;

@property (nonatomic, retain) IBOutlet UIToolbar *confermatipo;
@property (nonatomic, retain) IBOutlet UIToolbar *confermadata;

-(IBAction)confermatipo:(id)sender;
-(IBAction)confermadata:(id)sender;

@end
