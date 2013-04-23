/*
 *  Smart BOX - Intelligent Management for your Smart Files.
 *  Copyright (C) 2013  Team Winnovation (Eric Lovelace and Levi Miller)
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import <UIKit/UIKit.h>

@class SHTableViewController;
@class SHFloatingViewController;
@class SmartFileEngine;

@interface SHMultiTableViewController : UIViewController 

- (id)initWithBaseController:(SHTableViewController *) base;
- (void)pushViewController:(UIViewController *)controller asChildOf:(SHTableViewController *)parent animated:(BOOL)animated;
- (void)popViewController;
- (void)reloadAllTableViews;

- (void)addFloatingView:(SHFloatingViewController *) floatingViewController withSender:(SHTableViewController *) parent;
- (void)bringToFrontFloatingView:(SHFloatingViewController *) floatingViewController;
- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController;
- (void)removeFloatingView:(SHFloatingViewController *) floatingViewController refresh:(BOOL)flag;

- (void)selectFolderForFloatingView:(SHFloatingViewController*) fv;
- (void)hideAllFloatingViews;
- (void)showAllFloatingViews;

- (void)folderSelected:(NSString*)folder;

@property (nonatomic) BOOL foldersOnly;
@property (nonatomic, strong) UIImageView* bgImageView;
@property (nonatomic, strong, readonly) SmartFileEngine* engine;

@end