//
//  CategoriaCommercialeWithPrice.h
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 24/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CategoriaCommerciale.h"

@interface CategoriaCommercialeWithPrice : CategoriaCommerciale{
    
    @private
    UISegmentedControl *segCtrlFilter;
}

@property (nonatomic, retain) UIImageView *filterImg;
@property (nonatomic, retain) PullableView *filterPanel;

@end
