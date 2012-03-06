//
//  CarteViewController.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarteViewController : UITableViewController
{
    NSMutableArray *sectionDescripition;
    NSMutableArray *sectionData;
    NSString *nome;
    NSString *data;
    NSString *tessera;
    BOOL temp;
    
    NSMutableArray *cards;
    NSString *mWritablePath;
        
}

@property(nonatomic, retain) NSMutableArray *cards;
@end
