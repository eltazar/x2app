//
//  CartaTableViewCell.h
//  PerDueCItyCard
//
//  Created by mario greco on 27/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@interface CartaTableViewCell : BaseCell{
    UILabel *nome;
    UILabel *tessera;
    UILabel *data;
}

@property(nonatomic,retain) UILabel *nome;
@property(nonatomic,retain) UILabel *tessera;
@property(nonatomic,retain) UILabel *data;
+(CartaTableViewCell *)cellFromNibNamed:(NSString *)nibName andDictionary:(NSDictionary *)dictionary;;

@end
