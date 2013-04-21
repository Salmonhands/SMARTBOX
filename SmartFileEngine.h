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
