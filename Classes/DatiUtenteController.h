//
//  DatiUtenteController.h
//  PerDueCItyCard
//
//  Created by mario greco on 05/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatiUtenteDelegate;

@interface DatiUtenteController : UITableViewController<UITextFieldDelegate>{
    NSArray *sectionDescripition;
    NSArray *sectionData;
    
    //dati carta di credito
    NSString *nome;
    NSString *cognome;
    NSString *telefono;
    NSString *email;
    
    NSUserDefaults *prefs;
}

@property(nonatomic, retain) NSString *nome;
@property(nonatomic, retain) NSString *cognome;
@property(nonatomic, retain) NSString *telefono;
@property(nonatomic, retain) NSString *email;

@property(nonatomic, assign) id<DatiUtenteDelegate> delegate;

-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc;

@end

@protocol DatiUtenteDelegate <NSObject>
//-(void)publishViewControllerDidInsert:(PublishViewController *)viewController aJob:(Job *)job;
-(void)didSaveUserDetail;
-(void)didAbortUserDetail;

@end
