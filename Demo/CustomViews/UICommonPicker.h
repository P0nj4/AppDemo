//
//  UICommonPicker.h
//  Demo
//
//  Created by German Pereyra on 12/12/14.
//  Copyright (c) 2014 German Pereyra. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UICommonViewDelegate <NSObject>
- (void)commonPickerSelectionIndexIs:(NSInteger)index forName:(NSString *)name;
@end

@interface UICommonPicker : UIView
@property (strong, nonatomic) IBOutlet UIView *view;
@property (nonatomic, weak) id<UICommonViewDelegate> delegate;
@end
