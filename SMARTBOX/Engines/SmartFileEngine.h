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


#import "MKNetworkKit.h"

typedef void (^lsResponseBlock)(NSArray* list);
typedef void (^dlResponseBlock)(NSData* file);
typedef void (^mdResponseBlock)(NSDictionary* meta);
typedef void (^rmResponseBlock)(NSDictionary* task);
typedef void (^taskResponseBlock)(NSString* task);
typedef void (^userResponseBlock)(NSString* user);

@interface SmartFileEngine : MKNetworkEngine

- (id)initWithDefaultSettings;

- (MKNetworkOperation*) listFilesFor:(NSString*) directory
                        onCompletion:(lsResponseBlock) completionBlock
                             onError:(MKNKResponseErrorBlock) errorBlock;

- (MKNetworkOperation*) downloadFile:(NSString*) file
                    onProgressChange:(MKNKProgressBlock) progressBlock
                        onCompletion:(dlResponseBlock) completionBlock
                             onError:(MKNKResponseErrorBlock) errorBlock;

- (MKNetworkOperation*) mkdir:(NSString*) directory
                 onCompletion:(mdResponseBlock) completionBlock
                      onError:(MKNKResponseErrorBlock) errorBlock;

- (MKNetworkOperation*) rmdir:(NSString*) directory
                 onCompletion:(rmResponseBlock) completionBlock
                      onError:(MKNKResponseErrorBlock) errorBlock;

- (MKNetworkOperation*) rm:(NSString*) file
              onCompletion:(rmResponseBlock) completionBlock
                   onError:(MKNKResponseErrorBlock) errorBlock;

- (MKNetworkOperation*) upload:(NSString*) file
                            to:(NSString*) directory
                  onCompletion:(taskResponseBlock) completionBlock
                       onError:(MKNKResponseErrorBlock) errorBlock;

- (MKNetworkOperation*) getCurrentUserOnCompletion:(userResponseBlock) completionBlock
                                           onError:(MKNKResponseErrorBlock) errorBlock;

@end
