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


@interface Commento : UIViewController {
@private
	NSString *_insegnaEsercente;
    NSString *_data;
    NSString *_testoCommento;
    // IBOutlets:
    UILabel *_insegnaEsercenteLbl;
	UILabel *_dataLbl;	
	UITextView *_testoCommentoTextView;
}

@property (nonatomic, retain) NSString *insegnaEsercente;
@property (nonatomic, retain) NSString *data;
@property (nonatomic, retain) NSString *testoCommento;

@property (nonatomic, retain) IBOutlet UILabel *insegnaEsercenteLbl;
@property (nonatomic, retain) IBOutlet UILabel *dataLbl;
@property (nonatomic, retain) IBOutlet UITextView *testoCommentoTextView;




@end
