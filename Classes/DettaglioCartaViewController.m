//
//  ControlloCartaController.m
//  PerDueCItyCard
//
//  Created by mario greco on 07/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DettaglioCartaViewController.h"
#import "RichiediCardViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilita.h"
#import "BaseCell.h"
#import "MBProgressHUD.h"
#import "AbbinaCartaViewController.h"
#import "PDHTTPAccess.h"
#import "LocalDatabaseAccess.h"
#import "FindNearCompanyController.h"

@interface DettaglioCartaViewController(){
    CartaPerDue *_card;
    NSMutableArray *_sectionData;
    NSMutableArray *_sectionDescription;
    BOOL isNotBind;
}
@property (nonatomic, retain) CartaPerDue *card;
@property (nonatomic, retain) NSMutableArray *sectionData;
@property (nonatomic, retain) NSMutableArray *sectionDescription;
- (void)didAssociateCard:(NSString *)response;
@end


@implementation DettaglioCartaViewController


@synthesize viewForImage=_viewForImage;
@synthesize card=_card, sectionData=_sectionData, sectionDescription=_sectionDescription;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithCard:(CartaPerDue *)aCard {
    // Dato che nibName è nil, e non abbiamo fatto override di loadView, allora initwithNibName cerca di caricare nell'ordine: DettaglioCartaView.xib, DettaglioCartaViewController.xib.
    self = [super initWithNibName:@"DettaglioCartaViewController" bundle:nil];
    if(self){
        NSLog(@"istanziata dettaglio carta");
        self.card = aCard;
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(! [Utilita networkReachable]){
        NSLog(@"internet assente errore");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
		[alert show];
        [alert release];
    }
    else{ 
        //se la carta non è scaduta controllo se è associata ad un altro dispositivo
        if(! [self.card isExpired]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Attendere...";
            hud.detailsLabelText = @"Controllo carta in corso...";
            [PDHTTPAccess cardDeviceAssociation:self.card.number request:@"Check" delegate:self];
        }
        else{
            //altrimenti non faccio query sul db  e mostro direttamente i dati
            NSMutableArray *secExpired = [[NSMutableArray alloc] init];

            //se c'è un'altra carta valida posso eliminare questa scaduta
            if([[LocalDatabaseAccess getInstance] isThereAvalidCard]){
                [secExpired insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                          @"removeCard",                @"DataKey",
                                          @"InfoCell",            @"kind",
                                          @"Rimuovi carta",   @"label",
                                          @"",                      @"detailLabel",
                                          @"",                      @"img",
                                          //[NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                          nil] autorelease] atIndex: 0];
            }
            else {
                //altrimenti posso acquistare o richiedere una nuova carta
                
                [secExpired insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"buyOnline",                @"DataKey",
                                           @"ActionCell",            @"kind",
                                           @"Acquista carta online",   @"label",
                                           @"",                      @"detailLabel",
                                           @"",                      @"img",
                                           [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                           nil] autorelease] atIndex: 0];
                [secExpired insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                           @"request",                @"DataKey",
                                           @"ActionCell",            @"kind",
                                           @"Richiedi carta",   @"label",
                                           @"",                      @"detailLabel",
                                           @"",                      @"img",
                                           [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                           nil] autorelease] atIndex: 1];
            }
             
            [self.sectionData insertObject:secExpired atIndex:0];
            [secExpired release];
            [self.tableView reloadData];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
   // NSLog(@"self.cercaLabel.shadowColor : %@", self.cercaLabel.shadowColor);
    //query su db per verificare se carta è stata abbinata ad altro dispositivo
    //se si viene mostrato avviso e rimuovere "cerca esercizi commerciali ...."
    //al suo posto mostare tasto "riabbina"
    //inoltre inserire tasto "rimuovi abbinamento"

    self.title = @"Carta PerDue";
    
    isNotBind = FALSE;
    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaX2hd.png"]];
    [cartaView setFrame:CGRectMake(11, 12, 300, 180)];
    
    
    //    
    //    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
    //    titolareTextField.tag = 5;
    //    
    //    [self.view addSubview:titolareTextField];
    //    [self.view addSubview:cartaView];
    
    CGFloat padding = 10;
    CGFloat boundsWidth = cartaView.frame.size.width;
    
    UITextField *titolareLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + padding + 4, boundsWidth-2*padding, 28)];
    titolareLabel.font = [UIFont systemFontOfSize:15];
    titolareLabel.text = [NSString stringWithFormat:@"%@ %@", self.card.name, self.card.surname];
    titolareLabel.backgroundColor = [UIColor clearColor];
    //titolareLabel.tag = 5;
    
    
    UITextField *numeroCartaLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+2*padding, boundsWidth-2*padding, 28)];
    numeroCartaLabel.font = [UIFont systemFontOfSize:15];
    numeroCartaLabel.text = self.card.number;
    numeroCartaLabel.backgroundColor = [UIColor clearColor];
    //numeroCartaLabel.tag = 4;
    
    UITextField *scadenzaLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + titolareLabel.frame.size.height+2*padding, boundsWidth-2*padding, 28)];
    scadenzaLabel.font = [UIFont systemFontOfSize:15];
    scadenzaLabel.text = self.card.expiryString;
    scadenzaLabel.textAlignment = UITextAlignmentRight;
    scadenzaLabel.backgroundColor = [UIColor clearColor];
    //scadenzaLabel.tag = 3;
    
    [cartaView addSubview:scadenzaLabel];
    [cartaView addSubview:numeroCartaLabel];
    [cartaView addSubview:titolareLabel];
    
    [self.viewForImage addSubview:cartaView];
    
    [cartaView release];
    [numeroCartaLabel release];
    [titolareLabel release];
    [scadenzaLabel release];

    if (self.card.isExpired) {
        //attacco adesivo "scaduta"
        UIImageView *scadutaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"scadutaImg.png"]];
        [scadutaView setFrame:CGRectMake(11, 10, 300, 180)];
        [self.viewForImage addSubview:scadutaView];
        [scadutaView release];
    }
    
//    NSMutableArray *secFind = [[NSMutableArray alloc] init];
//    NSMutableArray *secExpired = [[NSMutableArray alloc] init];
//    
//    sectionDescription = [[NSMutableArray alloc] initWithObjects:@"", nil];
//    
//    if(self.card.isExpired){
//        
//        [secExpired insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                      @"buyOnline",                @"DataKey",
//                                      @"ActionCell",            @"kind",
//                                      @"Acquista carta online",   @"label",
//                                      @"",                      @"detailLabel",
//                                      @"",                      @"img",
//                                      [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
//                                      nil] autorelease] atIndex: 0];
//        [secExpired insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   @"request",                @"DataKey",
//                                   @"ActionCell",            @"kind",
//                                   @"Richiedi carta",   @"label",
//                                   @"",                      @"detailLabel",
//                                   @"",                      @"img",
//                                   [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
//                                   nil] autorelease] atIndex: 1];
//        sectionData = [[NSMutableArray alloc] initWithObjects:secExpired, nil];
//    }
//    else{
//        [secFind insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                                   @"find",                @"DataKey",
//                                   @"ActionCell",           @"kind",
//                                   @"Cerca esercenti vicini",   @"label",
//                                   @"",                      @"detailLabel",
//                                   @"",                      @"img",
//                                   [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
//                                   nil] autorelease] atIndex: 0];
//        sectionData = [[NSMutableArray alloc] initWithObjects:secFind, nil];
//    }
//    [secExpired release];
//    [secFind release];
    
    self.sectionDescription = [[[NSMutableArray alloc] initWithObjects:@"", nil] autorelease];    
    self.sectionData = [[[NSMutableArray alloc] init] autorelease];

}


- (void)viewDidUnload {
    self.viewForImage = nil;
    self.sectionDescription = nil;
    self.sectionData = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {   
    self.viewForImage = nil;
    
    self.card = nil;
    self.sectionData = nil;
    self.sectionDescription = nil;
    
    [super dealloc];
}


#pragma mark - WMHTTPAccessDelegate


- (void)didReceiveJSON:(NSDictionary *)jsonDict {
    
    NSLog(@"RICEVUTI DATI");
    
    NSString *receivedString1 = [jsonDict objectForKey:@"CardDeviceAssociation:Set"];
    
    if (receivedString1) {
        [self didAssociateCard:receivedString1];
        return;
    }
    
    NSString *receivedString = [jsonDict objectForKey:@"CardDeviceAssociation:Check"];
    
    //se carta è associata ad un altro dispositivo mostro taasti per riabbinamento e cancellazione
    if (receivedString && [receivedString isEqualToString:@"Associated:Another"]) {
        NSLog(@"carta associata ad altro dispositivo");
        
        NSMutableArray *bindSec = [[NSMutableArray alloc] init];
        
        [bindSec insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"rebind",                @"DataKey",
                                @"InfoCell",            @"kind",
                                @"Riabbina questa carta",   @"label",
                                @"",                      @"detailLabel",
                                @"",                      @"img",
                                //[NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                nil] autorelease] atIndex: 0];
        [bindSec insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"removeBinding",                @"DataKey",
                                @"InfoCell",            @"kind",
                                @"Rimuovi abbinamento",   @"label",
                                @"",                      @"detailLabel",
                                @"",                      @"img",
                                //[NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                nil] autorelease] atIndex: 1];
        //        [sectionDescription removeAllObjects];
        //        [sectionDescription insertObject:@"Carta già abbinata" atIndex:0];
        
        [self.sectionData removeAllObjects];
        [self.sectionData insertObject:bindSec atIndex:0];
        [bindSec release];
        isNotBind = TRUE;
        
    } else {
        //TODO: considerare altri casi di risposta carta?
        //altrimenti mostro il tasto "cerca"
        NSLog(@"status della carta = %@",receivedString);
        
        NSMutableArray *secFind = [[NSMutableArray alloc] init];
        [secFind insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                @"find",                @"DataKey",
                                @"ActionCell",           @"kind",
                                @"Cerca esercenti vicini",   @"label",
                                @"",                      @"detailLabel",
                                @"",                      @"img",
                                [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                nil] autorelease] atIndex: 0];
        [self.sectionData insertObject:secFind atIndex:0];
        [secFind release];
    }
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


-(void)didReceiveError:(NSError *)error{
    NSLog(@"AbbinaCartaViewController received connection error: \n\t%@\n\t%@\n\t%@", 
          [error localizedDescription], [error localizedFailureReason],
          [error localizedRecoveryOptions]);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionDescription.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {  
    return [self.sectionDescription objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{   
    if(self.sectionData && self.sectionData.count >  0){
        return [[self.sectionData objectAtIndex: section] count];
    } 
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    NSString *kind = [rowDesc objectForKey:@"kind"];
    int cellStyle = UITableViewCellStyleDefault;
    
    //NSLog(@"dataKey = %@, kind = %@",dataKey,kind);
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier: kind];
    
    //se non è recuperata creo una nuova cella
	if (cell == nil) {        
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
        
        //NSLog(@"CELL = %@",cell);
    }
    
    cell.textLabel.text = [rowDesc objectForKey:@"label"];
    
    if([dataKey isEqualToString:@"removeCard"] || [dataKey isEqualToString:@"rebind"] ||
       [dataKey isEqualToString:@"removeBinding"]){
        
        cell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}


#pragma mark - UITableViewDelegate


//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section == 0)
//        return 5;
//    else return  [super tableView:tableView heightForFooterInSection:section];
//}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 0 && isNotBind) {
        
        UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
        [customView setBackgroundColor:[UIColor clearColor]];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        
        lbl.backgroundColor = [UIColor clearColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.lineBreakMode = UILineBreakModeWordWrap;
        lbl.numberOfLines = 0;
        lbl.textAlignment =  UITextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];       
        
        
        lbl.text = @"La tua carta risulta abbinata ad un altro dispositivo, puoi scegliere se riabbinarla al dispositivo corrente oppure rimuoverla del tutto";
        
        UIFont *txtFont = [UIFont boldSystemFontOfSize:17];
        CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
        CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
        
        lbl.frame = CGRectMake(10, -17, tableView.bounds.size.width-20, labelSize.height+6);
        
        [customView addSubview:lbl];
        [lbl release];
        
        return customView;
    }
    
    else return nil;
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}


//setta il colore delle label dell'header BIANCHE
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    lbl.text = [self.sectionDescription objectAtIndex:section];

    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    // "Navigo" il model fino alla cella selezionata
    NSArray *sec = [self.sectionData objectAtIndex:indexPath.section];
    NSDictionary *row = [sec objectAtIndex:indexPath.row];
    NSString *dataKey = [row objectForKey:@"DataKey"];
    
    NSLog(@"DATA KEY = %@", dataKey);
    
    // Click su una carta
    if ([dataKey isEqualToString:@"buyOnline"]){
        NSLog(@"compra online");
        
        if(delegate && [delegate respondsToSelector:@selector(didBuyRequest:)]){
            [delegate didBuyRequest:self];
        }
    }
    else if([dataKey isEqualToString:@"request"]){
        RichiediCardViewController *richiediController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
        
        [self.navigationController pushViewController:richiediController animated:YES];
        [richiediController release];
    }
    else if([dataKey isEqualToString:@"find"]){
        
        NSLog(@"cerca esercenti");
        
      /*  BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
        
        if (locationAllowed == NO) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Service Disabled" 
                                                            message:@"To re-enable, please go to Settings and turn on Location Service for this app." 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else{
    //        FindNearCompanyController *findCtrl = [[FindNearCompanyController alloc] initWithNibName:@"FindNearCompanyController" bundle:nil];
            FindNearCompanyController *findCtrl = [[FindNearCompanyController alloc] initWithCard:self.card];
            [self.navigationController pushViewController:findCtrl animated:YES];
            [findCtrl release];
        }*/
    
        FindNearCompanyController *findCtrl = [[FindNearCompanyController alloc] initWithNibName:nil bundle:nil card:self.card];
        [self.navigationController pushViewController:findCtrl animated:YES];
        [findCtrl release];
    }
    else if([dataKey isEqualToString:@"rebind"]){
        //TODO: controllare bene come far avvenire l'associazione , se così semplicemente o come in "abbinaController"
        if([Utilita networkReachable]){
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"Attendere...";
            hud.detailsLabelText = @"Abbinamento in corso...";
            [PDHTTPAccess cardDeviceAssociation:self.card.number request:@"Set" delegate:self];
        }
        else{
            NSLog(@"internet assente");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Chiudi",nil];
            [alert show];
            [alert release];
        }
    }
    else if([dataKey isEqualToString:@"removeCard"]){
        NSError *error;
        [[LocalDatabaseAccess getInstance] removeStoredCard:self.card error:&error ];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:kDeletedCard object:nil];        
        if(self.delegate && [delegate respondsToSelector:@selector(didDeleteCard:)]){
            [delegate didDeleteCard:self];
        }
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - DettaglioCartaViewController


- (IBAction)cercaButtonClicked:(id)sender {
    NSLog(@"pulsante cerca premuto");
}


- (IBAction)acquistaButtonClicked:(id)sender {
    NSLog(@"pulsante acquista premuto");
}


- (IBAction)richiediButtonClicked:(id)sender {
    NSLog(@"pulsante richiedi premuto");
    // Caricare come modal?
    RichiediCardViewController *richiediController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
    
    [self.navigationController pushViewController:richiediController animated:YES];
    [richiediController release];
    
}


#pragma mark - DettaglioCartaViewController metodi privati


- (void)didAssociateCard:(NSString *)response {
    NSLog(@"didAssociateCard");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([response isEqualToString:@"Success"]) {
        NSLog(@"CARTA RIABBINATA"); 
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([response isEqualToString:@"Fail"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errore di rete" message:@"Riprova più tardi" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}


@end
