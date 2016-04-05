//
//  ServerRequests.h
//  Jenda
//
//  Created by newagesmb on 9/18/13.
//  Copyright (c) 2013 newagesmb. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "AppDelegate.h"

@protocol serverdelegate <NSObject>

-(void)serverresponse:(NSString *) str;

@end

@protocol chatreq <NSObject>

-(void)chatresponse:(NSString *) str;

@end

@interface ServerRequests : NSObject{
    
    //---web service access ---
//    NSMutableData *webData;
    NSURLConnection *conn;
    NSMutableString *postStatus;
    id<serverdelegate>delegate;
//    AppDelegate *appDelegate;
    BOOL isChat;
    
}

@property (retain, nonatomic) id<serverdelegate>delegate;
@property (retain, nonatomic) id<chatreq>chatrequest;
-(void) serverrequest:(NSString *)requset;
//-(void)submitEdit:(NSDictionary *)bits  file:(NSData *)file userid:(NSString*)userid;
//-(void)creategroup:(NSDictionary *)bits  file:(NSData *)file userid:(NSString*)userid groupname:(NSString *) groupname locatn:(NSString *) locatn description:(NSString *) description type:(NSString *) type members:(NSString *)members;
//-(void)sendChatRequests:(NSString *)post_data;
//-(void)editgroup:(NSDictionary *)bits  file:(NSData *)file userid:(NSString *)userid groupid:(NSString *)groupid;
//-(void)AddComments:(NSString *)comment run_id:(NSString *)run_id user_id:(NSString *)user_id;
//-(void)AddGrpComments:(NSString *)comment group_id:(NSString *)group_id user_id:(NSString *)user_id;
//
//-(void)createRun:(NSString*)user_id run_location:(NSString *) run_location run_location_latitude:(NSString *)run_location_latitude run_location_longitude:(NSString *) run_location_longitude run_description:(NSString *)run_description run_distance:(NSString *)run_distance  date:(NSString*)date time:(NSString*)time group_ids:(NSString*)group_ids xtratime:(NSString*)xtratime;
//
//
//-(void)createRuntoGroup:(NSString*)user_id run_location:(NSString *) run_location run_location_latitude:(NSString *)run_location_latitude run_location_longitude:(NSString *) run_location_longitude run_description:(NSString *)run_description run_distance:(NSString *)run_distance  date:(NSString*)date time:(NSString*)time group_ids:(NSString*)group_ids xtratime:(NSString*)xtratime Group_id:(NSString *)Group_id;
//
//-(void)addProgrametoRun:(NSString*)user_id programe_id:(NSString*)programe_id run_location:(NSString *)run_location run_location_latitude:(NSString *)run_location_latitude run_location_longitude:(NSString *) run_location_longitude run_description:(NSString *)run_description run_distance:(NSString *)run_distance start_week:(NSString *)start_week;
//
//-(void)SentMessage:(NSString *)message to_id:(NSString *)to_id from_id:(NSString *)from_id;
//-(void)Login:(NSString *)automatic password:(NSString *)password username:(NSString *)username;
//-(void)AddSuggessions:(NSString *)suggession user_id:(NSString *)user_id;
@end
