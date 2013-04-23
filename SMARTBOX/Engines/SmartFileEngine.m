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

#import "SmartFileEngine.h"
#import "NSString+Encode.h"

@implementation SmartFileEngine


- (id)initWithDefaultSettings {
    NSMutableDictionary* headerFields = [NSMutableDictionary dictionary];
    [headerFields setValue:kAUTHHEADER
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
