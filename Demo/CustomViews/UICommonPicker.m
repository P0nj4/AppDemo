//
//  UICommonPicker.m
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#define kSelfTag 984563215

#import "UICommonPicker.h"

@interface UICommonPicker () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, weak) IBOutlet UIView *background;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
- (IBAction)btnDonePressed:(id)sender;
@property (nonatomic, weak) NSMutableArray *arrayOfElements;
@property (nonatomic, strong) NSString *name;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation UICommonPicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        self.view.frame = frame;
    }
    return self;
}

- (void)setup{
    [[NSBundle mainBundle] loadNibNamed:@"UICommonPicker" owner:self options:nil];
    [self addSubview:self.view];
    self.tag = kSelfTag;
}


#pragma mark - UIPickerViewDelegate & UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.arrayOfElements.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    id element = [self.arrayOfElements objectAtIndex:row];
    if ([element isKindOfClass:[NSString class]]) {
        return element;
    }else{
        return ((NSObject *)element).description;
    }
    return @"";
}


#pragma mark - IBActions

- (IBAction)btnDonePressed:(id)sender {
    NSUInteger selectedRow = [self.pickerView selectedRowInComponent:0];
    if (![[self delegate] respondsToSelector:@selector(commonPickerSelectionIndexIs:forName:)]) {
        return;
    }
    [[self delegate] commonPickerSelectionIndexIs:selectedRow forName:self.name];
}


#pragma mark - Static Methods

+ (void)showPickerOnView:(UIView *)parent withElements:(NSMutableArray *)elements delegate:(id<UICommonViewDelegate>)delegate name:(NSString *)name preselectedIndex:(NSInteger)index{
    UICommonPicker *Aux =[[UICommonPicker alloc] initWithFrame:parent.bounds];
    Aux.name = name;
    Aux.arrayOfElements = elements;
    Aux.alpha = 0;
    [parent addSubview:Aux];
    
    [UIView animateWithDuration:0.3 animations:^{
        Aux.alpha = 1;
    }];
    Aux.delegate = delegate;
    
    Aux.pickerView.dataSource = Aux;
    Aux.pickerView.delegate = Aux;
    [Aux.pickerView selectRow:index inComponent:0 animated:NO];
}

+ (void)hidePickerOnView:(UIView *)parent{
    UICommonPicker *aux = (UICommonPicker *)[parent viewWithTag:kSelfTag];
    [UIView animateWithDuration:0.3 animations:^{
        aux.alpha = 0;
    }completion:^(BOOL finished) {
        [aux removeFromSuperview];
    }];
}

@end
