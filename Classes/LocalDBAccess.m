//
//  LocalDBAccess.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalDBAccess.h"

// per scrivere plist sul device

@implementation LocalDBAccess

-(void)customInitialization
{ 
    
    NSLog(@"ENTRATO \n\n\n\n\n\n\n");
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL success;
    
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *plistDirectory = [NSString stringWithFormat:@"%@/Enterprise",documentDirectory];
    
    if ([[NSFileManager defaultManager] createDirectoryAtPath:plistDirectory withIntermediateDirectories:YES attributes:nil error:nil]) {
        mWritablePath = [plistDirectory stringByAppendingPathComponent:@"userCards.plist"]; 
    } 
    
    success = [fileManager fileExistsAtPath:mWritablePath];
    //check if plist already exist
    if(success)
    {
        
        carteUtente = [[NSMutableArray alloc] initWithContentsOfFile:mWritablePath];
        
        NSLog(@"PLIST ESISTE, %@",carteUtente);
        return;
    }
    
    
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"userCards.plist"];
    
    success = [fileManager copyItemAtPath:defaultPath toPath:mWritablePath error:nil];
    
    //NSLog(@"@@@@ mwriteble = %@,default = %@",mWritablePath,defaultPath);
    
    if(!success)
        NSLog(@"Failed to create DB");
    else 
        NSLog(@"Created editable copy of DB"); 
    
    carteUtente = [[NSMutableArray alloc] initWithContentsOfFile:mWritablePath];
    
    NSLog(@"##### CARDS = %@",carteUtente);
}



//Add/Update the values in Plist:

-(void)salvaDatiInCarteUtente:(NSArray *)dati
{
    //store count in temp array
    
    //copy the contains main array into temp aray
    
    if(dati){
    
        NSMutableArray *mTempArray = [[NSMutableArray alloc] initWithArray:carteUtente];
        
        //get the updated value into dict
        
        NSMutableDictionary *aCard = [[NSMutableDictionary alloc] init];
        [aCard setObject:[dati objectAtIndex:0] forKey:@"nome"];
        [aCard setObject:[dati objectAtIndex:1] forKey:@"tessera"];
        [aCard setObject:[dati objectAtIndex:2] forKey:@"data"];
        
        [mTempArray addObject:aCard];
        
        carteUtente = [mTempArray retain];
        
        [mTempArray release];
    
    //[DownloadClubTableView reloadData];
    
    } 
    //write the data into plist
    
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *plistDirectory = [NSString stringWithFormat:@"%@/Enterprise",documentDirectory];
    
    NSString *mPath = [plistDirectory stringByAppendingPathComponent:@"userCards.plist"]; 
    
    [carteUtente writeToFile:mPath atomically:YES];
    
}


@end
