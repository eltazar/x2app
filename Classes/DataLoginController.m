//
//  DataLoginController.m
//  PerDueCItyCard
//
//  Created by mario greco on 22/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataLoginController.h"
#import "BaseCell.h"

@implementation DataLoginController
@synthesize delegate;
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:139.0/255 green:29.0/255 blue:0.0 alpha:1]];

    prefs = [NSUserDefaults standardUserDefaults];
    self.title = @"Dati login";
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    sectionDescripition = [[NSArray alloc] initWithObjects:@"",@"", nil];
    
    NSMutableArray *secC = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *secD = [[NSMutableArray alloc] init];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"name",            @"DataKey",
                         @"InfoCell",    @"kind",
                         @"Nome",         @"label",
                         //@"Scegli...",             @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",
                         nil] autorelease ]  atIndex: 0];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"surname",            @"DataKey",
                         @"InfoCell",    @"kind",
                         @"Cognome",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",                         nil] autorelease ]  atIndex: 1];
    
    [secC insertObject:[[[NSDictionary alloc] initWithObjectsAndKeys:
                         @"email",            @"DataKey",
                         @"InfoCell",    @"kind",
                         @"E-mail",         @"label",
                         //numeroCarta,                 @"detailLabel",
                         @"",                 @"img",
                         [NSString stringWithFormat:@"%d", UITableViewCellStyleValue1], @"style",                         nil] autorelease ]  atIndex: 2];
    
    sectionData = [[NSArray alloc] initWithObjects:secC,secD,nil];
    
    [secC release];
    [secD release];
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

#pragma mark - Gestione bottoni view

-(IBAction)logoutBtnClicked:(id)sender{
        
    [prefs removeObjectForKey:@"_nomeUtente"];
    [prefs removeObjectForKey:@"_idUtente"];
    [prefs removeObjectForKey:@"_cognome"];
    [prefs removeObjectForKey:@"_email"];
    [prefs synchronize];
    
    if(delegate && [delegate respondsToSelector:@selector(didLogout)])
        [delegate didLogout];
    
    //[self.navigationController popViewControllerAnimated:YES];
    if(delegate && [delegate respondsToSelector:@selector(didLogout)])
        [self.delegate didLogout];
}

-(void)cancel{
    
    if(delegate && [delegate respondsToSelector:@selector(didAbortLogout)])
        [self.delegate didAbortLogout];
    
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    return [sectionDescripition objectAtIndex:section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return sectionDescripition.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
    
    switch (indexPath.row) {
        case 0:
            cell.detailTextLabel.text = [prefs objectForKey:@"_nomeUtente"];
            break;
        case 1:
            cell.detailTextLabel.text = [prefs objectForKey:@"_cognome"];
            break;
        case 2:
            cell.detailTextLabel.text = [prefs objectForKey:@"_email"];
        default:
            break;
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
- (CGFloat)tableView:(UITableView *)tableView   heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 1){
        // create the parent view that will hold 1 or more buttons
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(21.0, 10.0, 280.0, 37)];
        
        // create the button object
        UIButton* b = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [b setBackgroundImage:[UIImage imageNamed:@"buttonGrayPattern.png"] forState:UIControlStateNormal];
        
        //[b setBackgroundColor:[UIColor grayColor]];
        
        b.frame = CGRectMake(21.0, 0.0, 280.0, 37);
        b.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [b setTitle:@"Logout" forState:UIControlStateNormal];
        [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        // give it a tag in case you need it later
        //b.tag = 1;
        
        // this sets up the callback for when the user hits the button
        [b addTarget:self action:@selector(logoutBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        // add the button to the parent view
        [v addSubview:b];
        
        return [v autorelease];
    }
    
    return nil;
}

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

#pragma mark - MemoryManagement

- (void)dealloc {
    [sectionData release];
    [sectionDescripition release];
    [super dealloc];
}

@end
