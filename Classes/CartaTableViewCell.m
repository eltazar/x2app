//
//  CartaTableViewCell.m
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CartaTableViewCell.h"

@implementation CartaTableViewCell
@synthesize nome, tessera, data;

+ (CartaTableViewCell *)cellFromNibNamed:(NSString *)nibName andDictionary:(NSDictionary *)dictionary;{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:NULL];
    NSEnumerator *nibEnumerator = [nibContents objectEnumerator];
    CartaTableViewCell *customCell = nil;
    NSObject* nibItem = nil;
    while ((nibItem = [nibEnumerator nextObject]) != nil) {
        if ([nibItem isKindOfClass:[CartaTableViewCell class]]) {
            customCell = (CartaTableViewCell *)nibItem;
            break; // we have a winner
        }
    }
    
//    customCell.nome = [dictionary objectForKey:@"nome"];
//    customCell.tessera = [dictionary objectForKey:@"tessera"];
//    customCell.data = [dictionary objectForKey:@"data"];    
//    [customCell setSelectionStyle:UITableViewCellSelectionStyleBlue]; 
    
    return customCell;
}

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withDictionary:(NSDictionary *)dictionary
{
    
    NSLog(@"DENTRO CELLA");
    
    UITableViewCellStyle s = [[dictionary objectForKey:@"style"] integerValue];
    
    if (self = [super initWithStyle:s reuseIdentifier:reuseIdentifier]) {
		// Custom initialization    
        self.dataKey = [dictionary objectForKey:@"DataKey"];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.textLabel setAdjustsFontSizeToFitWidth:YES];
        self.textLabel.minimumFontSize = 11;
        
        nome = [[UILabel alloc] init];
        nome.text = [dictionary objectForKey:@"nome"];
        nome.textAlignment = UITextAlignmentLeft;
        nome.font = [UIFont  boldSystemFontOfSize:18];
        nome.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorPattern.png"]];

        tessera = [[UILabel alloc] init];
        tessera.text = [dictionary objectForKey:@"tessera"];
        tessera.textAlignment = UITextAlignmentLeft;
        tessera.font = [UIFont systemFontOfSize:13];
        
        data = [[UILabel alloc] init];
        data.text = [dictionary objectForKey:@"data"];
        data.textAlignment = UITextAlignmentRight;
        data.font = [UIFont systemFontOfSize:13.0];
        
        [self.contentView addSubview:data];
        [self.contentView addSubview:nome];
        [self.contentView addSubview:tessera];
        
        [data release];
        [nome release];
        [tessera release];
        
        //    customCell.nome = [dictionary objectForKey:@"nome"];
        //    customCell.tessera = [dictionary objectForKey:@"tessera"];
        //    customCell.data = [dictionary objectForKey:@"data"];    
        //    [customCell setSelectionStyle:UITableViewCellSelectionStyleBlue]; 
    }
    return self;
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect contentRect = self.contentView.bounds;
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;
 
    frame= CGRectMake(boundsX+10,0, 200,25);
    nome.frame = frame;
    
    frame= CGRectMake(boundsX+10 ,25, 200, 15);
    tessera.frame = frame;
    
    frame = CGRectMake(boundsX+180, 25, 100, 15);
    data.frame = frame;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
