//
//  CarteViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbbinaCartaViewController.h"

@interface CarteViewController : UITableViewController <AbbinaCartaDelegate>
{
    NSMutableArray *sectionDescription;
    NSMutableArray *sectionData;
    BOOL temp;
    
    int numCarteAbbinate;
    
        
}
@end
