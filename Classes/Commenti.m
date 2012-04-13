//
//  Commenti.m
//  PerDueCItyCard
//
//  Created by Giuseppe Lisanti on 27/05/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Commenti.h"
#import "Utilita.h"

@interface Commenti (){
}
@property (nonatomic, retain) NSMutableArray *dataModel;
- (void)fetchRowsFromNumber:(NSInteger)n;
- (void)prettifyNullValuesForCommentsInArray:(NSArray *)comments;

@end


@implementation Commenti


@synthesize idEsercente=_idEsercente ,insegnaEsercente=_insegnaEsercente;

@synthesize tableview=_tableview, activityIndicator=_activityIndicator;

@synthesize dataModel=_dataModel;


/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


#pragma mark - View Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    urlFormatString = @"http://www.cartaperdue.it/partner/commenti.php?id=%d&from=%d&to=10";
    UILabel *titolo = (UILabel *)[self.view viewWithTag:1];
    titolo.text = self.insegnaEsercente;
    didFetchAllComments = FALSE;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview deselectRowAtIndexPath:[self.tableview indexPathForSelectedRow]  animated:YES];
    if (![Utilita networkReachable]) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connessione assente" message:@"Verifica le impostazioni di connessione ad Internet e riprova" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok",nil];
		[alert show];
        [alert release];
        return;
	}
    if (!self.dataModel || self.dataModel.count == 0 ) {
        [self.activityIndicator startAnimating];
        [self fetchRowsFromNumber:0];
    }
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    self.dataModel = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.tableview.dataSource = nil;
    self.tableview.delegate = nil;
    self.tableview = nil;
    self.activityIndicator = nil;
}


- (void)dealloc {
    self.dataModel = nil; //era: rows
    self.insegnaEsercente = nil;
    self.tableview.dataSource = nil;
    self.tableview.delegate = nil;
    self.tableview = nil;
    self.activityIndicator = nil;
    [super dealloc];
}


#pragma mark - UITableViewDataSource


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	//if (self.dataModel.count < 5) {
	//	return 1;
	//}	
	//else {
		return 2;
		
	//}
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return self.dataModel.count;
		case 1:
			return 1;
		default:
			return 0;
	}
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = nil;
    
	if (indexPath.section == 1) {		
		cell = [tableView dequeueReusableCellWithIdentifier:@"LastCell"];
		if (!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"LastCell" owner:self options:NULL] objectAtIndex:0];
		}
		UILabel *altri  = (UILabel *)[cell viewWithTag:1];
        UILabel *altri2 = (UILabel *)[cell viewWithTag:2];
		altri.text = @"Mostra altri...";
		altri2.text = (didFetchAllComments) ? @"Non ci sono altri commenti da mostrare" : @"";
	}
    
	else if (self.dataModel.count > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommentiCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentiCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        NSDictionary *commento = [self.dataModel objectAtIndex: indexPath.row];
        UILabel *titolo = (UILabel *)[cell viewWithTag:1];
        UILabel *data   = (UILabel *)[cell viewWithTag:2];
        
        titolo.text = [commento objectForKey:@"comment_content"];
        NSString *dateString = [Utilita dateStringFromMySQLDate:[commento objectForKey:@"comment_date"]];
        if ([[commento objectForKey:@"comment_author"] length] == 0 ) {
            data.text = [NSString stringWithFormat:@"Inviato da Anonimo %@ il %@",
                         [commento objectForKey:@"comment_author"],
                         dateString];
        }
        else {
            data.text = [NSString stringWithFormat:@"Inviato da %@ il %@", 
                         [commento objectForKey:@"comment_author"],
                         dateString];
            data.text = [data.text stringByReplacingOccurrencesOfString:@"&amp;"
                                                             withString:@"&"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	
    if (indexPath.section == 0) {
        NSDictionary *commento = [self.dataModel objectAtIndex:indexPath.row];
        NSInteger idCommento = [[commento objectForKey:@"comment_ID"] integerValue];
        NSLog(@"L'id del commento da visualizzare è %d", idCommento);
        NSString *dateStr = [Utilita dateStringFromMySQLDate:[commento objectForKey:@"comment_date"]];
        NSString *autore;
        if([[commento objectForKey:@"comment_author"] length] == 0 ) {
            autore = [NSString stringWithFormat:@"Inviato da Anonimo %@ il %@",
                      [commento objectForKey:@"comment_author"],
                      dateStr];
        }
        else {
            autore = [NSString stringWithFormat:@"Inviato da %@ il %@",
                      [commento objectForKey:@"comment_author"],
                      dateStr];
            autore = [autore stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
            
        }
        Commento *detail = [[Commento alloc] initWithNibName:nil bundle:nil];
        detail.title = @"Commento";
        detail.data = autore;
        detail.insegnaEsercente = self.insegnaEsercente;
        detail.testoCommento = [commento objectForKey:@"comment_content"];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
        
    }
    
    else if (indexPath.section == 1) {
        if (!didFetchAllComments) { // non ci sono alri commenti
            [self fetchRowsFromNumber:self.dataModel.count];
        }
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
}


#pragma mark - WMHTTPAccessDelegate


- (void)didReceiveJSON:(NSDictionary *)jsonDict {
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    NSObject *temp = [jsonDict objectForKey:@"Esercente"];
    
    if (![temp isKindOfClass:[NSArray class]]) {
        return;
    }
    
    NSMutableArray *fetchedComments;
    if ([temp isKindOfClass:[NSMutableArray class]]) {
        fetchedComments = (NSMutableArray *)temp;
    }
    else {
        fetchedComments = [NSMutableArray arrayWithArray:((NSArray *)temp)];
    }
    [self prettifyNullValuesForCommentsInArray:fetchedComments];
    
    if (fetchedComments.count == 0) {
        // Abbiamo già scaricato tutti i commenti
        didFetchAllComments = TRUE;
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:[NSIndexPath indexPathForRow:0 inSection:1], nil];
        [self.tableview beginUpdates];
        [self.tableview reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview endUpdates];
        [indexPaths release];
        return;
    }

    if (!self.dataModel || self.dataModel.count == 0) {
        self.dataModel = fetchedComments;
        [self.tableview reloadData];
        return;
    }
    
    NSInteger from  = self.dataModel.count;
    NSInteger to    = from + fetchedComments.count;
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithCapacity:(to - from)]; 
    for (int i = from; i < to; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableview beginUpdates];
    [self.dataModel addObjectsFromArray: fetchedComments];
    [self.tableview insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableview endUpdates];
    [indexPaths release];
    return;
}


-  (void)didReceiveError:(NSError *)error {
    [self.activityIndicator stopAnimating];
#warning visualizzare alert errore di rete.
}


- (void)fetchRowsFromNumber:(NSInteger)n {
    NSString *urlString = [NSString stringWithFormat:urlFormatString, self.idEsercente, n];
    NSLog(@"[%@ fetchRowsFromNumber] urlString:[%@]", [self class], urlString);
    [[WMHTTPAccess sharedInstance] startHTTPConnectionWithURLString:urlString method:WMHTTPAccessConnectionMethodGET parameters:nil delegate:self];
}


- (void)prettifyNullValuesForCommentsInArray:(NSArray *)comments{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"comment_author", @"comment_content", @"comment_date", @"comment_ID", nil];
    for (NSMutableDictionary *c in comments) {
        for (NSString *k in keys) {
            if ([[c objectForKey:k] isKindOfClass: [NSNull class]]) {
                [c setObject:@"" forKey:k];
            }
        }
    }
    [keys release];
}


@end
