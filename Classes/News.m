//
//  News.m
//  Per Due
//
//  Created by Gabriele "Whisky" Visconti on 06/04/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "News.h"
#import "Notizia.h"
#import "Utilita.h"


@implementation News


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!nibNameOrNil) {
        nibNameOrNil = [NSString stringWithFormat:@"%@", [self superclass]];
    }
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
            //
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [urlFormatString release];
    urlFormatString = @"http://www.cartaperdue.it/partner/news.php?from=%d&to=10";
    
    // Un po' di magheggi per far sparire la label che nella classe dei commenti
    // contiene l'insegna esercente: a noi qui non serve.
    UILabel *titoloLbl = (UILabel *)[self.view viewWithTag:1];
    NSInteger h = titoloLbl.frame.size.height;
    CGRect frame = titoloLbl.frame;
    frame.size = CGSizeMake(frame.size.width, 0);
    titoloLbl.frame = frame;
    frame = self.tableview.frame;
    frame.origin = CGPointMake(frame.origin.x, frame.origin.y - h);
    frame.size = CGSizeMake(frame.size.width, frame.size.height+h);
    self.tableview.frame = frame;
}


#pragma mark - UITableViewDataSource


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

	UITableViewCell *cell = nil;
    
	if (indexPath.section == 1) {		
		return [super tableView:tableView cellForRowAtIndexPath:indexPath];
	}
    
	else if (self.dataModel.count > 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"CommentiCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentiCell" owner:self options:NULL] objectAtIndex:0];
        }
        
        NSDictionary *notizia = [self.dataModel objectAtIndex: indexPath.row];
        UILabel *titolo = (UILabel *)[cell viewWithTag:1];
        UILabel *data   = (UILabel *)[cell viewWithTag:2];
        
        titolo.text = [notizia objectForKey:@"post_title"];
        data.text   = [Utilita dateStringFromMySQLDate:[notizia objectForKey:@"post_date"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}


#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {	
	
    if (indexPath.section == 1) {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    else if (indexPath.section == 0) {
        NSDictionary *notizia = [self.dataModel objectAtIndex:indexPath.row];
        NSInteger idNotizia = [[notizia objectForKey:@"ID"] integerValue];
        NSLog(@"L'id della notizia da visualizzare è %d", idNotizia);
        Notizia *detail = [[Notizia alloc] initWithNibName:nil bundle:nil];
        detail.title = @"News";
        detail.idNotizia = idNotizia;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }    
}


- (void)prettifyNullValuesForCommentsInArray:(NSArray *)comments {
    NSArray *keys = [[NSArray alloc] initWithObjects:@"post_title", @"post_date", @"ID", nil];
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