//
//  AcquistoOnlineController.m
//  PerDueCItyCard
//
//  Created by mario greco on 08/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AcquistoOnlineController.h"
#import "BaseCell.h"
#import "Utilita.h"
#import "IAPHelper.h"

@implementation AcquistoOnlineController
@synthesize hud = _hud;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Gestioni caricamenti 

- (void)timeout:(id)arg {
    
    _hud.labelText = @"Tempo scaduto!";
    _hud.detailsLabelText = @"Spiacenti, riprovare più tardi!";
    _hud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
	_hud.mode = MBProgressHUDModeCustomView;
    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}

- (void)dismissHUD:(id)arg {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.hud = nil;
    
}

- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    self.tableView.hidden = FALSE;    
    
    [self.tableView reloadData];
    
}

#pragma mark - DatabaseACcessDelegate

-(void)didReceiveCoupon:(NSDictionary *)coupon{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    
    //NSLog(@"RICEVUTA LISTA ID PRODOUCT = %@, tipo = %@",coupon, [[coupon objectForKey:@"CatalogoIAP"] class]);
    //NSLog(@"oggetto 1 = %@", [[[coupon objectForKey:@"CatalogoIAP"] objectAtIndex:0] class]);
    
    if(coupon){
        for(NSDictionary *tempDict in [coupon objectForKey:@"CatalogoIAP"]){
            
            [((NSMutableSet*)productsId) addObject: [tempDict objectForKey:@"product_id"]];
        }
    }
    
    NSLog(@"SET = %@",productsId);
    
    //recuperati gli id creo istanza del managare in app purchase
    iapHelper = [[IAPHelper alloc] initWithProductIdentifiers:productsId];
    
    [iapHelper requestProducts];
    [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
    
}

-(void)didReceiveError:(NSError *)error{
    NSLog(@"ACQUISTO ONLINE ERRORE SERVER = %@", [error description]);
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    
    dbAccess = [[DatabaseAccess alloc] init];
    dbAccess.delegate = self;
    
    productsId = [[NSMutableSet alloc] init];

    //query al db per ottenere lista di oggetti da vendere
    
    sectionDescription = [[NSMutableArray alloc] initWithObjects:@"Offerte", nil];
    
    NSMutableArray *secC = [[NSMutableArray alloc] initWithCapacity:5];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"name",            @"DataKey",
                         @"BuyCell",    @"kind",
                         @"Tipo 1",         @"label",
                         //@"Scegli...",             @"detailLabel",
                         @"Mario",         @"placeholder",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 0];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"surname",            @"DataKey",
                         @"BuyCell",    @"kind",
                         @"Tipo 2",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 1];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"phone",            @"DataKey",
                         @"BuyCell",    @"kind",
                         @"Tipo 3",           @"label",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease] atIndex: 2];
    
    
    sectionData = [[NSMutableArray alloc] initWithObjects: secC, nil];
    
    [secC release];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    self.hud = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    
    [_hud release];
    _hud = nil;
    
    [productsId release];
    dbAccess.delegate = nil;
    [dbAccess release];
    [sectionData release];
    [sectionDescription release];
    
    [super dealloc];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([Utilita networkReachable]){
        [dbAccess getCatalogIAP];
        self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        _hud.labelText = @"Loading comics...";  
    }
    else{
        NSLog(@"ACQUISTO ONLINE VIEW: INTERNET NON DISPONIBILE");
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated]; 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sectionDescription.count;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{   
    if(sectionData){
        return [[sectionData objectAtIndex: section] count];
    } 
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sec = [sectionData objectAtIndex:indexPath.section];
    NSDictionary *rowDesc = [sec objectAtIndex:indexPath.row]; 
    NSString *kind = [rowDesc objectForKey:@"kind"];
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    
    int cellStyle = UITableViewCellStyleDefault;
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier:dataKey];
    
    if (cell == nil) {       
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
    }
    
    //[self fillCell:cell rowDesc:rowDesc];
        
    return cell;    

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
