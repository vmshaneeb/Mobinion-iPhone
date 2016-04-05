//
//  ServerRequests.m
//  Jenda
//
//  Created by newagesmb on 9/18/13.
//  Copyright (c) 2013 newagesmb. All rights reserved.
//

#import "ServerRequests.h"

@implementation ServerRequests

@synthesize delegate,chatrequest;


-(void) serverrequest:(NSString *)requset 
{
    NSLog(@"post_data2==>%@",requset);
    NSArray *arry=[requset componentsSeparatedByString:@","];
    NSData *postData = [arry[1] dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *URl=[NSString stringWithFormat:@"http://vyooha.cloudapp.net:1337/%@",arry[0]];
//    NSString *URl=[NSString stringWithFormat:@"http://192.168.0.74:1337/%@",arry[0]];
    NSLog(@"%@",arry[1]);
    [request setURL:[NSURL URLWithString:URl]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          // do something with the data
                                          NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[data length]);
                                          NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                          NSLog(@"%@",jsonString);
//                                          [self.delegate serverresponse:jsonString];
                                          [[NSNotificationCenter defaultCenter] postNotificationName: @"AppdelegatePage" object:jsonString userInfo: nil];
                                      }];
    [dataTask resume];
   /* }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Connect To Internet!!!"  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
		[appDelegate displayNetworkAvailability:self];
	}*/
}



//-(void)editgroup:(NSDictionary *)bits  file:(NSData *)file userid:(NSString *)userid groupid:(NSString *)groupid
//{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@updateGroupImage",appDelegate.Clienturl];
//    //    NSString * urlString= [NSString stringWithFormat:@"http://newagesme.com/runapp/index.php/client/update_image"];
//    NSLog(@"url......%@",urlString);
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"privacy\"\r\n\r\n%@", group] dataUsingEncoding:NSUTF8StringEncoding]];
//    //[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n%@", userid] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", userid] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_id\"\r\n\r\n%@", groupid] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"file ---- %@",[bits objectForKey:@"filename"]);
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", [bits objectForKey:@"filename"]] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[NSData dataWithData:file]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    //NSLog(@"postbody==========>%@",postbody);
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn) {
//        webData = [NSMutableData data];
//    }
//}



-(void)AddComments:(NSString *)comment run_id:(NSString *)run_id user_id:(NSString *)user_id
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@createComment",appDelegate.Clienturl];
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_id\"\r\n\r\n%@", run_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //    NSData *comments=[NSda]
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n%@", comment] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn)
//    {
//        webData = [NSMutableData data];
//    }
}


-(void)AddSuggessions:(NSString *)suggession user_id:(NSString *)user_id
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@addSuggesstion",appDelegate.Clienturl];
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"suggestion\"\r\n\r\n%@", suggession] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    NSLog(@"postbody==>%@",postbody);
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn)
//    {
//        webData = [NSMutableData data];
//    }
}




-(void)AddGrpComments:(NSString *)comment group_id:(NSString *)group_id user_id:(NSString *)user_id
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@createGroupComment",appDelegate.Clienturl];
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_id\"\r\n\r\n%@", group_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comments\"\r\n\r\n%@", comment] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn)
//    {
//        webData = [NSMutableData data];
//    }
}

-(void)Login:(NSString *)automatic password:(NSString *)password username:(NSString *)username
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@Login",appDelegate.Clienturl];
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n%@", username] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n%@", password] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
////    NSData *comments=[NSda]
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"automatic\"\r\n\r\n%@", automatic] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn)
//    {
//        webData = [NSMutableData data];
//    }
}

-(void)SentMessage:(NSString *)message to_id:(NSString *)to_id from_id:(NSString *)from_id
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@sendMessage",appDelegate.Clienturl];
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"from_id\"\r\n\r\n%@", from_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"to_id\"\r\n\r\n%@", to_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    //    NSData *comments=[NSda]
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n%@", message] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn)
//    {
//        webData = [NSMutableData data];
//    }
}




-(void)addProgrametoRun:(NSString*)user_id programe_id:(NSString*)programe_id run_location:(NSString *)run_location run_location_latitude:(NSString *)run_location_latitude run_location_longitude:(NSString *) run_location_longitude run_description:(NSString *)run_description run_distance:(NSString *)run_distance start_week:(NSString *)start_week
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@addProgrametoRun",appDelegate.Clienturl];
//    //    NSString * urlString= [NSString stringWithFormat:@"http://newagesme.com/runapp/index.php/client/createGroup"];
//    NSLog(@"url......%@",urlString);
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"programe_id\"\r\n\r\n%@", programe_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location\"\r\n\r\n%@", run_location] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location_latitude\"\r\n\r\n%@", run_location_latitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location_longitude\"\r\n\r\n%@", run_location_longitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_description\"\r\n\r\n%@", run_description] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_distance\"\r\n\r\n%@", run_distance] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"start_week\"\r\n\r\n%@", start_week] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn) {
//        webData = [NSMutableData data];
//    }
}


-(void)createRun:(NSString*)user_id run_location:(NSString *) run_location run_location_latitude:(NSString *)run_location_latitude run_location_longitude:(NSString *) run_location_longitude run_description:(NSString *)run_description run_distance:(NSString *)run_distance  date:(NSString*)date time:(NSString*)time group_ids:(NSString*)group_ids xtratime:(NSString*)xtratime
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@createRun",appDelegate.Clienturl];
//    //    NSString * urlString= [NSString stringWithFormat:@"http://newagesme.com/runapp/index.php/client/createGroup"];
//    NSLog(@"url......%@",urlString);
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location\"\r\n\r\n%@", run_location] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location_latitude\"\r\n\r\n%@", run_location_latitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location_longitude\"\r\n\r\n%@", run_location_longitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_description\"\r\n\r\n%@", run_description] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_distance\"\r\n\r\n%@", run_distance] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"date\"\r\n\r\n%@", date] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"time\"\r\n\r\n%@", time] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_ids\"\r\n\r\n%@", group_ids] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"xtratime\"\r\n\r\n%@", xtratime] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//
//    [request setHTTPBody:postbody];
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn) {
//        webData = [NSMutableData data];
//    }
}


-(void)createRuntoGroup:(NSString*)user_id run_location:(NSString *) run_location run_location_latitude:(NSString *)run_location_latitude run_location_longitude:(NSString *) run_location_longitude run_description:(NSString *)run_description run_distance:(NSString *)run_distance  date:(NSString*)date time:(NSString*)time group_ids:(NSString*)group_ids xtratime:(NSString*)xtratime Group_id:(NSString *)Group_id
{
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@createRun_Group",appDelegate.Clienturl];
//    //    NSString * urlString= [NSString stringWithFormat:@"http://newagesme.com/runapp/index.php/client/createGroup"];
//    NSLog(@"url......%@",urlString);
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", user_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location\"\r\n\r\n%@", run_location] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location_latitude\"\r\n\r\n%@", run_location_latitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_location_longitude\"\r\n\r\n%@", run_location_longitude] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_description\"\r\n\r\n%@", run_description] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"run_distance\"\r\n\r\n%@", run_distance] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"date\"\r\n\r\n%@", date] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"time\"\r\n\r\n%@", time] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_ids\"\r\n\r\n%@", group_ids] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"xtratime\"\r\n\r\n%@", xtratime] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_id\"\r\n\r\n%@", Group_id] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn) {
//        webData = [NSMutableData data];
//    }
}


-(void)creategroup:(NSDictionary *)bits file:(NSData *)file userid:(NSString*)userid groupname:(NSString *) groupname locatn:(NSString *) locatn description:(NSString *) description type:(NSString *) type members:(NSString *)members
{
    
//    appDelegate=(AppDelegate *)[[UIApplication sharedApplication]delegate];
//    NSString * urlString= [NSString stringWithFormat:@"%@createGroup",appDelegate.Clienturl];
////    NSString * urlString= [NSString stringWithFormat:@"http://newagesme.com/runapp/index.php/client/createGroup"];
//    NSLog(@"url......%@",urlString);
//    
//    NSMutableURLRequest *request= [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSString *boundary = @"---------------------------14737809831466499882746641449";
//    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
//    NSMutableData *postbody = [NSMutableData data];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"privacy\"\r\n\r\n%@", group] dataUsingEncoding:NSUTF8StringEncoding]];
//    //[postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    //[postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userid\"\r\n\r\n%@", userid] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n%@", userid] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_name\"\r\n\r\n%@", groupname] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"location\"\r\n\r\n%@", locatn] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"description\"\r\n\r\n%@", description] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"private\"\r\n\r\n%@", type] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"group_mmebers\"\r\n\r\n%@", members] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", [bits objectForKey:@"filename"]] dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [postbody appendData:[NSData dataWithData:file]];
//    
//    [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    [request setHTTPBody:postbody];
//    isChat=FALSE;
////    NSLog(@"postbody==========>%@",postbody);
//    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if (conn) {
//        webData = [NSMutableData data];
//    }
}

@end
