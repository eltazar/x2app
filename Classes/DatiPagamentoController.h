//
//  DatiPagamentoController.h
//  PerDueCItyCard
//
//  Created by mario greco on 29/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PickerViewController;

@protocol DatiPagamentoDelegate;


@interface DatiPagamentoController : UITableViewController<UITextFieldDelegate, UIActionSheetDelegate>{
    NSArray *sectionDescripition;
    NSArray *sectionData;
    
    PickerViewController *pickerCards;
    PickerViewController *pickerDate;
    //UIActionSheet *myActionSheet;
    
    //dati carta di credito
    NSString *titolare;
    NSString *numeroCarta;
    NSString *scadenza;
    NSString *tipoCarta;
    NSString *cvv;
    
    NSUserDefaults *prefs;
}

@property(nonatomic, retain) NSString *titolare;
@property(nonatomic, retain) NSString *numeroCarta;
@property(nonatomic, retain) NSString *scadenza;
@property(nonatomic, retain) NSString *tipoCarta;
@property(nonatomic, retain) NSString *cvv;

@property(nonatomic, assign) id<DatiPagamentoDelegate> delegate;

-(void)fillCell: (UITableViewCell *)cell rowDesc:(NSDictionary *)rowDesc;

@end

@protocol DatiPagamentoDelegate <NSObject>
//-(void)publishViewControllerDidInsert:(PublishViewController *)viewController aJob:(Job *)job;
-(void)didSavePaymentDetail;
-(void)didAbortPaymentDetail;

@end