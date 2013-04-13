//
//  SmartFileEngine.h
//  jsonTest
//
//  Created by macadmin on 3/14/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "MKNetworkKit.h"

typedef void (^lsResponseBlock)(NSArray* list);
typedef void (^dlResponseBlock)(NSData* file);
typedef void (^mdResponseBlock)(NSDictionary* meta);
typedef void (^rmResponseBlock)(NSDictionary* task);

@interface SmartFileEngine : MKNetworkEngine

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

@end
