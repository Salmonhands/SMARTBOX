//
//  SmartFileEngine.m
//  jsonTest
//
//  Created by macadmin on 3/14/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SmartFileEngine.h"
#import "NSString+Encode.h"

@implementation SmartFileEngine

-(MKNetworkOperation *)listFilesFor:(NSString *)directory
                       onCompletion:(lsResponseBlock)completionBlock
                            onError:(MKNKResponseErrorBlock)errorBlock
{
    
    NSString* path = [NSString stringWithFormat:@"path/info%@", directory];
    path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSDictionary* params = [NSDictionary dictionaryWithObject:@"on" forKey:@"children"];
    MKNetworkOperation* op = [self operationWithPath:path
                                            params:params
                                        httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
             NSMutableDictionary* json = (NSMutableDictionary*) jsonObject;
             NSArray* children = [json objectForKey:@"children"];
             NSMutableArray* simpleChildren = [NSMutableArray array];
             for (NSDictionary* child in children) {
                 NSDictionary* simpleChild = [NSDictionary dictionaryWithObjects:@[[child valueForKey:@"mime"], [child valueForKey:@"name"]]
                                                                         forKeys:@[@"mime", @"name"]];
                 [simpleChildren addObject:simpleChild];
             }
             
             completionBlock(simpleChildren);
         }];
         
     }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error) {
         errorBlock(erroredOperation, error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}

- (MKNetworkOperation*) downloadFile:(NSString*) file
                    onProgressChange:(MKNKProgressBlock) progressBlock
                        onCompletion:(dlResponseBlock) completionBlock
                             onError:(MKNKResponseErrorBlock) errorBlock
{
    
    NSString* path = [NSString stringWithFormat:@"path/data%@", file];
    path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    MKNetworkOperation* op = [self operationWithPath:path
                                              params:nil
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation* completedOperation) {
        completionBlock([completedOperation responseData]);
    }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error){
        errorBlock(erroredOperation, error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}


- (MKNetworkOperation*) mkdir:(NSString*) directory
                 onCompletion:(mdResponseBlock) completionBlock
                      onError:(MKNKResponseErrorBlock) errorBlock
{
    NSString* path = [NSString stringWithFormat:@"path/oper/mkdir/%@", directory];
    path = [path stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    MKNetworkOperation* op = [self operationWithPath:path
                                              params:nil
                                          httpMethod:@"PUT"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
         [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
             NSMutableDictionary* json = (NSMutableDictionary*) jsonObject;
             completionBlock(json);
         }];
         
     }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error) {
         errorBlock(erroredOperation, error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}


- (MKNetworkOperation*) rmdir:(NSString*) directory
                 onCompletion:(rmResponseBlock) completionBlock
                      onError:(MKNKResponseErrorBlock) errorBlock
{
    NSString* path = @"path/oper/remove/";
    
    NSDictionary* params = [NSDictionary dictionaryWithObject:[directory stringByReplacingOccurrencesOfString:@" " withString:@"%20"] forKey:@"path"];
    MKNetworkOperation* op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            NSDictionary* json = (NSDictionary*) jsonObject;
            completionBlock(json);
        }];
    }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error) {
        errorBlock(erroredOperation, error);
    }];
    
    [self enqueueOperation:op];
    return op;
}

- (MKNetworkOperation*) rm:(NSString*) file
              onCompletion:(rmResponseBlock) completionBlock
                   onError:(MKNKResponseErrorBlock) errorBlock;
{
    NSString* path = @"path/oper/remove/";
    
    NSDictionary* params = [NSDictionary dictionaryWithObject:[file stringByReplacingOccurrencesOfString:@" " withString:@"%20"] forKey:@"path"];
    MKNetworkOperation* op = [self operationWithPath:path
                                              params:params
                                          httpMethod:@"POST"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            NSDictionary* json = (NSDictionary*) jsonObject;
            completionBlock(json);
        }];
    }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error) {
        errorBlock(erroredOperation, error);
    }];
    
    [self enqueueOperation:op];
    return op;
}

@end
