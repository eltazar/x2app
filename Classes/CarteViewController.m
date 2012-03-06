//
//  CarteViewController.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CarteViewController.h"
#import "BaseCell.h"
#import "CartaTableViewCell.h"
#import "PerDueCItyCardAppDelegate.h"
#import "LocalDBAccess.h"
#import "AbbinaCartaViewController.h"
#import "PerDueCItyCardAppDelegate.h"

@implementation CarteViewController
@synthesize cards;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return sectionDescripition.count;
}

//setta gli header delle sezioni
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{  
    return [sectionDescripition objectAtIndex:section];
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
    NSString *dataKey = [rowDesc objectForKey:@"DataKey"];
    NSString *kind = [rowDesc objectForKey:@"kind"];
    int cellStyle = UITableViewCellStyleDefault;
    
    NSLog(@"dataKey = %@, kind = %@",dataKey,kind);
    
    BaseCell *cell = (BaseCell *)[tableView dequeueReusableCellWithIdentifier: dataKey];
    
    //se non è recuperata creo una nuova cella
	if (cell == nil) {
//        if([kind isEqualToString:@"CartaTableViewCell"]){
//            
//            cell = (CartaTableViewCell *)[CartaTableViewCell cellFromNibNamed:@"CartaTableViewCell" andDictionary:rowDesc];            
//        }
//        else {
//            cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
//        }
        
        cell = [[[NSClassFromString(kind) alloc] initWithStyle: cellStyle reuseIdentifier:kind withDictionary:rowDesc] autorelease];
        
        NSLog(@"CELL = %@",cell);
    }
    
    if([kind isEqualToString:@"CartaTableViewCell"]){
        NSLog(@"carta per due");
        
       
        
        ((CartaTableViewCell*)cell).nome.text =  [rowDesc objectForKey:@"nome"];
        ((CartaTableViewCell*)cell).tessera.text =  [rowDesc objectForKey:@"tessera"];
        ((CartaTableViewCell*)cell).data.text =  [rowDesc objectForKey:@"data"];
    }
    
    
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 30.0;
}

//setta il colore delle label dell'header BIANCHE
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *customView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 44.0)] autorelease];
    [customView setBackgroundColor:[UIColor clearColor]];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    
    lbl.backgroundColor = [UIColor clearColor];
    lbl.textColor = [UIColor whiteColor];
    lbl.lineBreakMode = UILineBreakModeWordWrap;
    lbl.numberOfLines = 0;
    lbl.font = [UIFont boldSystemFontOfSize:20];
    
	
    
    lbl.text = [sectionDescripition objectAtIndex:section];
    
    //	if (section == 0)
    //	{
    //		lbl.text = [sectionDescripition objectAtIndex:section];
    //	}
    //	if (section == 1){
    //        
    //        //queste due qui sotto settarle dopo...
    //		lbl.text = @"Operazioni";
    //		
    //	}
    //	
    //	if (section == 2){
    //		lbl.text = @"Contatti";	
    //        
    //    }
    
    
    UIFont *txtFont = [UIFont boldSystemFontOfSize:18];
    CGSize constraintSize = CGSizeMake(280, MAXFLOAT);
    CGSize labelSize = [lbl.text sizeWithFont:txtFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    
    lbl.frame = CGRectMake(10, 0, tableView.bounds.size.width-20, labelSize.height+6);
    
    [customView addSubview:lbl];
    
    return customView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    BaseCell *cell = (BaseCell*) [tableView cellForRowAtIndexPath:indexPath];
    
    if ([cell.dataKey isEqualToString:@"abbina"]) {
        
        AbbinaCartaViewController *abbinaCartaViewController = [[AbbinaCartaViewController alloc] init];
        [self.navigationController pushViewController:abbinaCartaViewController animated:YES];
    }
    else if([cell.dataKey isEqualToString:@"acquista"])
    {
        
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Gestione carte"];
    
    
//    PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate*) [[UIApplication sharedApplication] delegate];
//    
//    LocalDBAccess *locDbAccess = [appDelegate localDbAccess];   
    
//    NSString *DownloadsPlistPath =[[NSBundle mainBundle] pathForResource:@"userCards" ofType:@"plist"];
//    NSLog(@"\n############\n path = %@ \n#############\n",DownloadsPlistPath);
//    

    
        //per lettura e scrittura di un plist sull'hd, funziona
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    
//    NSString *filePath = [basePath stringByAppendingPathComponent:@"Enterprise/userCards.plist"];
//    
//    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
//        cards =[[NSMutableArray alloc] initWithContentsOfFile:filePath];
//        NSLog(@"CARDS = %@",cards);
//    }
//    else{
//        printf("Errore NEL CARICARE IL FILE");
//    }
    
//    sectionDescripition = [[NSMutableArray alloc]init];
//    
//    if(cards.count > 0){
//        [sectionDescripition insertObject:@"Carte" atIndex:0];
//        [sectionDescripition insertObject:@"Operazioni" atIndex:1];
//    }
//    else{
//        [sectionDescripition insertObject:@"Operazioni" atIndex:0];
//    }
    
    
    sectionDescripition = [[NSMutableArray alloc] init];
    NSMutableArray *secA = [[NSMutableArray alloc] init];
    
    
    //Otteniamo il puntatore al NSManagedContext
    PerDueCItyCardAppDelegate *appDelegate = (PerDueCItyCardAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
	//istanziamo la classe NSFetchRequest di cui abbiamo parlato in precedenza
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
	//istanziamo l'Entità da passare alla Fetch Request
	NSEntityDescription *entity = [NSEntityDescription 
								   entityForName:@"CartaPerDue" inManagedObjectContext:context];
	//Settiamo la proprietà Entity della Fetch Request
	[fetchRequest setEntity:entity];
    
	//Eseguiamo la Fetch Request e salviamo il risultato in un array, per visualizzarlo nella tabella
	NSError *error;
	NSArray *fo = [context executeFetchRequest:fetchRequest error:&error];
	//contattiList = [fo retain];
    
    NSLog(@ " --------> FO = %@ \n, fo count = %d, \n titolare = %@, carta = %@, scadenza = %@",fo,fo.count, [[fo objectAtIndex:0] valueForKey:@"titolare"], [[fo objectAtIndex:1] valueForKey:@"numero"], [[fo objectAtIndex:1] valueForKey:@"scadenza"]);
    
    if(fo && fo.count > 0){
        
        
        [sectionDescripition insertObject:@"Carte" atIndex:0];
        [sectionDescripition insertObject:@"ciao" atIndex:1];
        
        for(int i = 0; i < fo.count ; i++){
            
            NSManagedObject *carta = [fo objectAtIndex:i];
            [secA insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                 @"card",              @"DataKey",
                                 @"CartaTableViewCell",@"kind",
                                 [carta valueForKey:@"titolare"],  @"nome",
                                 [carta valueForKey:@"numero"],@"tessera",
                                 [carta valueForKey:@"scadenza"],   @"data",
                                 [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",nil] autorelease] atIndex: i];
            
            
        }
    }
    else{
        [sectionDescripition insertObject:@"ciao" atIndex:0];
    }
    
    
	[fetchRequest release];
    
    
    
    
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    
//    if([prefs objectForKey:@"_titolare_AB"] && [prefs objectForKey:@"_carta_AB"] &&
//       [prefs objectForKey:@"_scadenza_AB"]){
//        
//        [sectionDescripition insertObject:@"Carta abbinata" atIndex:0];
//        [sectionDescripition insertObject:@"" atIndex:1];        
//        
//        [secA insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                             @"card",              @"DataKey",
//                             @"CartaTableViewCell",@"kind",
//                             [prefs objectForKey:@"_titolare_AB"],  @"nome",
//                             [prefs objectForKey:@"_carta_AB"],@"tessera",
//                             [prefs objectForKey:@"_scadenza_AB"],   @"data",
//                             [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
//                             nil] autorelease] atIndex: 0];
//
//        
//    }
//    else{
//        [sectionDescripition insertObject:@"TEMP" atIndex:0];
//    }
    
   
 //per lettura file plist    
//    for(int i = 0; i < cards.count; i++){
//        
//        
//        [secA insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
//                             @"card",              @"DataKey",
//                             @"CartaTableViewCell",@"kind",
//                             [[cards objectAtIndex:i] objectForKey:@"nome"],  @"nome",
//                             [[cards objectAtIndex:i] objectForKey:@"tessera"],@"tessera",
//                             [[cards objectAtIndex:i] objectForKey:@"data"],   @"data",
//                             [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
//                             nil] autorelease] atIndex: i];
//        
//    }
    
    ////////////////////
    
    NSMutableArray *secB = [[NSMutableArray alloc] init];
    
    [secB insertObject:[[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"abbina",              @"DataKey",
                         @"ActionCell",               @"kind",
                         @"Abbina carta"      , @"label",
                         @"",                   @"detailLabel",
                         @"",               @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] autorelease] atIndex: 0];
    
    [secB insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"acquista",           @"DataKey",
                         @"ActionCell",       @"kind",
                         @"Acquista carta",   @"label",
                         @"",       @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleDefault], @"style",
                         nil] autorelease] atIndex: 1];
    
    
    if(secA && secA.count > 0){
        sectionData = [[NSMutableArray alloc] initWithObjects: secA, secB, nil];
    }
    else{
        sectionData = [[NSMutableArray alloc] initWithObjects:secB, nil];
    }
    
    [secA release];
    [secB release];
    
    

    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



@end
