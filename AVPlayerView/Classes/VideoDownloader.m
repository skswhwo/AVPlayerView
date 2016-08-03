//
//  VideoDownloader.m
//  AVPlayerView
//
//  Created by ChoJaehyun on 2016. 8. 3..
//  Copyright © 2016년 com.skswhwo. All rights reserved.
//

#import "VideoDownloader.h"
@interface VideoDownloader ()
<NSURLConnectionDelegate>

@end


@implementation VideoDownloader

- (void)checkHeader:(NSURL *)url
{
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0f];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"HEAD"];
//    
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
//     {
//         NSLog(@"Content-lent: %lld", [operation.response expectedContentLength]);
//         
//     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         NSLog(@"Error: %@", error);
//     }];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSDictionary *foo = [(NSHTTPURLResponse *)response allHeaderFields];
    NSLog(@"foo %@",foo);
    
    
//    NSString * last_modified = [NSString stringWithFormat:@"%@",
//                                [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"]];
//    NSLog(@"Last-Modified: %@", last_modified );
    
}

@end
