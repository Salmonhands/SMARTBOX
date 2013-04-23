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
#import "SHMultiTableViewController.h"

@interface SHTableViewController : UITableViewController

@property (nonatomic, weak) SHMultiTableViewController* multiTableController;
@property (nonatomic, weak) SHTableViewController* child;
@property (nonatomic) uint depth;

- (void)pop;
- (void)pull;
- (void)removeObjectWithName:(NSString*) name;

@end
