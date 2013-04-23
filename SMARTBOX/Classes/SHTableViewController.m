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

#import "SHTableViewController.h"

@interface SHTableViewController ()

@end

@implementation SHTableViewController

-(void)pop {
    if (self.child) {
        [self.child pop];
        self.child = nil;
    }
    
    [self.multiTableController popViewController];
}

-(void)pull {
    // Children can override this to pull new data
    // aka pull from server
}


- (void)removeObjectWithName:(NSString*) name {
    // Children can override
}

@end
