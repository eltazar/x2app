//
//  CouponDiscountTimeCell.m
//  PerDueCItyCard
//
//  Created by Gabriele "Whisky" Visconti on 08/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponDiscountTimeCell.h"
#import "FotoIngranditaController.h"

@implementation CouponDiscountTimeCell


@synthesize asyncImageView=_asyncImageView, prezzoCouponLbl=_prezzoCouponLbl, scontoLbl=_scontoLbl, risparmioLbl=_risparmioLbl, prezzoOrigLbl=_prezzoOrigLbl, tempoLbl=_tempoLbl, caricamentoImmagineSpinner=_caricamentoImmagineSpinner, viewController=_viewController;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc {
    [_imgUrlString release];
    self.asyncImageView.delegate = self;
    self.asyncImageView = nil;
    self.prezzoCouponLbl = nil;
    self.scontoLbl = nil;
    self.risparmioLbl = nil;
    self.prezzoOrigLbl = nil;
    self.tempoLbl = nil;
    self.caricamentoImmagineSpinner = nil;
    self.viewController = nil;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (void) awakeFromNib {
    NSLog(@"%@::awakeFromNib", [self class]);
    [self.caricamentoImmagineSpinner startAnimating];
    self.asyncImageView.delegate = self;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];  
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];  
    [doubleTap setNumberOfTapsRequired:2];  
    [self.asyncImageView addGestureRecognizer:singleTap];  
    [self.asyncImageView addGestureRecognizer:doubleTap];
    [singleTap release];
    [doubleTap release];
}


#pragma mark - AsyncImageViewDelegate


- (void)didLoadImageInAysncImageView:(AsyncImageView *)asyncImageView {
    NSLog(@"%@::didLoadImageInAsyncImageView", [self class]);
    [self.caricamentoImmagineSpinner stopAnimating];
    self.caricamentoImmagineSpinner.hidden = YES;
}


#pragma mark - CouponDiscountTimeCell


- (void)loadImageFromUrlString:(NSString *)urlString {
    NSLog(@"%@::loadImageFromUrlString", [self class]);
    _imgUrlString = [urlString retain];
    NSURL *url = [NSURL URLWithString:urlString];
    [self.asyncImageView loadImageFromURL:url];
}


#pragma mark - Tap handling


- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"%@::handleSingleTap", [self class]);
    // TODO: è inutile riscaricare l'immagine, aggiungere a fotoIngranditaController un metodo per inizializzarla con l'immagine già caricata.
    if (self.viewController) {
        FotoIngranditaController *controller = [[FotoIngranditaController alloc] initWithNibName:nil bundle:nil imageUrlString:_imgUrlString];
        NSLog(@"%@::handleSingleTap controller = [%@]", [self class], controller);
        [self.viewController presentModalViewController:controller animated:YES];
        [controller release];
    }
}


- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {  
	[self handleSingleTap:gestureRecognizer];
}


@end
