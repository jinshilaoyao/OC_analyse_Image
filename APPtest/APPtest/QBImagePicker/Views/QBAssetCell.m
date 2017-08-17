//
//  QBAssetCell.m
//  QBImagePicker
//
//  Created by Katsuma Tanaka on 2015/04/06.
//  Copyright (c) 2015 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetCell.h"

@interface QBAssetCell ()
{
    
}
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@end

@implementation QBAssetCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if(_selectImageView == nil)
    {
        _selectImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_select_image"]];
        
        CGRect selectImageViewFrame = _selectImageView.frame;
        selectImageViewFrame.origin.x = self.frame.size.width-4-[UIImage imageNamed:@"default_select_image"].size.width;
        selectImageViewFrame.origin.y = self.frame.size.height-4-[UIImage imageNamed:@"default_select_image"].size.height;
        
        _selectImageView.frame = selectImageViewFrame;
        [self addSubview:_selectImageView];
    }
    
    if(selected)
        _selectImageView.image = [UIImage imageNamed:@"select_image"];
    else
        _selectImageView.image = [UIImage imageNamed:@"default_select_image"];
    
    // Show/hide overlay view
    //self.overlayView.hidden = !(selected && self.showsOverlayViewWhenSelected);
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSUInteger numTaps = [[touches anyObject] tapCount];
    if(numTaps == 1)
    {
        for (UITouch *touch in touches)
        {
            _touchePoint = [touch locationInView:self];
        }
    }

    [super touchesEnded:touches withEvent:event];
}
@end
