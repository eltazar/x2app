//
//  RichiediCardViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichiediCardViewController : UITableViewController{
    
    NSMutableArray *sectionData;
    NSMutableArray *sectionDescription;
    
    NSString *nome;
    NSString *cognome;
    NSString *email;
    NSString *telefono;

}
@end
