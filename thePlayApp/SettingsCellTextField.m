//
//  SettingsCellTextField.m
//  thePlayApp
//
//  Created by Daniel Mathews on 2013-04-29.
//  Copyright (c) 2013 com.theplayapp. All rights reserved.
//

#import "SettingsCellTextField.h"
#import "PlayConstants.h"

@implementation SettingsCellTextField

@synthesize titleButton = _titleButton;
@synthesize subTitleButton = _subTitleButton;
@synthesize textField = _textField;
@synthesize switchButton = _switchButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleButton setFrame:CGRectMake(20.0f, 0.0f, self.frame.size.width-40.0f, self.frame.size.height)];
        [_titleButton setBackgroundColor:[UIColor clearColor]];
        [_titleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [_titleButton setUserInteractionEnabled:NO];
        [_titleButton setTitle:@"" forState:UIControlStateNormal];
        [_titleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [[_titleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:13.0f]];
        [self addSubview:_titleButton];
        
        if([reuseIdentifier isEqualToString:@"Cell0"]){
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(20.0f, 12, self.frame.size.width-40.0f, self.frame.size.height)];
            UIView *usernameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, _textField.frame.size.height)];
            _textField.leftView = usernameLeftView;
            _textField.leftViewMode = UITextFieldViewModeAlways;
            _textField.font = [UIFont fontWithName:kPlayFontName size:15.0f];
            _textField.textColor = [UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f];
            _textField.returnKeyType = UIReturnKeyDone;
            [self addSubview:_textField];
            
        }else if ([reuseIdentifier isEqualToString:@"LocationCheckInIdentifier"]){
            
            _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width-95.0f, 20, 50, self.frame.size.height)];
            [_switchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [self addSubview:_switchButton];
            
            _subTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_subTitleButton setFrame:CGRectMake(20.0f, 23.0f, self.frame.size.width-120.0f, self.frame.size.height)];
            [_subTitleButton setBackgroundColor:[UIColor clearColor]];
            [_subTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [_subTitleButton setUserInteractionEnabled:NO];
            [_subTitleButton setTitle:@"" forState:UIControlStateNormal];
            [_subTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_subTitleButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [[_subTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:10.0f]];
            [self addSubview:_subTitleButton];
            
        }else if ([reuseIdentifier isEqualToString:@"Push1Identifier"] || [reuseIdentifier isEqualToString:@"Push2Identifier"] || [reuseIdentifier isEqualToString:@"Push3Identifier"] || [reuseIdentifier isEqualToString:@"Push4Identifier"] || [reuseIdentifier isEqualToString:@"Push5Identifier"]){
            
            _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.frame.size.width-95.0f, 10.0f, 50, self.frame.size.height)];
            [_switchButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [self addSubview:_switchButton];
            
            _subTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_subTitleButton setFrame:CGRectMake(20.0f, 0.0f, self.frame.size.width-120.0f, self.frame.size.height)];
            [_subTitleButton setBackgroundColor:[UIColor clearColor]];
            [_subTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [_subTitleButton setUserInteractionEnabled:NO];
            [_subTitleButton setTitle:@"" forState:UIControlStateNormal];
            [_subTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [_subTitleButton.titleLabel setLineBreakMode:NSLineBreakByWordWrapping];
            [[_subTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:12.0f]];
            [self addSubview:_subTitleButton];
            
        }
        else{
            _subTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_subTitleButton setFrame:CGRectMake(20.0f, 0, self.frame.size.width-40.0f, self.frame.size.height)];
            [_subTitleButton setBackgroundColor:[UIColor clearColor]];
            [_subTitleButton setTitleColor:[UIColor colorWithRed:70.0f/255.0f green:70.0f/255.0f blue:70.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            [_subTitleButton setUserInteractionEnabled:NO];
            [_subTitleButton setTitle:@"" forState:UIControlStateNormal];
            [_subTitleButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
            [[_subTitleButton titleLabel] setFont:[UIFont fontWithName:kPlayFontName size:15.0f]];
            [self addSubview:_subTitleButton];
        }

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
