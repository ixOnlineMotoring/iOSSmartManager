//
//  SMToolBarCustomField.h
//  SmartManager
//
//  Created by Priya on 30/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SMToolBarCustomFieldDelegate <NSObject>

-(void)doneButtOnDIdPressed;

@end
@interface SMToolBarCustomField : UITextField
@property (strong, nonatomic) id <SMToolBarCustomFieldDelegate>toolbarDelegate;

@end
