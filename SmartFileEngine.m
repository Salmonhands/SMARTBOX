//
//  SmartFileEngine.m
//  jsonTest
//
//  Created by macadmin on 3/14/13.
//  Copyright (c) 2013 Salmonhands. All rights reserved.
//

#import "SmartFileEngine.h"
#import "NSString+Encode.h"

#define kCLIENTTOKEN @"cmS726SZ4HBPkhEAjtuXmAfbY9cs6X"
#define kCLIENTSECRET @"t3vrC46YPRLtqVgpAL65tUlwfVLN5v"

@implementation SmartFileEngine


- (id)initWithDefaultSettings {
    NSMutableDictionary* headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:@"Basic ODM4a05MY0JJME5OSk5mc0hIc25KdTZ2MFZkRFlvOk9iaHpJYWRPRUh5ZjVlZHVYMTRBQWFTTnN4MWxTcg=="
                    forKey:@"Authorization"];
    self = [self initWithHostName:@"app.smartfile.com" apiPath:@"api/2" customHeaderFields:headerFields];
    return self;
}

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
    
    //file = [file stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //file = [file stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"];
    
    NSDictionary* params = [NSDictionary dictionaryWithObject:file forKey:@"path"];
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

- (MKNetworkOperation*) upload:(NSString*) file
                            to:(NSString*) directory
                  onCompletion:(taskResponseBlock) completionBlock
                       onError:(MKNKResponseErrorBlock) errorBlock
{
    NSString* path = @"path/data";
    DLog(@"PATH: %@", path);
    path = [path stringByAppendingString:directory];
    
    MKNetworkOperation* op = [self operationWithPath:path
                                              params:nil
                                          httpMethod:@"POST"
                                                 ssl:YES];
    DLog(@"FILE: %@", file);
    [op addFile:file forKey:@"file1"];
    [op setFreezable:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        DLog(@"cCOMPLETE: %@", completedOperation);
    }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error) {
        errorBlock(erroredOperation, error);
    }];
    
    [self enqueueOperation:op];
    return op;
    
}

- (MKNetworkOperation*) getCurrentUserOnCompletion:(userResponseBlock) completionBlock
                                           onError:(MKNKResponseErrorBlock) errorBlock
{
    NSString* path = @"whoami/";
    MKNetworkOperation* op = [self operationWithPath:path
                                              params:nil
                                          httpMethod:@"GET"
                                                 ssl:YES];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
             NSMutableDictionary* json = (NSMutableDictionary*) jsonObject;
             json = [json objectForKey:@"user"];
             completionBlock([json objectForKey:@"username"]);
         }];
         
     }errorHandler:^(MKNetworkOperation *erroredOperation, NSError *error) {
         errorBlock(erroredOperation, error);
     }];
    
    [self enqueueOperation:op];
    return op;
    
}

@end
