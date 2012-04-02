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

@implementation DettaglioCartaViewController


@synthesize card=_card;
@synthesize viewForImage = _viewForImage;


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


- (void)viewDidLoad {
    [super viewDidLoad];
   // NSLog(@"self.cercaLabel.shadowColor : %@", self.cercaLabel.shadowColor);
    //query su db per verificare se carta è stata abbinata ad altro dispositivo
    //se si viene mostrato avviso e rimuovere "cerca esercizi commerciali ...."
    //al suo posto mostare tasto "riabbina"
    //inoltre inserire tasto "rimuovi abbinamento"

    
    UIImageView *cartaView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cartaGrande.png"]];
    [cartaView setFrame:CGRectMake(11, 20, 300, 180)];
    
    
    //    
    //    UITextField *titolareTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 191, 31)];
    //    titolareTextField.tag = 5;
    //    
    //    [self.view addSubview:titolareTextField];
    //    [self.view addSubview:cartaView];
    
    CGFloat padding = 10;
    CGFloat boundsWidth = cartaView.frame.size.width;
    
    UITextField *titolareLabel = [[UITextField alloc] initWithFrame:CGRectMake(padding, cartaView.frame.size.height/2 + padding, boundsWidth-2*padding, 28)];
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
        [scadutaView setFrame:CGRectMake(11, 20, 300, 180)];
        [self.viewForImage addSubview:scadutaView];
        [scadutaView release];
    }
    
    NSMutableArray *secFind = [[NSMutableArray alloc] init];
    NSMutableArray *secExpired = [[NSMutableArray alloc] init];
    
    sectionDescription = [[NSMutableArray alloc] initWithObjects:@"", nil];
    
    if(self.card.isExpired){
        
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
        sectionData = [[NSMutableArray alloc] initWithObjects:secExpired, nil];
    }
    else{
        [secFind insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                   @"find",                @"DataKey",
                                   @"ActionCell",           @"kind",
                                   @"Cerca esercenti vicini",   @"label",
                                   @"",                      @"detailLabel",
                                   @"",                      @"img",
                                   [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                                   nil] autorelease] atIndex: 0];
        sectionData = [[NSMutableArray alloc] initWithObjects:secFind, nil];
    }
    [secExpired release];
    [secFind release];
}


- (void)viewDidUnload {
    self.viewForImage = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {    
    [_viewForImage release];
    [sectionDescription release];
    [sectionData release];
    
    self.card = nil;
    
    [super dealloc];
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


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return sectionDescription.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {  
    return [sectionDescription objectAtIndex:section];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section{   
    if(sectionData){
        return [[sectionData objectAtIndex: section] count];
    } 
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *sec = [sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    NSString *kind = [rowDesc objectForKey:@"kind"];
    int cellStyle = UITableViewCellStyleDefault;
    
    //NSLog(@"dataKey = %@, kind = %@",dataKey,kind);
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier: dataKey];
    
    //se non è recuperata creo una nuova cella
	if (cell == nil) {        
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
        
        //NSLog(@"CELL = %@",cell);
    }
    
    cell.textLabel.text = [rowDesc objectForKey:@"label"];
    
    [cell setBackgroundColor:[UIColor whiteColor]];
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0;
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
    lbl.text = [sectionDescription objectAtIndex:section];

    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    // "Navigo" il model fino alla cella selezionata
    NSArray *sec = [sectionData objectAtIndex:indexPath.section];
    NSDictionary *row = [sec objectAtIndex:indexPath.row];
    NSString *dataKey = [row objectForKey:@"DataKey"];
    
    // Click su una carta
    if ([dataKey isEqualToString:@"buyOnline"]){
        NSLog(@"compra online");
    }
    else if([dataKey isEqualToString:@"request"]){
        RichiediCardViewController *richiediController = [[RichiediCardViewController alloc] initWithNibName:@"RichiediCardViewController" bundle:nil];
        
        [self.navigationController pushViewController:richiediController animated:YES];
        [richiediController release];
    }
    else if([dataKey isEqualToString:@"find"]){
        NSLog(@"cerca esercenti");
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
