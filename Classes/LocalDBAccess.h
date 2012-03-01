//
//  LocalDBAccess.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalDBAccess : NSObject
{
    NSString *mWritablePath;
    NSMutableArray *carteUtente;
}

@property(nonatomic,retain) NSMutableArray *carteUtente;
-(void)customInitialization;
-(void)salvaDatiInCarteUtente:(NSArray *)dati;

@end
