//
//  SharedImageTableViewCell.h
//  LifeDiary
//
//  Created by Lilit Grigoryan on 11/5/16.
//  Copyright © 2016 GevorGNanyaN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sharedImageView;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;

@end
