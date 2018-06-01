//
//  SMWebServices.m
//  SmartManager
//
//  Created by Liji Stephen on 05/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMWebServices.h"
#import "SMInteriorReconditioningObject.h"
#import "SMConditionOptionsObject.h"
#import "SMExteriorReconditioning.h"

@implementation SMWebServices


#define WEB_SERVICE_TRADE_SERVICE  @"ITradeService"
#define WEB_SERVICE_ISTOCK_SERVICE @"IStockService"
#define WEB_SERVICE_ISPECIAL_SERVICE @"ISpecialsService"
#define WEB_SERVICE_BLOG_SERVICE            @"IBlogService"
#define WEB_SERVICE_AUTHENTICATE_SERVICE    @"IAuthenticate"
#define WEB_SERVICE_IPLANNER_SERVICE        @"IPlannerService"
#define WEB_SERVICE_LICENSE_SERVICE        @"ILicense"
#define WEB_SERVICE_TEMPURI                 @"http://tempuri.org"


#define WEB_SERVICE_LIVE @"ix.co.za" //ix.co.za //ixssl.co.za
#define WEB_SERVICE_STAGING @"ixstaging.co.za"
//#define WEB_SERVICE_LIVE @"qa.ix.co.za"


+ (NSString*) uploadVideosWebserviceUrl
{
    
    return [NSString stringWithFormat:@"http://uploadservice.%@/api/Video",WEB_SERVICE_LIVE];
}

+(NSString *)blogImageUrl
{
    return [NSString stringWithFormat:@"http://netwin.%@/",WEB_SERVICE_LIVE];
}

+(NSString*)authenticateWebserviceUrl
{
    //return [NSString stringWithFormat:@"http://p4.authentication.%@/Authenticate.svc",WEB_SERVICE_LIVE];
    return @"https://authenticationapi.ixssl.co.za/api/Login";
    
}
+(NSString *) activeSpecailListingImage
{
    return [NSString stringWithFormat:@"http://www.%@/GetImage.aspx?ImageID=",WEB_SERVICE_STAGING];
}


+(NSString*)plannerWebserviceUrl
{
    return [NSString stringWithFormat:@"http://planner.%@/PlannerService.svc",WEB_SERVICE_LIVE];
    
}

+(NSString*)blogWebserviceUrl
{
    return [NSString stringWithFormat:@"http://blog.%@/BlogService.svc",WEB_SERVICE_LIVE];
}

+(NSString *)stockWebService
{
    return [NSString stringWithFormat:@"http://stockservice.%@/StockService.svc",WEB_SERVICE_LIVE];
}

+(NSString *)tradeWebService
{
    return [NSString stringWithFormat:@"http://tradeservice.%@/TradeService.svc",WEB_SERVICE_LIVE];
}

+(NSString *)leadWebService
{
    
    return [NSString stringWithFormat:@"http://leadservicenew.%@/LeadService.svc?singleWsdl",WEB_SERVICE_LIVE];
    //return [NSString stringWithFormat:@"http://lead.%@/LeadService.svc",WEB_SERVICE_LIVE];
}

+(NSString *)eBrochureWebService
{
    return [NSString stringWithFormat:@"http://ebrochure.%@/ElectronicBrochureGeneratorService.svc",WEB_SERVICE_LIVE];
}
+(NSString *)specialWebService
{
    return [NSString stringWithFormat:@"http://specialsservice.%@/SpecialsService.svc",WEB_SERVICE_STAGING];
}
+(NSString *)licenceWebService
{
    return [NSString stringWithFormat:@"http://licensesvc.%@/License.svc",WEB_SERVICE_LIVE];
}

+(NSString *)stockAuditWebService
{
    
  return [NSString stringWithFormat:@"http://stock.%@/StockService.svc",WEB_SERVICE_LIVE];
}


#pragma mark - Impesonate Web Service

+ (NSMutableURLRequest*)getAllImpersonateClientWithUserHash:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ImpersonationRights xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ImpersonationRights>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    NSLog(@"Authenticate = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ImpersonationRights",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return request;
}

#pragma mark - Login Web Service
/*+(NSMutableURLRequest*)loginWithUsername:(NSString*)userName andPassword:(NSString*)password
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AuthenticateUser xmlns=\"%@/\">"
                             "<userName>%@</userName>"
                             "<password>%@</password>"
                             "</AuthenticateUser>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userName,[password uppercaseString]];
    
    NSLog(@"Authenticate = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AuthenticateUser",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}*/
#pragma mark - New Login Web API using digest authentication
+(NSMutableURLRequest*)loginWithUsername:(NSString*)userName andPassword:(NSString*)password
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"accept"];
    [request setHTTPMethod:@"GET"];
    return request;
}
+(NSMutableURLRequest*)SaveDeviceTokenOfOneSignalWithUserHash:(NSString*)userHash andCodeType:(int)codeType andDeviceCode:(NSString*) deviceCode
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveDeviceCode xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<CodeType>%d</CodeType>"
                             "<DeviceCode>%@</DeviceCode>"
                             "</SaveDeviceCode>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,codeType,deviceCode];
    
    // NSLog(@"Authenticate = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveDeviceCode",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getAllAppNotifications:(NSString*)userHash andPageSize:(int)pageSize andPageNum:(int) pageNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetNotifications xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<pageSize>%d</pageSize>"
                             "<page>%d</page>"
                             "</GetNotifications>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,pageSize,pageNum];
    
    NSLog(@"Authenticate = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetNotifications",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)searchAppNotifications:(NSString*)userHash andSearchKey:(NSString*)searchKey andPageSize:(int)pageSize andPageNum:(int) pageNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SearchNotifications xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<key>%@</key>"
                             "<pageSize>%d</pageSize>"
                             "<page>%d</page>"
                             "</SearchNotifications>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,searchKey,pageSize,pageNum];
    
    NSLog(@"Authenticate = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SearchNotifications",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


+(NSMutableURLRequest*)markNotificationAsRead:(NSString*)userHash andNotificationID:(int)notificationId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<MarkNotificationAsRead xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<notificationID>%d</notificationID>"
                             "</MarkNotificationAsRead>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,notificationId];
    
    NSLog(@"Authenticate = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/MarkNotificationAsRead",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get All Blogs Web Service

+(NSMutableURLRequest*)getAllBlogTypesCorrespondingToUserHash:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetBlogTypes xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "</GetBlogTypes>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetBlogTypes",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Save The Blog Web Service

+(NSMutableURLRequest*)saveTheBlogDataWithUserHashValue:(NSString*)userHash andBlogPostTypeID:(int)blogPostTypeID andBlogTitle:(NSString*)title andBlogDetails:(NSString*)blogDetails andStartDate:(NSString*)startDate andEndDate:(NSString*)endDate andAuthor:(NSString*)authorName andActiveStatus:(BOOL)activeStatus andUserID:(NSString*)userID andClientID:(NSString*)clientID andBlogPostID:(int)blogPostID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveBlogPost xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<BlogPostTypeVal>%d</BlogPostTypeVal>"
                             "<Title>%@</Title>"
                             "<CKEditor1>%@</CKEditor1>"
                             "<DateFrom>%@</DateFrom>"
                             "<EndDate>%@</EndDate>"
                             "<Author>%@</Author>"
                             "<Active>%hhd</Active>"
                             "<nUserID>%@</nUserID>"
                             "<nCLientID>%@</nCLientID>"
                             "<BlogPostID>%d</BlogPostID>"
                             "</SaveBlogPost>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostTypeID,title,blogDetails,startDate,endDate,authorName,activeStatus,userID,clientID,blogPostID];
    
    
    // NSLog(@"Soap message = %@",soapMessage);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveBlogPost",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Save Images To Server Web Service

+(NSMutableURLRequest*)saveTheImagesToTheServerWithUserHashValue:(NSString*)userHash andClientID:(int)clientID andBlogPostID:(int)blogPostID andUserID:(int)userID andPriority:(int)priority andOriginalFileName:(NSString*)originalFileName andEncodedImage:(NSString*)encodedImage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveBlogImage xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<BlogPostID>%d</BlogPostID>"
                             "<cmUserID>%d</cmUserID>"
                             "<ClientID>%d</ClientID>"
                             "<Priority>%d</Priority>"
                             "<OriginalFileName>%@</OriginalFileName>"
                             "<Base64EncodedImage>%@</Base64EncodedImage>"
                             "</SaveBlogImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID,userID,clientID,priority,originalFileName,encodedImage];
    
    NSLog(@"soapMESSAGE = %@",soapMessage);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveBlogImage",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSData*)saveTheImageDataToTheServerWithUserHashValue:(NSString*)userHash andClientID:(int)clientID andBlogPostID:(int)blogPostID andUserID:(int)userID andPriority:(int)priority andOriginalFileName:(NSString*)originalFileName andEncodedImage:(NSString*)encodedImage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveBlogImage xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<BlogPostID>%d</BlogPostID>"
                             "<cmUserID>%d</cmUserID>"
                             "<ClientID>%d</ClientID>"
                             "<Priority>%d</Priority>"
                             "<OriginalFileName>%@</OriginalFileName>"
                             "<Base64EncodedImage>%@</Base64EncodedImage>"
                             "</SaveBlogImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID,userID,clientID,priority,originalFileName,encodedImage];
    
    /* NSLog(@"soapMESSAGE = %@",soapMessage);
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
     NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
     
     [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     [request addValue:[NSString stringWithFormat:@"%@/%@/SaveBlogImage",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
     [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
     [request setHTTPMethod:@"POST"];
     [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
     return request;*/
    
    return [soapMessage dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - Search For Active Blogs Web Service

+(NSMutableURLRequest*)searchForTheActiveBlogWithUserHash:(NSString*)userHash andClientID:(int)clientID andSearchText:(NSString*)searchText andStartDate:(NSString*)startDate andEndDate:(NSString*)endDate andStartIndex:(int)startIndex andPageSize:(int)npageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetActiveBlogPostXML xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<search>%@</search>"
                             "<dateFrom>%@</dateFrom>"
                             "<endDate>%@</endDate>"
                             "<nClient>%d</nClient>"
                             "<nPage>%d</nPage>"
                             "<nPageSize>%d</nPageSize>"
                             "</GetActiveBlogPostXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,searchText,startDate,endDate,clientID,startIndex,npageSize];
    
    
    NSLog(@"soap message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetActiveBlogPostXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Search For Inactive Blogs Web Service

+(NSMutableURLRequest*)searchForTheInactiveBlogWithUserHash:(NSString*)userHash andClientID:(int)clientID andSearchText:(NSString*)searchText andStartDate:(NSString*)startDate andEndDate:(NSString*)endDate andStartIndex:(int)startIndex
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetInActiveBlogPostXML xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<search>%@</search>"
                             "<dateFrom>%@</dateFrom>"
                             "<endDate>%@</endDate>"
                             "<nClient>%d</nClient>"
                             "<nStart>%d</nStart>"
                             "</GetInActiveBlogPostXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,searchText,startDate,endDate,clientID,startIndex];
    
    // NSLog(@"soap message : %@",soapMessage);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetInActiveBlogPostXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Edit Blog Web Service

+(NSMutableURLRequest*)getTheBlogToEditCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetBlog xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<ID>%d</ID>"
                             "</GetBlog>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID];
    
    
    NSLog(@"GetBlog = %@",soapMessage);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetBlog",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Blog Images Edit Web Service

+(NSMutableURLRequest*)getTheBlogImagesToEditCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetBlogImagesByBlogPostID xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<blogPostId>%d</blogPostId>"
                             "</GetBlogImagesByBlogPostID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID];
    
    
    // NSLog(@"GetBlogImagesByBlogPostID = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetBlogImagesByBlogPostID",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Delete Blog Web Service

+(NSMutableURLRequest*)deleteTheBlogImageCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<DeleteBlogImage xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<blogImageID>%d</blogImageID>"
                             "</DeleteBlogImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/DeleteBlogImage",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - End Blog Web Service

+(NSMutableURLRequest*)endTheBlogCorrespondingToUserHash:(NSString*)userHash andBlogPostId:(int)blogPostID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<EndBlog xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<ID>%d</ID>"
                             "</EndBlog>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/EndBlog",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Update Blog Image Priority Web Service

+(NSMutableURLRequest*)updateBlogImagePriorityCorrespondingToUserHash:(NSString*)userHash andBlogImageID:(int)blogImageID andPriority:(int)priority
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateBlogImagePriority xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<blogImageID>%d</blogImageID>"
                             "<priority>%d</priority>"
                             "</UpdateBlogImagePriority>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogImageID,priority];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/UpdateBlogImagePriority",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Update Blog Image Priority With Image Name Web Service

+(NSMutableURLRequest*)updateBlogImagePriorityWithImageNameCorrespondingToUserHash:(NSString*)userHash andBlogPostID:(int)blogPostID andPriority:(int)priority andImageName:(NSString*)imageName
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateBlogImagePriorityAndName xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<blogPostID>%d</blogPostID>"
                             "<priority>%d</priority>"
                             "<imageName>%@</imageName>"
                             "</UpdateBlogImagePriorityAndName>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,blogPostID,priority,imageName];
    
    DLog(@"Soap Message to update priority with imagename : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self blogWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/UpdateBlogImagePriorityAndName",WEB_SERVICE_TEMPURI,WEB_SERVICE_BLOG_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

/*
 
 Purpose          : For getting all clients in the given location
 OutPut           : Return All list of Clients in the given location
 
 */

#pragma mark - Get All Client Name Web Service

+(NSMutableURLRequest*)getAllTheClientsAtTheLocationWithUserHashValue:(NSString*)hashValue andLatitude:(double)latitude andLongitude:(double)longitude
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<DoGeoTag xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<googleLAtitude>%f</googleLAtitude>"
                             "<googleLongitude>%f</googleLongitude>"
                             "</DoGeoTag>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,latitude,longitude];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/DoGeoTag",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get All Planner Type Web Service

+(NSMutableURLRequest*)getAllThePlannerTypeCorrespondingToUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListPlannerTypeXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "</ListPlannerTypeXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListPlannerTypeXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get All Available Client Web Service

+(NSMutableURLRequest*)getAllTheAvailableClientsCorrespondingToUserHash:(NSString*)hashValue
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListAvailableClientsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ListAvailableClientsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue];
    
    // NSLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListAvailableClientsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Save Log Activity Web Service

+(NSMutableURLRequest*)saveTHeLogActivityDataToTheserverWithUserHash:(NSString*)userHash andClientID:(int)clientID andPlannerTypeID:(int)plannerTypeID andDetails:(NSString*)details andIsInternal:(BOOL)isInternal andTimeSpent:(int)timeSpentInMinutes andIsToday:(BOOL)isToday andAlternateDate:(NSString*)alternateDate andLocationLatitude:(double)locationLatitude andLocationLongitude:(double)locationLongitude andLocationAddress:(NSString*)locationAddress andClientName:(NSString*)contactPerson
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LogActivity xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<plannerTypeID>%d</plannerTypeID>"
                             "<details>%@</details>"
                             "<isInternal>%d</isInternal>"
                             "<timeSpent>%d</timeSpent>"
                             "<isToday>%d</isToday>"
                             "<alternateDate>%@</alternateDate>"
                             "<locationLatitude>%f</locationLatitude>"
                             "<locationLongitude>%f</locationLongitude>"
                             "<locationAddress>%@</locationAddress>"
                             "<contactPerson>%@</contactPerson>"
                             "</LogActivity>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,plannerTypeID,details,isInternal,timeSpentInMinutes,isToday,alternateDate,locationLatitude,locationLongitude,locationAddress,contactPerson];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LogActivity",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Save New Task Web Service

+(NSMutableURLRequest*)saveTheNewTaskDataToTheserverWithUserHash:(NSString*)userHash andClientID:(int)clientID andPlannerTypeID:(int)plannerTypeID andRecepientID:(int)recipientID andTitle:(NSString*)title andDetails:(NSString*)details andDate:(NSString*)date andIsCalender:(BOOL)isCalender
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<PostNewTask xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<plannerTypeID>%d</plannerTypeID>"
                             "<coreMemberID>%d</coreMemberID>"
                             "<title>%@</title>"
                             "<details>%@</details>"
                             "<date>%@</date>"
                             "<sendCalendar>%d</sendCalendar>"
                             "</PostNewTask>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,plannerTypeID,recipientID ,title,details,date,isCalender];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/PostNewTask",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get All Members Web Service

+(NSMutableURLRequest*)getAllTheMembersForNewTaskModuleCorrespondingToUserHash:(NSString*)hashValue
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListMembersForClientXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ListMembersForClientXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListMembersForClientXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Save All Images of New Task Web Service

+(NSMutableURLRequest*)saveAllImagesOfNewTaskWithUserHash:(NSString*)userHash andTaskID:(int)taskID andImageDescription:(NSString*)imageDesc andImageFileName:(NSString*)imgFileName andImgBase64String:(NSString*)baseString
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddImageToTask64 xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "<imageDescription>%@</imageDescription>"
                             "<imageFilename>%@</imageFilename>"
                             "<imageBase64>%@</imageBase64>"
                             "</AddImageToTask64>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,taskID,imageDesc,imgFileName,baseString];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddImageToTask64",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get List Activities By Location Web Service

+(NSMutableURLRequest*)getAllTheToDoMembersForLocationWithUserHash:(NSString*)userHash andCoreMemberID:(int)memberID andLatitude:(double)latitude andLogitude:(double)longitude
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActivitiesForMemberByLocationXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreMemberID>%d</coreMemberID>"
                             "<googleLatitude>%f</googleLatitude>"
                             "<googleLongitude>%f</googleLongitude>"
                             "</ListActivitiesForMemberByLocationXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,memberID,latitude,longitude];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListActivitiesForMemberByLocationXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get List Activities For Member Period Web Service

+(NSMutableURLRequest*)getAllTheToDoMembersWithPeriodWithUserHash:(NSString*)userHash andCoreMemberID:(int)memberID andFromDate:(NSString*)fromDate andToDate:(NSString*)toDate
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActivitiesForMemberPeriodXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreMemberID>%d</coreMemberID>"
                             "<fromDate>%@</fromDate>"
                             "<toDate>%@</toDate>"
                             "</ListActivitiesForMemberPeriodXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,memberID,fromDate,toDate];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListActivitiesForMemberPeriodXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get All To do Member Web Service

+(NSMutableURLRequest*)getAllTheToDoMembersWithUserHash:(NSString*)userHash andCoreMemberID:(int)memberID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActivitiesForMemberXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreMemberID>%d</coreMemberID>"
                             "</ListActivitiesForMemberXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,memberID];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListActivitiesForMemberXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get List Vehicles By Keyword Status Web Service

+(NSMutableURLRequest*)filterThePhotosNExtrasBasedOnSearchWithUserHash:(NSString*)hashValue andClientID:(int)clientID andsearchKeyword:(NSString*)searchText andPageSize:(int)pageSize andPageNumber:(int)pageNumber andStatus:(int)status andSortText:(NSString*)sortText andNewUsed:(NSString*) newUsed
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVehiclesByKeywordStatusXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<keyword>%@</keyword>"
                             "<pageSize>%d</pageSize>"
                             "<pageNumber>%d</pageNumber>"
                             "<Status>%d</Status>"
                             "<sort>%@</sort>"
                             "<newUsed>%@</newUsed>"
                             "</ListVehiclesByKeywordStatusXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,searchText,pageSize,pageNumber,status,sortText,newUsed];
    
    NSLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVehiclesByKeywordStatusXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Accept Task For Planner Web Service

+(NSMutableURLRequest*)acceptPlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalComment:(NSString*)comment
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AcceptTask xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "<optionalComment>%@</optionalComment>"
                             "</AcceptTask>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID,comment];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AcceptTask",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Reject Task For Planner Web Service

+(NSMutableURLRequest*)rejectPlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalReason:(NSString*)reason
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RejectTask xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "<optionalReason>%@</optionalReason>"
                             "</RejectTask>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID,reason];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RejectTask",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Close Task For Planner Web Service

+(NSMutableURLRequest*)closeThePlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalReason:(NSString*)reason
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<CloseTask xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "<optionComment>%@</optionComment>"
                             "</CloseTask>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID,reason];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/CloseTask",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Comment On Task For Planner Web Service

+(NSMutableURLRequest*)saveCommentOfPlannerToDoTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID andOptionalComment:(NSString*)comment
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<CommentOnTask xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "<comment>%@</comment>"
                             "</CommentOnTask>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID,comment];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/CommentOnTask",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get Task Detail For Planner Web Service

+(NSMutableURLRequest*)getTheDetailsOfToDosTaskWithUserHash:(NSString*)hashValue andTaskID:(int)taskID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTaskDetail xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "</GetTaskDetail>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTaskDetail",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get Task Images For Planner Web Service

+(NSMutableURLRequest*)getTheNewTaskImagesWithUserHash:(NSString*)hashValue andTaskID:(int)taskID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTaskImages xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "</GetTaskImages>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/GetTaskImages",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get List Activities By Member For Planner Web Service

+(NSMutableURLRequest*)getTheTasksByMeCorrespondingToUserHash:(NSString*)hashValue andCoreMemberID:(int)memberID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActivitiesByMemberXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreMemberID>%d</coreMemberID>"
                             "</ListActivitiesByMemberXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,memberID];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListActivitiesByMemberXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Unable To Do Task For Planner Web Service

+(NSMutableURLRequest*)NoCanDoTaskWithUserHash:(NSString*)hashValue andPlannerTaskId:(int)taskID andOptionalComment:(NSString*)comment
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UnableToDoTask xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<plannerTaskID>%d</plannerTaskID>"
                             "<optionalComment>%@</optionalComment>"
                             "</UnableToDoTask>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,taskID,comment];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/UnableToDoTask",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - List Vehicles By Keyword Web Service

+(NSMutableURLRequest*)filterThePhotosNExtrasBasedOnSearchWithUserHash:(NSString*)hashValue andClientID:(int)clientID andsearchKeyword:(NSString*)searchText andPageSize:(int)pageSize andPageNumber:(int)pageNumber andSortText:(NSString*)sortText
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVehiclesByKeywordXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<keyword>%@</keyword>"
                             "<pageSize>%d</pageSize>"
                             "<pageNumber>%d</pageNumber>"
                             "<sort>%@</sort>"
                             "</ListVehiclesByKeywordXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,searchText,pageSize,pageNumber,sortText];
    
    DLog(@"Soap Message  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVehiclesByKeywordXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


// =================================== End of Liji's Module =====================================================================


/*
 
 Purpose          : For getting all Make Values
 Input Parameter  : userHash
 OutPut           : Return All make values
 
 */


// ***********************************FOR TRADER MODULE *******************************

#pragma mark - Get All Make Web Service

+(NSMutableURLRequest*) gettingAllMakevalues:(NSString *) userHash
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListMakesOpenTBL xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ListMakesOpenTBL>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListMakesOpenTBL",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*) gettingAllMakevaluesForSpecials:(NSString *) userHash
                                                   Year:(NSString*)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetVehicleMakesByYearJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%@</year>"
                             "</GetVehicleMakesByYearJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year];
    
    // NSLog(@"Soap Message : %@",soapMessage);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetVehicleMakesByYearJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

/*
 
 Purpose         : For getting All Model Values
 Input Parameter : userHash and Make ID
 OutPut          : Return All model values
 
 */
#pragma mark - Get All Model Web Service

+(NSMutableURLRequest*) gettingAllModelsvaluesForSpecials:(NSString *) userHash
                                                     Year:(NSString*)year
                                                   makeId:(int)makeId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetVehicleModelsByMakeIdJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<id>%d</id>"
                             "<year>%@</year>"
                             "</GetVehicleModelsByMakeIdJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,makeId,year];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetVehicleModelsByMakeIdJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

/*
 
 
 Purpose         : For getting All Model Values
 Input Parameter : userHash and Make ID
 OutPut          : Return All model values
 
 */
#pragma mark - Get All Varinats Web Service

+(NSMutableURLRequest*) gettingAllVarinatsValues:(NSString *) strUserHash withModel:(int) iModelId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVariantsOpenTBL xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%d</modelID>"
                             "</ListVariantsOpenTBL>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iModelId];
    
    DLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListVariantsOpenTBL",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

/*
 
 
 Purpose         : For getting All Vehicle Listing
 Input Parameter : userHash and Client ID
 OutPut          : Return All Vehicle Listing values
 
 */

#pragma mark - Get All Listing For Vehicle Web Service

+(NSMutableURLRequest*)  gettingAllListingForVehicle:(NSString *) userHash withClientID:(int) iClientID withPageSize:(int) iPageSize withPageNumber:(int) iPageNumber
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListAllVehiclesTbl xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<pageSize>%d</pageSize>"
                             "<pageNumber>%d</pageNumber>"
                             "</ListAllVehiclesTbl>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,iClientID,iPageSize,iPageNumber];
    
    DLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListAllVehiclesTbl",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


// ***********************************FOR TRADER MODULE *******************************


// ***********************************FOR VEHICLES MODULE *******************************

#pragma mark - Get All Make For Vehicle Web Service

+(NSMutableURLRequest*) gettingAllMakevaluesForVehicles:(NSString *) userHash
                                                   Year:(NSString*)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListMakesJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%@</year>"
                             "</ListMakesJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListMakesJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - List Model JSON Web Service

+(NSMutableURLRequest*) gettingAllModelsvaluesForVehicles:(NSString *) userHash
                                                     Year:(NSString*)year
                                                   makeId:(int)makeId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListModelsJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%@</year>"
                             "<makeID>%d</makeID>"
                             "</ListModelsJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,makeId];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListModelsJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - List Variant JSON Web Service

+(NSMutableURLRequest*) gettingAllVarintsvaluesForVehicles:(NSString *) userHash
                                                      Year:(NSString*)year
                                                   modelId:(int)modelId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVariantsJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%@</year>"
                             "<modelID>%d</modelID>"
                             "</ListVariantsJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,modelId];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVariantsJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - VariantDetails Web Service

+(NSMutableURLRequest*) gettingDetailsOfVINForVehicles:(NSString *) userHash
                                             variantId:(int)variantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<VariantDetails xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "</VariantDetails>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantId];
    
    //NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/VariantDetails",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - CheckScannedVinJSON Web Service

+(NSMutableURLRequest*) gettingVINScanForVehicles:(NSString *) userHash
                                         clientID:(int)clientID
                                              vin:(NSString*)vin
                                     registration:(NSString*)registration
                                           makeId:(NSString*)makeId
                                          modelId:(NSString*)modelId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<CheckScannedVinJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<vin>%@</vin>"
                             "<registration>%@</registration>"
                             "<make>%@</make>"
                             "<model>%@</model>"
                             "</CheckScannedVinJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,vin,registration,makeId,modelId];
    
    NSLog(@" CheckScannedVinJSON ****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/CheckScannedVinJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - SavedVinScan Web Service

+(NSMutableURLRequest*) SavedVinScanForLater:(NSString *) userHash
                                    clientID:(int)clientID
                                         vin:(NSString*)vin
                                registration:(NSString*)registration
                                       shape:(NSString*)shape
                                        year:(NSString*)year
                                      makeId:(NSString*)makeId
                                     modelId:(NSString*)modelId
                                     variant:(NSString*)variant
                                      colour:(NSString*)colour
                                    engineNo:(NSString*)engineNo
                                  kilometers:(NSString*)kiloMeters
                                  extrasCost:(NSString*)extrasCost
                                   condition:(NSString*)condition
                                   licExpiry:(NSString*)licExpiry
                                   variantid:(NSString*)variantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveVINScan xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<vin>%@</vin>"
                             "<registration>%@</registration>"
                             "<shape>%@</shape>"
                             "<year>%@</year>"
                             "<make>%@</make>"
                             "<model>%@</model>"
                             "<variant>%@</variant>"
                             "<variantID>%@</variantID>"
                             "<colour>%@</colour>"
                             "<engineNo>%@</engineNo>"
                             "<kilometers>%@</kilometers>"
                             "<extras>%@</extras>"
                             "<condition>%@</condition>"
                             "<licenseExpiry>%@</licenseExpiry>"
                             "</SaveVINScan>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,vin,registration,shape,year,makeId,modelId,variant,variantId,colour,engineNo,kiloMeters,extrasCost,condition,licExpiry];
    
    
    //NSLog(@"Soap Message : %@",soapMessage);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveVINScan",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ValidateVinJSON Web Service

+(NSMutableURLRequest*) ValidateVINForVehicles:(NSString *) userHash
                                           vin:(NSString*)vin
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ValidateVinJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "</ValidateVinJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,vin];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ValidateVinJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ListSavedVINScansJSON Web Service

+(NSMutableURLRequest*)gettingSavedVINForVehicles:(NSString *) userHash
                                         clientID:(NSString*)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListSavedVINScansJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%@</clientID>"
                             "</ListSavedVINScansJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListSavedVINScansJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ListVehicletypeJSON Web Service

+(NSMutableURLRequest *) fectchListVehicleTypeForUserhash:(NSString *) userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVehicletypeJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ListVehicletypeJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVehicletypeJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Add Vehicle Web Service

+(NSMutableURLRequest*) AddVehicleFoUserhash:(NSString *) userHash
                                    ClientID:(int) iClientID
                                      Colour:(NSString *) Colour
                                    Comments:(NSString *) Comments
                                   Condition:(NSString *) Condition
                                DeleteReason:(NSString *) DeleteReason
                                DepartmentID:(int) DepartmentID
                                    EngineNo:(NSString *) EngineNo
                                      Extras:(NSString *) Extras
                          FullServiceHistory:(Boolean)    FullServiceHistory
                                IgnoreImport:(Boolean) IgnoreImport
                                InternalNote:(NSString *) InternalNote
                                   IsDeleted:(Boolean) IsDeleted
                                   IsProgram:(Boolean) IsProgram
                                    IsRetail:(Boolean) IsRetail
                                    IsTender:(Boolean) IsTender
                                     IsTrade:(Boolean ) IsTrade
                                    Location:(NSString *) Location
                                      MMCode:(NSString *) MMCode
                       ManufacturerModelCode:(NSString *) ManufacturerModelCode
                                     Mileage:(int) Mileage
                                OriginalCost:(double) OriginalCost
                                    Override:(Boolean) Override
                              OverrideReason:(NSString *) OverrideReason
                             PlusAccessories:(double ) PlusAccessories
                                   PlusAdmin:(double ) PlusAdmin
                                 PlusMileage:(double) PlusMileage
                                   PlusRecon:(double ) PlusRecon
                                       Price:(double) Price
                                 ProgramName:(NSString *) ProgramName
                                Registration:(NSString *) Registration
                         ShowErrorDisclaimer:(Boolean) ShowErrorDisclaimer
                                     Standin:(double) Standin
                                   StockCode:(NSString *) StockCode
                                 TouchMethod:(NSString *) TouchMethod
                                  TradePrice:(double) TradePrice
                                        Trim:(NSString *) Trim
                          UsedVehicleStockID:(int) UsedVehicleStockID
                                    UsedYear:(int) UsedYear
                                         VIN:(NSString *) VIN
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<s:Body>"
                             "<AddVehicleViaObj xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicleObject xmlns:d4p1=\"http://schemas.datacontract.org/2004/07/StockServiceNS\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"
                             "<d4p1:Colour>%@</d4p1:Colour>"
                             "<d4p1:Comments>%@</d4p1:Comments>"
                             "<d4p1:Condition>%@</d4p1:Condition>"
                             "<d4p1:DeleteReason>%@</d4p1:DeleteReason>"
                             "<d4p1:DepartmentID>%d</d4p1:DepartmentID>"
                             "<d4p1:EngineNo>%@</d4p1:EngineNo>"
                             "<d4p1:Extras>%@</d4p1:Extras>"
                             "<d4p1:FullServiceHistory>%hhu</d4p1:FullServiceHistory>"
                             "<d4p1:IgnoreImport>%d</d4p1:IgnoreImport>"
                             "<d4p1:InternalNote>%@</d4p1:InternalNote>"
                             "<d4p1:IsDeleted>%d</d4p1:IsDeleted>"
                             "<d4p1:IsProgram>%d</d4p1:IsProgram>"
                             "<d4p1:IsRetail>%d</d4p1:IsRetail>"
                             "<d4p1:IsTender>%d</d4p1:IsTender>"
                             "<d4p1:IsTrade>%d</d4p1:IsTrade>"
                             "<d4p1:Location>%@</d4p1:Location>"
                             "<d4p1:MMCode>%@</d4p1:MMCode>"
                             "<d4p1:ManufacturerModelCode>%@</d4p1:ManufacturerModelCode>"
                             "<d4p1:Mileage>%d</d4p1:Mileage>"
                             "<d4p1:OriginalCost>%f</d4p1:OriginalCost>"
                             "<d4p1:Override>%d</d4p1:Override>"
                             "<d4p1:OverrideReason >%@</d4p1:OverrideReason>"
                             "<d4p1:PlusAccessories>%f</d4p1:PlusAccessories>"
                             "<d4p1:PlusAdmin>%f</d4p1:PlusAdmin>"
                             "<d4p1:PlusMileage>%f</d4p1:PlusMileage>"
                             "<d4p1:PlusRecon>%f</d4p1:PlusRecon>"
                             "<d4p1:Price>%f</d4p1:Price>"
                             "<d4p1:ProgramName>%@</d4p1:ProgramName>"
                             "<d4p1:Registration>%@</d4p1:Registration>"
                             "<d4p1:ShowErrorDisclaimer>%hhu</d4p1:ShowErrorDisclaimer>"
                             "<d4p1:Standin>%f</d4p1:Standin>"
                             "<d4p1:StockCode>%@</d4p1:StockCode>"
                             "<d4p1:TouchMethod>%@</d4p1:TouchMethod>"
                             "<d4p1:TradePrice>%f</d4p1:TradePrice>"
                             "<d4p1:Trim>%@</d4p1:Trim>"
                             "<d4p1:UsedVehicleStockID>%d</d4p1:UsedVehicleStockID>"
                             "<d4p1:UsedYear>%d</d4p1:UsedYear>"
                             "<d4p1:VIN>%@</d4p1:VIN>"
                             "</vehicleObject>"
                             "</AddVehicleViaObj>"
                             "</s:Body>"
                             "</s:Envelope>",WEB_SERVICE_TEMPURI,userHash,iClientID,Colour,Comments,Condition,DeleteReason,DepartmentID,EngineNo,Extras,FullServiceHistory,IgnoreImport,InternalNote,IsDeleted,IsProgram,IsRetail,IsTender,IsTrade,Location,MMCode,ManufacturerModelCode,Mileage,OriginalCost,Override,OverrideReason,PlusAccessories,PlusAdmin,PlusMileage,PlusRecon,Price,ProgramName,Registration,ShowErrorDisclaimer,Standin,StockCode,TouchMethod,TradePrice,Trim,UsedVehicleStockID,UsedYear,VIN];
    
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddVehicleViaObj",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*) gettingAllVarintsvaluesForSpecials:(NSString *) userHash
                                                      Year:(NSString*)year
                                                   modelId:(int)modelId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetVehicleVariantByModelIdJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<id>%d</id>"
                             "<year>%@</year>"
                             "</GetVehicleVariantByModelIdJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,modelId,year];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetVehicleVariantByModelIdJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Update Vehicle Web Service

+(NSMutableURLRequest*) updateVehicleInfomationIfAlreadyInStock:(NSString *) userHash
                                                         Colour:(NSString *) Colour
                                                       Comments:(NSString *) Comments
                                                      Condition:(NSString *) Condition
                                                   DeleteReason:(NSString *) DeleteReason
                                                   DepartmentID:(int) DepartmentID
                                                       EngineNo:(NSString *) EngineNo
                                                         Extras:(NSString *) Extras
                                             FullServiceHistory:(Boolean) FullServiceHistory
                                                   IgnoreImport:(Boolean) IgnoreImport
                                                   InternalNote:(NSString *) InternalNote
                                                      IsDeleted:(Boolean) IsDeleted
                                                      IsProgram:(Boolean) IsProgram
                                                       IsRetail:(Boolean) IsRetail
                                                       IsTender:(Boolean) IsTender
                                                        IsTrade:(Boolean ) IsTrade
                                                       Location:(NSString *) Location
                                                         MMCode:(NSString *) MMCode
                                          ManufacturerModelCode:(NSString *) ManufacturerModelCode
                                                        Mileage:(int) Mileage
                                                   OriginalCost:(double) OriginalCost
                                                       Override:(Boolean) Override
                                                 OverrideReason:(NSString *) OverrideReason
                                                PlusAccessories:(double ) PlusAccessories
                                                      PlusAdmin:(double ) PlusAdmin
                                                    PlusMileage:(double) PlusMileage
                                                      PlusRecon:(double ) PlusRecon
                                                          Price:(double) Price
                                                    ProgramName:(NSString *) ProgramName
                                                   Registration:(NSString *) Registration
                                            ShowErrorDisclaimer:(Boolean) ShowErrorDisclaimer
                                                        Standin:(double) Standin
                                                      StockCode:(NSString *) StockCode
                                                    TouchMethod:(NSString *) TouchMethod
                                                     TradePrice:(double) TradePrice
                                                           Trim:(NSString *) Trim
                                             UsedVehicleStockID:(int) UsedVehicleStockID
                                                       UsedYear:(int) UsedYear
                                                            VIN:(NSString *) VIN
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateVehicleViaObj xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<vehicleObject xmlns:a=\"http://schemas.datacontract.org/2004/07/StockServiceNS\" xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\">"
                             "<a:Colour>%@</a:Colour>"
                             "<a:Comments>%@</a:Comments>"
                             "<a:Condition>%@</a:Condition>"
                             "<a:DeleteReason>%@</a:DeleteReason>"
                             "<a:DepartmentID>%d</a:DepartmentID>"
                             "<a:EngineNo>%@</a:EngineNo>"
                             "<a:Extras>%@</a:Extras>"
                             "<a:FullServiceHistory>%hhu</a:FullServiceHistory>"
                             "<a:IgnoreImport>%d</a:IgnoreImport>"
                             "<a:InternalNote>%@</a:InternalNote>"
                             "<a:IsDeleted>%d</a:IsDeleted>"
                             "<a:IsProgram>%d</a:IsProgram>"
                             "<a:IsRetail>%d</a:IsRetail>"
                             "<a:IsTender>%d</a:IsTender>"
                             "<a:IsTrade>%d</a:IsTrade>"
                             "<a:Location>%@</a:Location>"
                             "<a:MMCode>%@</a:MMCode>"
                             "<a:ManufacturerModelCode>%@</a:ManufacturerModelCode>"
                             "<a:Mileage>%d</a:Mileage>"
                             "<a:OriginalCost>%f</a:OriginalCost>"
                             "<a:Override>%d</a:Override>"
                             "<a:OverrideReason>%@</a:OverrideReason>"
                             "<a:PlusAccessories>%f</a:PlusAccessories>"
                             "<a:PlusAdmin>%f</a:PlusAdmin>"
                             "<a:PlusMileage>%f</a:PlusMileage>"
                             "<a:PlusRecon>%f</a:PlusRecon>"
                             "<a:Price>%f</a:Price>"
                             "<a:ProgramName>%@</a:ProgramName>"
                             "<a:Registration>%@</a:Registration>"
                             "<a:ShowErrorDisclaimer>%hhu</a:ShowErrorDisclaimer>"
                             "<a:Standin>%f</a:Standin>"
                             "<a:StockCode>%@</a:StockCode>"
                             "<a:TouchMethod>%@</a:TouchMethod>"
                             "<a:TradePrice>%f</a:TradePrice>"
                             "<a:Trim>%@</a:Trim>"
                             "<a:UsedVehicleStockID>%d</a:UsedVehicleStockID>"
                             "<a:UsedYear>%d</a:UsedYear>"
                             "<a:VIN>%@</a:VIN>"
                             "</vehicleObject>"
                             "</UpdateVehicleViaObj>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,Colour,Comments,Condition,DeleteReason,DepartmentID,EngineNo,Extras,FullServiceHistory,IgnoreImport,InternalNote,IsDeleted,IsProgram,IsRetail,IsTender,IsTrade,Location,MMCode,ManufacturerModelCode,Mileage,OriginalCost,Override,OverrideReason,PlusAccessories,PlusAdmin,PlusMileage,PlusRecon,Price,ProgramName,Registration,ShowErrorDisclaimer,Standin,StockCode,TouchMethod,TradePrice,Trim,UsedVehicleStockID,UsedYear,VIN];
    
    
    
    NSLog(@"UPDATE ******** Soap Message:%@",soapMessage);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/UpdateVehicleViaObj",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ListTenderJSON Web Service

+(NSMutableURLRequest*) lisAddToTenderForUserhash:(NSString* ) userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListTenderJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ListTenderJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    DLog(@"Soap Message For tender: %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListTenderJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - LoadSpecialTypes For Vehicle Web Service

+(NSMutableURLRequest *) gettingALlSpeacialTypeListing:(NSString *) strUserHash withClientID:(int) iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadSpecialTypesXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "</LoadSpecialTypesXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID];
    
    // NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadSpecialTypesXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *) getSpecialVehiclesListing:(NSString *) strUserHash withClientID:(int) iClientID withVehicleType:(NSString*)vehicleType
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVehicleByClientXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<vehicleType>%@</vehicleType>"
                             "</ListVehicleByClientXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,vehicleType];
    
    // NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVehicleByClientXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


#pragma mark - GetAllActiveSpecials For Vehicle Web Service

+(NSMutableURLRequest *) gettingAllActiveSpecialListing:(NSString *) strUserHash withClientID:(int) iClientID withStartAt:(int) iStartAt withTake:(int)iTake
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetAllActiveSpecialsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<startAt>%d</startAt>"
                             "<take>%d</take>"
                             "</GetAllActiveSpecialsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,iStartAt,iTake];
    
    DLog(@"gettingAllActiveSpecialListing -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetAllActiveSpecialsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - GetAllExpiredSpecials For Vehicle Web Service

+(NSMutableURLRequest *) gettingAllExpiredSpecialListing:(NSString *) strUserHash withClientID:(int) iClientID withStartAt:(int) iStartAt withTake:(int)iTake
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetAllExpiredSpecialsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<startAt>%d</startAt>"
                             "<take>%d</take>"
                             "</GetAllExpiredSpecialsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,iStartAt,iTake];
    
    DLog(@"gettingAllExpiredSpecialListing -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetAllExpiredSpecialsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *) gettingAllUnPublishedSpecialListing:(NSString *) strUserHash withClientID:(int) iClientID withStartAt:(int) iStartAt withTake:(int)iTake
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetAllUnPublishedSpecialsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<startAt>%d</startAt>"
                             "<take>%d</take>"
                             "</GetAllUnPublishedSpecialsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,iStartAt,iTake];
    
    NSLog(@"gettingAllUnPublishedSpecialListing -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetAllUnPublishedSpecialsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *) editSpecial:(NSString *) strUserHash withClientID:(int) iClientID withSpecialID:(int)specialID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSpecialXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<autoSpecialId>%d</autoSpecialId>"
                             "</GetSpecialXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,specialID];
    
    DLog(@"editSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetSpecialXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *) deleteSpecial:(NSString *) strUserHash withSpecialID:(int)specialID withIsExpired:(BOOL) isExpired
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<DeleteSpecial xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<autoSpecialId>%d</autoSpecialId>"
                             "<isExpired>%d</isExpired>"
                             "</DeleteSpecial>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,specialID,isExpired];
    
    DLog(@"deleteSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/DeleteSpecial",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *) publishSpecial:(NSString *) strUserHash withClientID:(int) iClientID withSpecialID:(int)specialID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<PublishSpecial xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<autoSpecialId>%d</autoSpecialId>"
                             "</PublishSpecial>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,specialID];
    
    DLog(@"editSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/PublishSpecial",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


+(NSMutableURLRequest *)  createSpecial:(NSString *)        struserHash
                           withClientID:(int)                iClientID
                      withSpecialTypeID:(int)           iSpecialTypeId
                   withDateSpecialStart:(NSString *) strDateSpecialStart
                      withendSpecialEnd:(NSString *)    strEndendSpecialEnd
                             withItemID:(int)                  iStrItemID
                          withvariantID:(int)               ivariantID
                            withModelID:(int)                 iModelID
                             withMakeID:(int)                  iMakeID
                       withspecialPrice:(NSString *)         specialPrice
                        withnormalPrice:(NSString *)      normalPrice
                            withDetails:(NSString *)          strdetails
                            withSummary:(NSString *)          strsummary
                         withallowGroup:(Boolean)             strallowGroup
                         withcorrection:(Boolean)             withcorrection
                          withSpecailID:(int)               withspecialId
                          withItemValue:(NSString *)          strItemValue
                               withYear:(NSString*)                      strYear
{
    
    
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveSpecial xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<specialTypeId>%d</specialTypeId>"
                             "<dateSpecialStart>%@</dateSpecialStart>"
                             "<endSpecialEnd>%@</endSpecialEnd>"
                             "<usedVehicleStockId>%d</usedVehicleStockId>"
                             "<variantID>%d</variantID>"
                             "<modelID>%d</modelID>"
                             "<makeID>%d</makeID>"
                             "<specialPrice>%@</specialPrice>"
                             "<normalPrice>%@</normalPrice>"
                             "<details>%@</details>"
                             "<title>%@</title>"
                             "<allowGroup>%hhu</allowGroup>"
                             "<correction>%hhu</correction>"
                             "<specialId>%d</specialId>"
                             "<itemValue>%@</itemValue>"
                             "<year>%@</year>"
                             "</SaveSpecial>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,struserHash,iClientID,iSpecialTypeId,strDateSpecialStart,strEndendSpecialEnd,iStrItemID,ivariantID,iModelID,iMakeID,specialPrice,normalPrice,strdetails,strsummary,strallowGroup,withcorrection,withspecialId,strItemValue,strYear];
    
    NSLog(@"Create SOAP  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveSpecial",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


#pragma mark - GetSpecialImagesBySpecialID For Vehicle Web Service

+(NSMutableURLRequest *)getSpecialImagesBySpecialIDWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withSpecailID:(int)specialID
{
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSpecialImagesBySpecialID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<specialID>%d</specialID>"
                             "</GetSpecialImagesBySpecialID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,specialID];
    
    DLog(@"DeleteSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetSpecialImagesBySpecialID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *) GetSpecialBySpecialID:(NSString *) strUserHash withClientID:(int)intClientID withSpecialID:(int)specialID
{
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSpecialBySpecialID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<specialID>%d</specialID>"
                             "</GetSpecialBySpecialID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,intClientID,specialID];
    
    DLog(@"GetSpecialImage -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetSpecialBySpecialID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
#pragma mark - Adding Image For Special

+(NSMutableURLRequest *)  SaveSpecialWithImage:(NSString *) struserHash
                                  withClientID:(int) iClientID
                                 withspecialID:(int) iSpeciaID
                          withoriginalFileName:(NSString *) strFileName
                        withBaseEncodingString:(NSString *) strbase64ImageString

{
    
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveSpecialsImage xmlns=\"http://tempuri.org/\">"
                             "<userHash>%@</userHash>"
                             "<autoSpecialId>%d</autoSpecialId>"
                             "<coreClientID>%d</coreClientID>"
                             "<originalFileName>%@</originalFileName>"
                             "<base64ImageString>%@</base64ImageString>"
                             "</SaveSpecialsImage>"
                             "</Body>"
                             "</Envelope>",struserHash,iSpeciaID,iClientID,strFileName,strbase64ImageString];
    
    //  NSLog(@"Create SOAP  : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveSpecialsImage",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}




+(NSMutableURLRequest *) deleteSpecial:(NSString *) strUserHash withClientID:(NSString *)strClientID withSpecialID:(NSString *) specialID withCurrentUserID:(NSString *)strCurrentID
{
    
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<DeleteSpecial xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "<specialId>%d</specialId>"
                             "<currentUserID>%d</currentUserID>"
                             "</DeleteSpecial>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,strClientID.intValue,specialID.intValue,strCurrentID.intValue];
    
    DLog(@"DeleteSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/DeleteSpecial",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *) deleteSpecialImage:(NSString *) strUserHash withSpecialID:(int) specialImageID
{
    
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<DeleteSpecialsImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<imageId>%d</imageId>"
                             "</DeleteSpecialsImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,specialImageID];
    
    DLog(@"DeleteSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/DeleteSpecialsImage",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
#pragma mark - UpdateSpecialImagePriority For Special

+(NSMutableURLRequest *) updateSpecialImagePriority:(NSString* ) strUserHash withSpecialImageID:(int)specialImageID withLinkImagePriority:(int)linkImagePriority
{
    NSString *soapMessage = [NSString stringWithFormat:@"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveSpecialsImagePriority xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<imageId>%d</imageId>"
                             "<priority>%d</priority>"
                             "</SaveSpecialsImagePriority>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,specialImageID,linkImagePriority];
    
    DLog(@"DeleteSpecial -:Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self specialWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveSpecialsImagePriority",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISPECIAL_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
#pragma mark - GetAllListOfUsedVehicleInStock For Vehicle Web Service

/*+(NSMutableURLRequest *) getAllListOfUsedVechicleInStock:(NSString *) strUserHash withClientID:(int) iclientID wihtMakeID:(int) iMakeID withModelId:(int) iModelId withVariantID:(int) iVariantID withSpecialTypeLoaded:(NSString *) strLoadedSpecialType
 {
 
 if ([strLoadedSpecialType isEqualToString:@"Used Vehicle (In Stock)"])
 {
 NSString *soapMessage = [NSString stringWithFormat:
 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
 "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
 "<Body>"
 "<GetAllListOfUsedVehicleInStock xmlns=\"%@/\">"
 "<userHash>%@</userHash>"
 "<coreClientID>%d</coreClientID>"
 "<makeID>%d</makeID>"
 "<modelID>%d</modelID>"
 "<variantID>%d</variantID>"
 "</GetAllListOfUsedVehicleInStock>"
 "</Body>"
 "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iclientID,iMakeID,iModelId,iVariantID];
 
 NSLog(@"GetAllListOfUsedVehicleInStock -:Soap Message : %@",soapMessage);
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
 NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
 
 [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
 [request addValue:[NSString stringWithFormat:@"%@/%@/GetAllListOfUsedVehicleInStock",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
 [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
 
 return request;
 }
 else
 {
 
 NSString *soapMessage = [NSString stringWithFormat:
 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
 "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
 "<Body>"
 "<GetAllListOfNewVehicleInStock xmlns=\"%@/\">"
 "<userHash>%@</userHash>"
 "<coreClientID>%d</coreClientID>"
 "<makeID>%d</makeID>"
 "<modelID>%d</modelID>"
 "<variantID>%d</variantID>"
 "</GetAllListOfNewVehicleInStock>"
 "</Body>"
 "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iclientID,iMakeID,iModelId,iVariantID];
 
 DLog(@"GetAllListOfUsedVehicleInStock -:Soap Message : %@",soapMessage);
 
 NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
 NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
 
 [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
 [request addValue:[NSString stringWithFormat:@"%@/%@/GetAllListOfNewVehicleInStock",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
 [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
 [request setHTTPMethod:@"POST"];
 [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
 
 return request;
 }
 
 
 return 0;
 }
 
 */
// *********************************** END FOR VEHICLES MODULE *******************************


//  START FOR PHOTOS & EXTRAS MODULE Sandeep*

#pragma mark - ListVehiclesByStatusXML For Vehicle Web Service

+(NSMutableURLRequest *) gettingVehiclePhotosAndExtrasList:(NSString *) strUserHash withstatusID :(int) iStatusID withClientID:(int) iClientID withPageSize:(int) iPageSize withPageNumber:(int) iPageNumber sort:(NSString *)sort andNewUsed:(NSString *) newUsedVehicle
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVehiclesByStatusXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<statusID>%d</statusID>"
                             "<pageSize>%d</pageSize>"
                             "<pageNumber>%d</pageNumber>"
                             "<sort>%@</sort>"
                             "<newUsed>%@</newUsed>"
                             "</ListVehiclesByStatusXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,iClientID,iStatusID,iPageSize,iPageNumber,sort, newUsedVehicle];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    //ListSavedVINScansJSON
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVehiclesByStatusXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - AddImageToVehicleBase64 For Vehicle Web Service

+(NSMutableURLRequest *)addImageToVehicleBase64ForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageBase64:(NSString *)imageBase64 imageName:(NSString *)imageName imageTitle:(NSString *)imageTitle imageSource:(NSString *)imageSource imagePriority:(int)imagePriority imageIsEtched:(BOOL)imageIsEtched imageIsBranded:(BOOL)imageIsBranded imageAngle:(NSString *)imageAngle
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddImageToVehicleBase64 xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<imageBase64>%@</imageBase64>"
                             "<imageName>%@</imageName>"
                             "<imageTitle>%@</imageTitle>"
                             "<imageSource>%@</imageSource>"
                             "<imagePriority>%d</imagePriority>"
                             "<imageIsEtched>%d</imageIsEtched>"
                             "<imageIsBranded>%d</imageIsBranded>"
                             "<imageAngle>%@</imageAngle>"
                             "</AddImageToVehicleBase64>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,usedVehicleStockID,imageBase64,imageName,imageTitle,imageSource,imagePriority,imageIsEtched,imageIsBranded,imageAngle];
    
    DLog(@" IMAGE UPLOADING  Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddImageToVehicleBase64",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ListVehicleImagesXML For Vehicle Web Service

+(NSMutableURLRequest *)gettingListOfVehiclesImagesListForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVehicleImagesXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "</ListVehicleImagesXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,usedVehicleStockID];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVehicleImagesXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ChangeImagePriorityForVehicle For Vehicle Web Service

+(NSMutableURLRequest *)changeVehicleImagePriorityForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageID:(int)imageID newPriorityID:(int)newPriorityID
{
    DLog(@"newPriorityID %d",newPriorityID);
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ChangeImagePriorityForVehicle xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<imageID>%ld</imageID>"
                             "<newPriorityID>%d</newPriorityID>"
                             "</ChangeImagePriorityForVehicle>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,usedVehicleStockID,(long)imageID,newPriorityID];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ChangeImagePriorityForVehicle",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - RemoveImageFromVehicle For Vehicle Web Service

+(NSMutableURLRequest *)removeCommentImageFromVehicleWithUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID imageID:(int)imageID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveImageFromVehicle xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<imageID>%d</imageID>"
                             "</RemoveImageFromVehicle>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,usedVehicleStockID,imageID];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RemoveImageFromVehicle",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - UpdateVehicleExtrasAndComments For Vehicle Web Service

+(NSMutableURLRequest *)updateVehicleExtrasAndCommentsForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID comments:(NSString *)comments extras:(NSString *)extras
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateVehicleExtrasAndComments xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<comments>%@</comments>"
                             "<extras>%@</extras>"
                             "</UpdateVehicleExtrasAndComments>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,usedVehicleStockID,comments,extras];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/UpdateVehicleExtrasAndComments",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - LoadVehicleDetailsXML For Vehicle Web Service

+(NSMutableURLRequest *)gettingLoadVehiclesImagesListForUserHash:(NSString *)userHash usedVehicleStockID:(int)usedVehicleStockID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVehicleDetailsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "</LoadVehicleDetailsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,usedVehicleStockID];
    
    NSLog(@"Soap Message FOr Load vehicle : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadVehicleDetailsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *)listVariantsWithFlagForUserHash:(NSString *)userHash andClientID:(int) clientID andYear:(int) year andModelID:(int) modelID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVariantsWithFlagXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<year>%d</year>"
                             "<modelID>%d</modelID>"
                             "</ListVariantsWithFlagXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,year,modelID];
    
    NSLog(@"Soap Message FOr Load vehicle : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVariantsWithFlagXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


+(NSMutableURLRequest*) gettingDetailsForEditStockVehicles:(NSString *) userHash
                                                 variantId:(int)variantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<VariantDetailsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "</VariantDetailsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantId];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/VariantDetailsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


// Removing/Discarsing the VIN scan

#pragma mark - RemoveVINScan For Vehicle Web Service

+(NSMutableURLRequest*) removeVINscan:(NSString *) strUserHash withClientID:(int) strClientID withSaveScanID:(int) strsaveScanID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveVINScan xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<SavedScanID>%d</SavedScanID>"
                             "</RemoveVINScan>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,strClientID,strsaveScanID];
    
    //  NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RemoveVINScan",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}



// **** END FOR PHOTOS & EXTRAS MODULE


#pragma mark - Start of Trader Sell Module

// added by ketan

// ********** Start of Trader Sell Module *******

#pragma mark - Get Search List For Vehicle Web Service

+(NSMutableURLRequest*) gettingSearchListingVehicle:(NSString *) strUserHash withClientID:(int) iClientId withMinYear:(int) iMinYear withMaxYear:(int) iMaxYear withMakeId:(int) iMakeId withModelID:(int) iModelID withVariant:(int) iVariantID withCount:(int) iCount withPage:(int) iPage withIsTrade:(BOOL) isTrade isTender:(BOOL)isTender isPrivate:(BOOL)isPrivate isFactory:(BOOL) isFactory andSortText:(NSString*)sortText
{
    // iIsSeparateTotal = 1;
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<Search xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<MinYear>%d</MinYear>"
                             "<MaxYear>%d</MaxYear>"
                             "<Make>%d</Make>"
                             "<Model>%d</Model>"
                             "<Variant>%d</Variant>"
                             "<Province>-1</Province>"
                             "<Count>%d</Count>"
                             "<Page>%d</Page>"
                             "<bTrade>%d</bTrade>"
                             "<bTender>%d</bTender>"
                             "<bPrivate>%d</bPrivate>"
                             "<bFactory>%d</bFactory>"
                             "<SeperateTotal>1</SeperateTotal>"
                             "<Sort>%@</Sort>"
                             "</Search>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientId,iMinYear,iMaxYear,iMakeId,iModelID,iVariantID,iCount,iPage,isTrade,isTender,isPrivate,isFactory,sortText];
    
    NSLog(@"****** Soap Message------- : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/Search",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - LoadVehicle Web Service

+(NSMutableURLRequest *) gettingDetailsVehicleImages:(NSString *) strUserHash withClientID:(int) iClientId withVehicleId:(int) iVehicleID
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVehicle xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Vehicle>%d</Vehicle>"
                             "</LoadVehicle>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientId,iVehicleID];
    //  NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadVehicle",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Buy Vehicle Web Service

+(NSMutableURLRequest *) buyVehicle:(NSString *) strUserHash withClientId:(int) iClientID withUserID:(int) userId withVehicleID:(int) iVehicleID strAmount:(NSString *) strAmount
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<BuyNow xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<UserID>%d</UserID>"
                             "<Vehicle>%d</Vehicle>"
                             "<Amount>%@</Amount>"
                             "</BuyNow>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,userId,iVehicleID,strAmount];
    
    DLog(@"---- soap message %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/BuyNow",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Place Bid For Trader Web Service

+(NSMutableURLRequest *) placeBid:(NSString *) strUserHash withClientID:(int) iClientID withUserID:(int) userId withVehicleID:(int) iVehicleID withAmount:(NSString *) strAmount
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<Bid xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<UserID>%d</UserID>"
                             "<Vehicle>%d</Vehicle>"
                             "<Amount>%@</Amount>"
                             "</Bid>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,userId,iVehicleID,strAmount];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/Bid",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Place Automated Bidding For Trader Web Service

+(NSMutableURLRequest *) placeAutomatedBidding:(NSString *) strUserHash withClientID:(int) iClientID withUserID:(int) userId withVehicleID:(int) iVehicleID withAmount:(int) strAmount withBidLimit:(int) bidLimit
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AutoBid xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<UserID>%d</UserID>"
                             "<Vehicle>%d</Vehicle>"
                             "<Amount>%d</Amount>"
                             "<Limit>%d</Limit>"
                             "</AutoBid>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,userId,iVehicleID,strAmount,bidLimit];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AutoBid",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - RemoveAutoBids For Trader Web Service

+(NSMutableURLRequest *)removingAutoBidCapWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveAutoBids xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicle>%d</vehicle>"
                             "</RemoveAutoBids>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,iVehicleID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RemoveAutoBids",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For Get Counts for Sells For Trader

+(NSMutableURLRequest *)getCountsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetCounts xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetCounts>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetCounts",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For AcceptBid For Trader

+(NSMutableURLRequest *)acceptBidTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID withBidValue:(int)iBidValue
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AcceptBid xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicle>%d</vehicle>"
                             "<bid>%d</bid>"
                             "</AcceptBid>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,iVehicleID,iBidValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AcceptBid",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For ActionRequired For Trader

+(NSMutableURLRequest *)actionRequiredWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ActionRequired xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</ActionRequired>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ActionRequired",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For AvailableToTrade For Trader

+(NSMutableURLRequest *)availableToTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AvailableToTradePaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</AvailableToTradePaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AvailableToTradePaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For ExtendBidding For Trader

+(NSMutableURLRequest *)extendBiddingUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ExtendBidding xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicle>%d</vehicle>"
                             "</ExtendBidding>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,iVehicleID];
    
    //  NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ExtendBidding",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For ListBids For Trader

+(NSMutableURLRequest *)listBidsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListBids xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicle>%d</vehicle>"
                             "</ListBids>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,iVehicleID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListBids",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For NotAvailableToTrade For Trader

+(NSMutableURLRequest *)notAvailableToTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<NotAvailableToTradePaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</NotAvailableToTradePaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/NotAvailableToTradePaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For RejectBid For Trader

+(NSMutableURLRequest *)rejectBidTradeUserHash:(NSString *)strUserHash withClientID:(int)iClientID withVehicleID:(int)iVehicleID withBidValue:(int)iBidValue
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RejectBid xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicle>%d</vehicle>"
                             "<bid>%d</bid>"
                             "</RejectBid>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,iVehicleID,iBidValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RejectBid",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For ListActiveBids For Trader

+(NSMutableURLRequest *)listActiveBidsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ActiveBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</ActiveBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ActiveBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For TradePeriodEnded For Trader

+(NSMutableURLRequest *)tradePeriodEndedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<TradePeriodEndedPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</TradePeriodEndedPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/TradePeriodEndedPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For Get BuyingCounts for Sells For Trader

+(NSMutableURLRequest *)getBuyingCountsWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetBuyingCounts xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "</GetBuyingCounts>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetBuyingCounts",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For WinningBids For My Bids in Trader

+(NSMutableURLRequest *)winningBidsPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<WinningBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</WinningBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/WinningBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For LosingBids For My Bids in Trader

+(NSMutableURLRequest *)losingBidsPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LosingBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</LosingBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LosingBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *)AutomatedBidsPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AutoBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</AutoBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,page,pageSize];
    
    // NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AutoBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For BidsWonPaged For My Bids in Trader

+(NSMutableURLRequest *)bidsWonPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<BidsWonPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</BidsWonPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate,page,pageSize];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/BidsWonPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - For BidsLostPaged For My Bids in Trader

+(NSMutableURLRequest *)bidsLostPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<BidsLostPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</BidsLostPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/BidsLostPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *)bidsPrivatePagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<PrivateBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</PrivateBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/PrivateBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *)bidsCancelledPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<CancelledBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</CancelledBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/CancelledBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *)bidsWithdrawnPagedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate withPage:(int)page withPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<WithdrawnBidsPaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</WithdrawnBidsPaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate,page,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/WithdrawnBidsPaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
#pragma mark -


+(NSMutableURLRequest *)bidsLostCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<BidsLostCount xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "</BidsLostCount>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/BidsLostCount",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest *)bidsWonCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withFrom:(NSString*)fromDate withTo:(NSString*)toDate
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<BidsWonCount xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "</BidsWonCount>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,fromDate,toDate];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/BidsWonCount",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest *)bidsLoosingCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LosingBidsCount xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</LosingBidsCount>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LosingBidsCount",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest *)bidsWinningCountWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<WinningBidsCount xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</WinningBidsCount>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/WinningBidsCount",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
#pragma mark - Get Make For Wanted

+(NSMutableURLRequest *)getMakeWithUserHash:(NSString *)strUserHash withFromYear:(int)fromYear withToYear:(int)toYear
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListMakesXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<fromYear>%d</fromYear>"
                             "<toYear>%d</toYear>"
                             "</ListMakesXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,fromYear,toYear];
    
    //  NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListMakesXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get Model For Wanted

+(NSMutableURLRequest *)getModelWithUserHash:(NSString *)strUserHash withMakeID:(int)makeID withFromYear:(int)fromYear withToYear:(int)toYear
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListModelsXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<makeID>%d</makeID>"
                             "<fromYear>%d</fromYear>"
                             "<toYear>%d</toYear>"
                             "</ListModelsXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,makeID,fromYear,toYear];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListModelsXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Get Variant For Wanted

+(NSMutableURLRequest *)getVariantWithUserHash:(NSString *)strUserHash withModelID:(int)modelID withFromYear:(int)fromYear withToYear:(int)toYear
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVariantsXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%d</modelID>"
                             "<fromYear>%d</fromYear>"
                             "<toYear>%d</toYear>"
                             "</ListVariantsXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,modelID,fromYear,toYear];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListVariantsXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ListActiveWantedSearch

+(NSMutableURLRequest *)listActiveWantedSearchWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActiveWantedSearchXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "</ListActiveWantedSearchXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListActiveWantedSearchXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - ListActiveWantedSearchWithCountXML

+(NSMutableURLRequest *)listActiveWantedSearchWithCountXMLWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActiveWantedSearchWithCountXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<coreClientID>%d</coreClientID>"
                             "</ListActiveWantedSearchWithCountXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListActiveWantedSearchWithCountXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - SearchResultCount

+(NSMutableURLRequest *)searchResultCountWithUserHash:(NSString *)strUserHash withWantedSearchID:(int)wantedSearchID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SearchResultCount xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<wantedSearchID>%d</wantedSearchID>"
                             "</SearchResultCount>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,wantedSearchID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SearchResultCount",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - WantedSearchResultXML

+(NSMutableURLRequest *)wantedSearchResultXMLWithUserHash:(NSString *)strUserHash withWantedSearchID:(int)wantedSearchID withPageNo:(int)pageNo withCountNo:(int)countNo
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<WantedSearchResultXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<wantedSearchID>%d</wantedSearchID>"
                             "<nPage>%d</nPage>"
                             "<nCount>%d</nCount>"
                             "</WantedSearchResultXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,wantedSearchID,pageNo,countNo];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/WantedSearchResultXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - RegionList

+(NSMutableURLRequest *)getRegionListWithUserHash:(NSString *)strUserHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RegionList xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "</RegionList>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RegionList",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
#pragma mark - RemoveWanted

+(NSMutableURLRequest *)removeWantedWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withWantedSearchID:(int)wantedSearchID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveWanted xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<ID>%d</ID>"
                             "</RemoveWanted>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,wantedSearchID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RemoveWanted",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - AddToWantedList

+(NSMutableURLRequest *)addToWantedListWithUserHash:(NSString *)strUserHash withClientID:(int)iClientID withMakeID:(int)makeID withModelID:(int)modelID withVariantID:(NSString*)strVariant withProvincesID:(NSString*)strProvinces withMaxYear:(int)maxYear withMinYear:(int)minYear
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddWanted xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<Client>%d</Client>"
                             "<Make>%d</Make>"
                             "<Model>%d</Model>"
                             "<Variants>"
                             "%@"
                             "</Variants>"
                             "<Provinces>"
                             "%@"
                             "</Provinces>"
                             "<MaxYear>%d</MaxYear>"
                             "<MinYear>%d</MinYear>"
                             "</AddWanted>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],strUserHash,iClientID,makeID,modelID,strVariant,strProvinces,maxYear,minYear];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddWanted",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}


+(NSMutableURLRequest *)getTheLeadsListWithUserHash:(NSString*)userHash andClientID:(int)clientID andKeyword:(NSString*)searchKey andOrder:(int)order andPageNum:(int)pageNum andPageSize:(int)pageSize andSeenStatus:(int) iSeenStatus
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<List xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<keyword>%@</keyword>"
                             "<order>%d</order>"
                             "<page>%d</page>"
                             "<size>%d</size>"
                             "<Seen>%d</Seen>"
                             "</List>"
                             "</Body>"
                             "</Envelope>",@"Http://LeadService.ix.co.za",userHash,clientID,searchKey,order,pageNum,pageSize,iSeenStatus];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self leadWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"Http://LeadService.ix.co.za/ILeadService/List" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

+(NSMutableURLRequest *)loadTheLeadDetailWithUserHash:(NSString*)userHash andClientID:(int)clientID andLeadID:(int)leadID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadLead xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<leadID>%d</leadID>"
                             "</LoadLead>"
                             "</Body>"
                             "</Envelope>",@"Http://LeadService.ix.co.za",userHash,clientID,leadID];
    
    
    //  NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self leadWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"Http://LeadService.ix.co.za/ILeadService/LoadLead" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}




+(NSMutableURLRequest *)addNewActivity:(NSString *) userHash withClientID:(int) iClientId withLeadId:(int)iLeadID withActivityID:(int) iactivityID withChaangeStatus:(int) istatus withComment:(NSString *) strComment invoiceNum:(NSString*) invoiceNum inVoiceDate:(NSString*) invoiceDate invoiceAmount:(float)invoiceAmount invoiceTo:(NSString*) invoiceTo Salesperson:(NSString*) salesPerson stockNum:(NSString*) stockNum departmentID:(int) deptID typeID:(int) typeID GenderID:(int) genderID RaceID:(int) raceID Age:(int) age
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddSoldAndDeliveredLeadDetails xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<leadID>%d</leadID>"
                             "<Activity>%d</Activity>"
                             "<ChangeStatus>%d</ChangeStatus>"
                             "<Comment>%@</Comment>"
                             "<invoiceNumber>%@</invoiceNumber>"
                             "<invoiceDate>%@</invoiceDate>"
                             "<invoiceAmount>%f</invoiceAmount>"
                             "<invoiceTo>%@</invoiceTo>"
                             "<invoiceSalesman>%@</invoiceSalesman>"
                             "<stockNumber>%@</stockNumber>"
                             "<departmentID>%d</departmentID>"
                             "<typeID>%d</typeID>"
                             "<customerGenderID>%d</customerGenderID>"
                             "<customerRaceID>%d</customerRaceID>"
                             "<customerAge>%d</customerAge>"
                             "</AddSoldAndDeliveredLeadDetails>"
                             "</Body>"
                             "</Envelope>",@"Http://LeadService.ix.co.za",userHash,iClientId,iLeadID,iactivityID,istatus,strComment,invoiceNum,invoiceDate,invoiceAmount,invoiceTo,salesPerson,stockNum,deptID,typeID,genderID,raceID,age];
    
    //  NSLog(@"Addint New Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self leadWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"Http://LeadService.ix.co.za/ILeadService/AddSoldAndDeliveredLeadDetails" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}








+(NSMutableURLRequest *)loadAllActivitieswithusehas:(NSString *) userHash withClientID:(int) iClientId withLeadId:(int)iLeadID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ActivityOptionsForLead xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<leadID>%d</leadID>"
                             "</ActivityOptionsForLead>"
                             "</Body>"
                             "</Envelope>",@"Http://LeadService.ix.co.za",userHash,iClientId,iLeadID];
    
    
    //  NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self leadWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"Http://LeadService.ix.co.za/ILeadService/ActivityOptionsForLead" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

+(NSMutableURLRequest *)addThePhoneOrEmailActivitywithUserHash:(NSString*) userHash withClientID:(int)clientID withLeadID:(int)leadID withActivity:(int)activity withChangeStatus:(BOOL)changeStatus andWithComment:(NSString *)comment
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddActivity xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<leadID>%d</leadID>"
                             "<Activity>%d</Activity>"
                             "<ChangeStatus>%d</ChangeStatus>"
                             "<Comment>%@</Comment>"
                             "</AddActivity>"
                             "</Body>"
                             "</Envelope>",@"Http://LeadService.ix.co.za",userHash,clientID,leadID,activity,changeStatus,comment];
    
    
    // NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self leadWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"Http://LeadService.ix.co.za/ILeadService/AddActivity" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


+(NSMutableURLRequest *)getTheCustomerDetailsDLScanWithUserHash:(NSString*)userHash andClientID:(int)clientID andBase64LicenseString:(NSString*)base64String;
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<DecodeToXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<base64LicenseData>%@</base64LicenseData>"
                             "</DecodeToXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,base64String];
    
    
    NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self licenceWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/ILicense/DecodeToXML" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest *)getTheNecessaryStockAuditListWithUserHash:(NSString*)userHash andIsDone:(BOOL)isDone andIsUnmatched:(BOOL)isUnMatched andIsNotDone:(BOOL)isNotDone andClientID:(int)clientID andPageNumber:(int)pageNumber andRecordCount:(int)recordCount
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListAudits xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<Done>%d</Done>"
                             "<Unmatched>%d</Unmatched>"
                             "<NotDone>%d</NotDone>"
                             "<clientID>%d</clientID>"
                             "<Page>%d</Page>"
                             "<RecordCount>%d</RecordCount>"
                             "</ListAudits>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,isDone,isUnMatched,isNotDone,clientID,pageNumber,recordCount];
    
    
    NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockAuditWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/ListAudits" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}


+(NSMutableURLRequest *)saveStockAuditWithUserHash:(NSString*)userHash andClientID:(int)clientID andVin:(NSString*)vin andRegistration:(NSString*)registration andMake:(NSString*)make andModel:(NSString*)model andColor:(NSString*)color andEngineNum:(NSString*)engineNum andLatitude:(double)latitide andLongitude:(double)longitude andBase64VinImage:(NSString*)vinImage andBase64VehicleImage:(NSString*)vehicleImage
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveAudit xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<vin>%@</vin>"
                             "<registration>%@</registration>"
                             "<make>%@</make>"
                             "<model>%@</model>"
                             "<colour>%@</colour>"
                             "<engineNo>%@</engineNo>"
                             "<googleLatitude>%f</googleLatitude>"
                             "<googleLongitude>%f</googleLongitude>"
                             "<base64License>%@</base64License>"
                             "<base64Vehicle>%@</base64Vehicle>"
                             "</SaveAudit>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,vin,registration,make,model,color,engineNum,latitide,longitude,vinImage,vehicleImage];
    
    
    // NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockAuditWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/SaveAudit" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
    
}

+(NSMutableURLRequest *)sendTheBrochureWithUserHash:(NSString*)userHash andStockID:(int)StockID andEmailToAddress:(NSString*)emailAddress andComment:(NSString*)comment
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SendBrochure xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<EmailTo>%@</EmailTo>"
                             "<Comment>%@</Comment>"
                             "</SendBrochure>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,StockID,emailAddress,comment];
    
    
    // NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/SendBrochure" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}


+(NSMutableURLRequest*)listGroupStockVehiclesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andStatus:(int)status andPageSize:(int)pageSize andPageNumber:(int)pageNumber andSortText:(NSString*)sortText andNewUsed:(NSString*) newUsed
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListGroupVehiclesByStatusXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<statusID>%d</statusID>"
                             "<pageSize>%d</pageSize>"
                             "<pageNumber>%d</pageNumber>"
                             "<sort>%@</sort>"
                             "<newUsed>%@</newUsed>"
                             "</ListGroupVehiclesByStatusXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,status,pageSize,pageNumber,sortText, newUsed];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/ListGroupVehiclesByStatusXML" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}


+(NSMutableURLRequest*)listGroupStockVehiclesWithSearch_UserHash:(NSString *)hashValue andClientID:(int)clientID andSearchKey:(NSString *)searchKey andPageSize:(int)pageSize andPageNumber:(int)pageNumber andStatus:(int)status andSortText:(NSString *)sortText andNewUsed:(NSString*) newUsed
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListGroupVehiclesByKeywordStatusXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<keyword>%@</keyword>"
                             "<pageSize>%d</pageSize>"
                             "<pageNumber>%d</pageNumber>"
                             "<Status>%d</Status>"
                             "<sort>%@</sort>"
                             "<newUsed>%@</newUsed>"
                             "</ListGroupVehiclesByKeywordStatusXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,searchKey,pageSize,pageNumber,status,sortText,newUsed];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/ListGroupVehiclesByKeywordStatusXML" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

+(NSMutableURLRequest*)getClientCorporateGroupsCorrespondingToUserHash:(NSString*)hashValue andClientId:(int)clientID
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetClientCorprateGroups xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetClientCorprateGroups>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID];
    
    NSLog(@"clientCorporate Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetClientCorprateGroups",WEB_SERVICE_TEMPURI,WEB_SERVICE_AUTHENTICATE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getTheAuditHistoryListWithUserHash:(NSString*)hashValue andClientId:(int)clientID andPageNumber:(int)pageNum andRecordCount:(int)recordCount
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AuditHistory xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<Page>%d</Page>"
                             "<RecordCount>%d</RecordCount>"
                             "</AuditHistory>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,pageNum,recordCount];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/AuditHistory" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)getTheAuditHistoryDetailstWithUserHash:(NSString*)hashValue andClientId:(int)clientID andDay:(NSString*)selectedDay andPageNumber:(int)pageNum andRecordCount:(int)recordCount
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AuditHistoryItems xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<Day>%@</Day>"
                             "<Page>%d</Page>"
                             "<RecordCount>%d</RecordCount>"
                             "</AuditHistoryItems>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,selectedDay,pageNum,recordCount];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/AuditHistoryItems" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)sendAuditHistoryItemsCorrespondingToUserHash:(NSString*)hashValue andClientID:(int)clientID andDay:(NSString*)selectedDay andEmailAddress:(NSString*)emailAddress andAuditedFlag:(BOOL)isAudited andNotAuditedFlag:(BOOL)isNotAudited andNotMatchedFlag:(BOOL)isNotMatched
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SendAuditHistoryItems xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<Day>%@</Day>"
                             "<EmailDestination>%@</EmailDestination>"
                             "<Audited>%d</Audited>"
                             "<NotAudited>%d</NotAudited>"
                             "<NotMatched>%d</NotMatched>"
                             "</SendAuditHistoryItems>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,selectedDay,emailAddress,isAudited,isNotAudited,isNotMatched];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/SendAuditHistoryItems" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
    
}

+(NSMutableURLRequest*)saveTheDLScanDataWithUserHash:(NSString*)hashValue andClientID:(int)clientID andScanID:(int)scanID andEmailAddress:(NSString*)emailAddress andPhoneNumber:(NSString*)phoneNum
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateLicense xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<ScanID>%d</ScanID>"
                             "<EmailAddress>%@</EmailAddress>"
                             "<Telephone>%@</Telephone>"
                             "</UpdateLicense>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,scanID,emailAddress,phoneNum];
    
    
    // NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self licenceWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/ILicense/UpdateLicense" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)listTheDriverLicencesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andRecordCount:(int)recordCnt
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListLicenses xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<Page>%d</Page>"
                             "<RecordCount>%d</RecordCount>"
                             "</ListLicenses>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,pageNum,recordCnt];
    
    
    NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self licenceWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/ILicense/ListLicenses" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)removeTheSelectedDriverLicenceWithUserHash:(NSString*)hashValue andClientID:(int)clientID andScanID:(int)scanID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveLicense xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<ScanID>%d</ScanID>"
                             "</RemoveLicense>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,scanID];
    
    
    //  NSLog(@"Load Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self licenceWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/ILicense/RemoveLicense" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)uploadTheVideoFileWithInput:(NSString*)base64VideoChunk
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UploadFile xmlns=\"%@/\">"
                             "<input>%@</input>"
                             "</UploadFile>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,base64VideoChunk];
    
    
    //  NSLog(@"Video Upload Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self licenceWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IUploaderService/UploadFile" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)removeTheVideoLinkWithUserHash:(NSString *)hashValue andClientID:(int)clientID andVideoLinkID:(int)videoLinkID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UnLinkVideo xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<linkID>%d</linkID>"
                             "</UnLinkVideo>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID,videoLinkID];
    
    
    //  NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/UnLinkVideo" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

+(NSMutableURLRequest*)canUserUploadVideoWithUserHash:(NSString *)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<CanUploadVideo xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "</CanUploadVideo>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,hashValue,clientID];
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/CanUploadVideo" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

+(NSMutableURLRequest*)listTheTradeMissingPriceWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradeVehiclesMissingPrice xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</GetTradeVehiclesMissingPrice>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,pageNum,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradeVehiclesMissingPrice",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listTheTradeActivateRetailWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRetailVehiclesNotActivated xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</GetRetailVehiclesNotActivated>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,pageNum,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRetailVehiclesNotActivated",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listTheTradeMissingInfoWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPageNumber:(int)pageNum andPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetVehiclesMissingInfo xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</GetVehiclesMissingInfo>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,pageNum,pageSize];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetVehiclesMissingInfo",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)activateTheVehicleWithUserHash:(NSString*)hashValue andClientID:(int)clientID andStockID:(int)stockID andIsTrade:(BOOL)isTrade andTradePrice:(int)tradePrice
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ActivateVehicle xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<UsedvehicleStockID>%d</UsedvehicleStockID>"
                             "<IsTrade>%d</IsTrade>"
                             "<TradePrice>%d</TradePrice>"
                             "</ActivateVehicle>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,stockID,isTrade,tradePrice];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ActivateVehicle",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)setTradeReadinessWithUserHash:(NSString*)hashValue andClientID:(int)clientID andNewDay:(int)newDay andUsedRetailDay:(int)usedRetailDay andUsedDemoDay:(int)usedDemoDay
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SetTradeReadinessReminderSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<newDay>%d</newDay>"
                             "<usedRetailDay>%d</usedRetailDay>"
                             "<usedDemoDay>%d</usedDemoDay>"
                             "</SetTradeReadinessReminderSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,newDay,usedRetailDay,usedDemoDay];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SetTradeReadinessReminderSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getTradeReadinessWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradeReadinessReminderSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradeReadinessReminderSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradeReadinessReminderSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)setTradeDisplayWithUserHash:(NSString*)hashValue andClientID:(int)clientID andTradePrice:(BOOL)tradePrice andDaysInStock:(BOOL)daysInStock andAppraisal:(BOOL)appraisal
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SetTradeAdvertSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<tradePriceBreakdown>%d</tradePriceBreakdown>"
                             "<daysInStock>%d</daysInStock>"
                             "<appraisal>%d</appraisal>"
                             "</SetTradeAdvertSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,tradePrice,daysInStock,appraisal];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SetTradeAdvertSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getTradeDisplayWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradeAdvertSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradeAdvertSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradeAdvertSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)setTradeAuctionsWithUserHash:(NSString*)hashValue andClientID:(int)clientID andisAcceptBids:(BOOL)acceptBids minBidPercent:(int)minBidPercent minBidIncrease:(int)minBidIncrease buyNowPrice:(int)buyNowPrice availableFrom:(int)availableFrom availableFor:(int)availableFor noBidsExtend:(BOOL)isNoBidExtend extendPeriod:(int)extendPeriod
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SetTradeAuctionSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<acceptBids>%d</acceptBids>"
                             "<minBidPercent>%d</minBidPercent>"
                             "<minBidIncrease>%d</minBidIncrease>"
                             "<buyNowPrice>%d</buyNowPrice>"
                             "<availableFrom>%d</availableFrom>"
                             "<availableFor>%d</availableFor>"
                             "<noBidExtend>%d</noBidExtend>"
                             "<extendPeriod>%d</extendPeriod>"
                             "</SetTradeAuctionSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,acceptBids,minBidPercent,minBidIncrease,buyNowPrice,availableFrom,availableFor,isNoBidExtend,extendPeriod];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SetTradeAuctionSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getTradeAuctionsWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradeAuctionSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradeAuctionSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    // NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradeAuctionSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}


+(NSMutableURLRequest *)setSaveTradeCustomMessagesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPurchase:(NSString *)purchase andOffer:(NSString *)offer andTender:(NSString *)tender{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveTradeCustomMessages xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<purchase>%@</purchase>"
                             "<offer>%@</offer>"
                             "<tender>%@</tender>"
                             "</SaveTradeCustomMessages>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,purchase,offer,tender];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveTradeCustomMessages",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getSaveTradeCustomMessagesWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListTradeCustomMessages xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</ListTradeCustomMessages>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListTradeCustomMessages",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)setTradePriceWithUserHash:(NSString*)hashValue andClientID:(int)clientID andIncrementalPercentage:(float)percentage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SetTradePriceIncrementSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<IncrementPercent>%f</IncrementPercent>"
                             "</SetTradePriceIncrementSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,percentage];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SetTradePriceIncrementSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getTradePriceWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradePriceIncrementSetting xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradePriceIncrementSetting>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradePriceIncrementSetting",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getListTradeMembersWithUserHash:(NSString*)hashValue andClientID:(int)clientID{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListTradeMembers xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</ListTradeMembers>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListTradeMembers",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getLoadTradeMemberWithUserHash:(NSString*)hashValue andClientID:(int)clientID andMemberID:(int)memberID{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadTradeMember xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<MemberID>%d</MemberID>"
                             "</LoadTradeMember>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,memberID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadTradeMember",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *)setSaveTradeMemberWithUserHash:(NSString*)hashValue andClientID:(int)clientID andTradeMemberID:(int)tradeMemberID andMemberID:(int)memberID andMemberName:(NSString *)memberName andCanBuy:(BOOL)canBuy andCanSell:(BOOL)canSell andCanAccept:(BOOL)canAccept andCanDecline:(BOOL)canDecline andIsManager:(BOOL)isManager andIsAuditor:(BOOL)isAuditor{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveTradeMember xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<tradeMemberID>%d</tradeMemberID>"
                             "<memberID>%d</memberID>"
                             "<memberName>%@</memberName>"
                             "<canBuy>%d</canBuy>"
                             "<canSell>%d</canSell>"
                             "<canAccept>%d</canAccept>"
                             "<canDecline>%d</canDecline>"
                             "<isManager>%d</isManager>"
                             "<isAuditor>%d</isAuditor>"
                             "</SaveTradeMember>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,tradeMemberID,memberID,memberName,(int)canBuy,(int)canSell,(int)canAccept,(int)canDecline,(int)isManager,(int)isAuditor];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveTradeMember",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getTradeMyBuyersWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradePartnerSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradePartnerSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradePartnerSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getMySellersWithUserHash:(NSString*)hashValue andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradeSellerSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradeSellerSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradeSellerSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest*)removeTradeMemberWithUserHash:(NSString*)hashValue andClientID:(int)clientID andTradeMemberID:(int)tradeMemberID andMemberID:(int)memberID{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveTradeMember xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<tradeMemberID>%d</tradeMemberID>"
                             "<memberID>%d</memberID>"
                             "</RemoveTradeMember>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,tradeMemberID,memberID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RemoveTradeMember",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)SaveTradePartnerWithUserHash:(NSString*)hashValue andClientID:(int)clientID andSettingID:(int)settingID andTraderPeriod:(int)traderPeriod andAuctionAccess:(int)auctionAccess andTenderAccess:(int)tenderAccess andId:(int)ID andName:(NSString *)name andType:(NSString *)type andTypeID:(int)typeID{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveTradePartner xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<settingID>%d</settingID>"
                             "<traderPeriod>%d</traderPeriod>"
                             "<auctionAccess>%d</auctionAccess>"
                             "<tenderAccess>%d</tenderAccess>"
                             "<id>%d</id>"
                             "<name>%@</name>"
                             "<type>%@</type>"
                             "<typeID>%d</typeID>"
                             "</SaveTradePartner>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,settingID,traderPeriod,auctionAccess,tenderAccess,ID,name,type,typeID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveTradePartner",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getListTradePartnersWithUserHash:(NSString*)hashValue andClientID:(int)clientID{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetTradePartnerSettings xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "</GetTradePartnerSettings>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetTradePartnerSettings",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)removeTradePartnerWithUserHash:(NSString*)hashValue andClientID:(int)clientID andSettingID:(int)settingID andTraderPeriod:(int)traderPeriod andAuctionAccess:(int)auctionAccess andTenderAccess:(int)tenderAccess andId:(int)ID andName:(NSString *)name andType:(NSString *)type andTypeID:(int)typeID{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<RemoveTradePartner xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<settingID>%d</settingID>"
                             "<traderPeriod>%d</traderPeriod>"
                             "<auctionAccess>%d</auctionAccess>"
                             "<tenderAccess>%d</tenderAccess>"
                             "<id>%d</id>"
                             "<name>%@</name>"
                             "<type>%@</type>"
                             "<typeID>%d</typeID>"
                             "</RemoveTradePartner>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,settingID,traderPeriod,auctionAccess,tenderAccess,ID,name,type,typeID];
    
    //  NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/RemoveTradePartner",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)SaveTradePartnerSettingWithUserHash:(NSString*)hashValue andClientID:(int)clientID andEveryone:(int)everyone{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveTradePartnerSetting xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Everyone>%d</Everyone>"
                             "</SaveTradePartnerSetting>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,(int)everyone];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/SaveTradePartnerSetting",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}
+(NSMutableURLRequest *)getFromDaysWithUserHash:(NSString*)hashValue{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetFromDays xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "</GetFromDays>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetFromDays",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest *)listTradeSalesWithUserHash:(NSString*)hashValue andClientID:(int)clientID andDateTimeFrom:(NSString*)dateTimeFrom andDateTimeTo:(NSString*)dateTimeTo andPage:(int)page andPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListTradeSales xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</ListTradeSales>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,dateTimeFrom,dateTimeTo,page,pageSize];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListTradeSales",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest *)listTradeSalesSummaryWithUserHash:(NSString*)hashValue andClientID:(int)clientID andDateTimeFrom:(NSString*)dateTimeFrom andDateTimeTo:(NSString*)dateTimeTo
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<TradeSalesSummary xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<DateTimeFrom>%@</DateTimeFrom>"
                             "<DateTimeTo>%@</DateTimeTo>"
                             "</TradeSalesSummary>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,dateTimeFrom,dateTimeTo];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/TradeSalesSummary",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest *)getTradeVehiclesListWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPage:(int)page andPageSize:(int)pageSize
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AvailableToTradePaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</AvailableToTradePaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,page,pageSize];
    
    // NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AvailableToTradePaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest *)getLoadTradePartnerWithUserHash:(NSString*)hashValue andType:(NSString *)type andSettingsID:(int)settingsID{
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadTradePartner xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<type>%@</type>"
                             "<partnerID>%d</partnerID>"
                             "</LoadTradePartner>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,type,settingsID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadTradePartner",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest *)getAvailableToTradePagedWithUserHash:(NSString*)hashValue andClientID:(int)clientID andPage:(int)page andPageSize:(int)pageSize{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AvailableToTradePaged xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<Page>%d</Page>"
                             "<PageSize>%d</PageSize>"
                             "</AvailableToTradePaged>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,page,pageSize];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AvailableToTradePaged",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getAllTheMembersForSettingsMembersToUserHash:(NSString*)hashValue andClientID:(int)clientID{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListMembersForClientXML xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "</ListMembersForClientXML>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListMembersForClientXML",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listBidsForTradeVehicleWithUserHash:(NSString*)hashValue andClientID:(int)clientID andVehicleID:(int)vehicleID
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListBids xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<ClientID>%d</ClientID>"
                             "<vehicle>%d</vehicle>"
                             "</ListBids>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,clientID,vehicleID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListBids",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getAllListBuyerRatingQuestionsWithUserHash:(NSString*)hashValue{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListBuyerRatingQuestions xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "</ListBuyerRatingQuestions>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListBuyerRatingQuestions",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getAllListSellerRatingQuestionsWithUserHash:(NSString*)hashValue{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListSellerRatingQuestions xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "</ListSellerRatingQuestions>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListSellerRatingQuestions",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)fetchBackTheSellerRatingQuestionsWithUserHash:(NSString*)hashValue WithBuyerClientID:(int)buyerClientID andStockID:(int)stockID andOfferID:(int)offerID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRatingQuestionsForSeller xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<buyerClientID>%d</buyerClientID>"
                             "<stockID>%d</stockID>"
                             "<offerID>%d</offerID>"
                             "<ratingClientID>%d</ratingClientID>"
                             "<ratingMemberID>%d</ratingMemberID>"
                             "</GetRatingQuestionsForSeller>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,buyerClientID,stockID,offerID,ratingClientID,ratingMemberID];
    
    // NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRatingQuestionsForSeller",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)fetchBackTheBuyerRatingQuestionsWithUserHash:(NSString*)hashValue WithBuyerClientID:(int)buyerClientID andStockID:(int)stockID andOfferID:(int)offerID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRatingQuestionsForBuyer xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<buyerClientID>%d</buyerClientID>"
                             "<stockID>%d</stockID>"
                             "<offerID>%d</offerID>"
                             "<ratingClientID>%d</ratingClientID>"
                             "<ratingMemberID>%d</ratingMemberID>"
                             "</GetRatingQuestionsForBuyer>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,buyerClientID,stockID,offerID,ratingClientID,ratingMemberID];
    
    //  NSLog(@"Auto Soap Messageeee : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRatingQuestionsForBuyer",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}



+(NSMutableURLRequest*)setAddBuyerRatingWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)usedVehicleStockID andTradeOfferID:(int)tradeOfferID andCoreClientID:(int)coreClientID andRatingQuestionID:(int)ratingQuestionID andRatingValue:(int)ratingValue{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddBuyerRating xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<tradeOfferID>%d</tradeOfferID>"
                             "<coreClientID>%d</coreClientID>"
                             "<ratingQuestionID>%d</ratingQuestionID>"
                             "<ratingValue>%d</ratingValue>"
                             "</AddBuyerRating>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,usedVehicleStockID,tradeOfferID,coreClientID,ratingQuestionID,ratingValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddBuyerRating",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)setAddSellerRatingWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)usedVehicleStockID andTradeOfferID:(int)tradeOfferID andCoreClientID:(int)coreClientID andRatingQuestionID:(int)ratingQuestionID andRatingValue:(int)ratingValue{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddSellerRating xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<tradeOfferID>%d</tradeOfferID>"
                             "<coreClientID>%d</coreClientID>"
                             "<ratingQuestionID>%d</ratingQuestionID>"
                             "<ratingValue>%d</ratingValue>"
                             "</AddSellerRating>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,usedVehicleStockID,tradeOfferID,coreClientID,ratingQuestionID,ratingValue];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddSellerRating",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getRatingQuestionsForBuyerWithUserHash:(NSString*)hashValue andBuyerClientID:(int)buyerClientID andStockID:(int)stockID andTradeOfferID:(int)tradeOfferID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRatingQuestionsForBuyer xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<buyerClientID>%d</buyerClientID>"
                             "<stockID>%d</stockID>"
                             "<offerID>%d</offerID>"
                             "<ratingClientID>%d</ratingClientID>"
                             "<ratingMemberID>%d</ratingMemberID>"
                             "</GetRatingQuestionsForBuyer>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,buyerClientID,stockID,tradeOfferID,ratingClientID,ratingMemberID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRatingQuestionsForBuyer",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getRatingQuestionsForSellerWithUserHash:(NSString*)hashValue andBuyerClientID:(int)buyerClientID andStockID:(int)stockID andTradeOfferID:(int)tradeOfferID andRatingClientID:(int)ratingClientID andRatingMemberID:(int)ratingMemberID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRatingQuestionsForSeller xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<buyerClientID>%d</buyerClientID>"
                             "<stockID>%d</stockID>"
                             "<offerID>%d</offerID>"
                             "<ratingClientID>%d</ratingClientID>"
                             "<ratingMemberID>%d</ratingMemberID>"
                             "</GetRatingQuestionsForSeller>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,buyerClientID,stockID,tradeOfferID,ratingClientID,ratingMemberID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRatingQuestionsForSeller",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)GetRatingForBuyerWithUserHash:(NSString*)hashValue andBuyerClientID:(int)buyerClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRatingForBuyer xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<buyerClientID>%d</buyerClientID>"
                             "</GetRatingForBuyer>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,buyerClientID];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRatingForBuyer",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)GetRatingForSellerWithUserHash:(NSString*)hashValue andSellerClientID:(int)sellerClientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetRatingForSeller xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<sellerClientID>%d</sellerClientID>"
                             "</GetRatingForSeller>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,sellerClientID];
    
    //  NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/GetRatingForSeller",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)listMessagesForVehicleWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)vehicleStockID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListMessagesForVehicle xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "</ListMessagesForVehicle>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,vehicleStockID];
    
    // NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListMessagesForVehicle",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)addMessageToVehicleWithUserHash:(NSString*)hashValue andUsedVehicleStockID:(int)vehicleStockID andMessage:(NSString*)message
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<AddMessageToVehicle xmlns=\"%@\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%d</usedVehicleStockID>"
                             "<message>%@</message>"
                             "</AddMessageToVehicle>"
                             "</Body>"
                             "</Envelope>",[SMWebServices WEBSERVICETRADEURI],hashValue,vehicleStockID,message];
    
    DLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self tradeWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/AddMessageToVehicle",[SMWebServices WEBSERVICETRADEURI],WEB_SERVICE_TRADE_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - E- Brochure service

+(NSMutableURLRequest*)beginThePersonalizedImageList
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<BeginPersonalizedImageList xmlns=\"http://tempuri.org/\"/>"
                             "</Body>"
                             "</Envelope>"];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/BeginPersonalizedImageList" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)endThePersonalizedImageListWithToken:(NSString*)personalizedImageToken
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<EndPersonalizedImageList xmlns=\"http://tempuri.org/\">"
                             "<personalizedImageListToken>%@</personalizedImageListToken>"
                             "</EndPersonalizedImageList>"
                             "</Body>"
                             "</Envelope>",personalizedImageToken];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/EndPersonalizedImageList" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)sendBrochureWithImagesAndIsSendPhotos:(BOOL)sendPhotos andIsSendVideos:(BOOL)sendVideos withUserHash:(NSString*)userHash andUsedVehicleStockId:(int)stockID andClientID:(int)ClientID withVideoDetails1:(NSArray*)array1 withVideoDetails2:(NSArray*)array2 WithEmail:(NSString*)email WithFirstName:(NSString*)firstName WithMobile:(NSString*)mobileNum WithLastName:(NSString*)lastName withComments:(NSString*)comments withImageToken:(NSString*)imageToken andIsVariant:(BOOL) isVariant
{
    
    // NSLog(@"Array1 1st = %@",[array1 objectAtIndex:0]);
    // NSLog(@"Array1 2nd = %@",[array1 objectAtIndex:1]);
    
    NSString *boolValuePhotos;
    NSString *boolValueVideos;
    
    if(sendPhotos)
        boolValuePhotos = @"true";
    else
        boolValuePhotos = @"false";
    
    if(sendVideos)
        boolValueVideos = @"true";
    else
        boolValueVideos = @"false";
    
    NSArray *arrData = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"UsedImages",@"OptionName",boolValuePhotos,@"OptionValue",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"UsedVideos",@"OptionName",boolValueVideos,@"OptionValue",nil],nil];
    
    NSMutableArray *arrOfVideo;
    
    if(array1 != nil)
    {
        arrOfVideo = [[NSMutableArray alloc] init];
        
        for(int i = 0; i<2;i++)
        {
            NSString* videoID = [array1 objectAtIndex:0];
            NSString* isPrivate = [array1 objectAtIndex:1];
            if ([isPrivate isEqualToString:@"1"]) {
                isPrivate = @"0";
            }else{
                isPrivate = @"1";
            }
            [arrOfVideo addObject:[NSDictionary dictionaryWithObjectsAndKeys:videoID,@"Address",isPrivate,@"IsPrivate", nil]];
            
            if(arrOfVideo.count == 1 && array2!= nil)
            {
                array1 = [array2 mutableCopy];
            }
            else
                break ;
            
        }
    }
    
    NSString *soapMessage;
    
    {
        
        if(isVariant)
        {
            soapMessage = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                           "<Body>"
                           "<SendNewBrochureToAddressWithImages xmlns=\"http://tempuri.org/\">"
                           "<userHash>%@</userHash>\n"
                           "<variantID>%d</variantID>\n"
                           "<clientId>%d</clientId>\n"
                           "<recipient>\n<EmailAddress xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</EmailAddress>\n<FirstName xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</FirstName>\n<MobileNumber xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</MobileNumber>\n<Surname xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</Surname>\n</recipient>\n"
                           "<messageBoxComments>%@</messageBoxComments>\n",userHash,stockID,ClientID,email,firstName,mobileNum,lastName,comments];
        }
        else
        {
            soapMessage = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                           "<Body>"
                           "<SendBrochureToAddressWithImages xmlns=\"http://tempuri.org/\">"
                           "<userHash>%@</userHash>\n"
                           "<usedVehicleStockId>%d</usedVehicleStockId>\n"
                           "<clientId>%d</clientId>\n"
                           "<recipient>\n<EmailAddress xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</EmailAddress>\n<FirstName xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</FirstName>\n<MobileNumber xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</MobileNumber>\n<Surname xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</Surname>\n</recipient>\n"
                           "<messageBoxComments>%@</messageBoxComments>\n",userHash,stockID,ClientID,email,firstName,mobileNum,lastName,comments];
        }
        
        
        //Append OptionName and OptionValue here to soap message
        
        soapMessage = [soapMessage stringByAppendingString:@"<options>\n"];
        
        for (NSDictionary *dictData in arrData)
        {
            NSString *optionName = [dictData objectForKey:@"OptionName"];
            NSString *optionValue = [dictData objectForKey:@"OptionValue"];
            soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ElectronicBrochureOption xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">\n<OptionName>%@</OptionName>\n<OptionValue>%@</OptionValue>\n</ElectronicBrochureOption>\n",optionName,optionValue]];
        }
        
        
        
        soapMessage = [soapMessage stringByAppendingString:@"</options>\n"];
        soapMessage = [soapMessage stringByAppendingString:@"<personalizedVideoLinkList>\n"];
        
        if(array1 != nil)
        {
            for (NSDictionary *dictData in arrOfVideo)
            {
                NSString *videoID = [dictData objectForKey:@"Address"];
                if (![videoID containsString:@"<Error>"]) {
                    NSString *isPrivate = [dictData objectForKey:@"IsPrivate"];
                    if ([isPrivate isEqualToString:@"1"]) {
                        isPrivate = @"0";
                    }else{
                        isPrivate = @"1";
                    }
                    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ElectronicBrochureVideoLink xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">\n<Address>%@</Address>\n<IsPrivate>%@</IsPrivate>\n</ElectronicBrochureVideoLink>\n",videoID,isPrivate]];
                }else{
                    
                }
                
            }
        }
        soapMessage = [soapMessage stringByAppendingString:@"</personalizedVideoLinkList>\n"];
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<personalizedImageListToken>%@</personalizedImageListToken>\n",imageToken]];
        
        if(isVariant)
        {
            soapMessage = [soapMessage stringByAppendingString:@"</SendNewBrochureToAddressWithImages>\n</Body></Envelope>"];
        }
        else
        {
            soapMessage = [soapMessage stringByAppendingString:@"</SendBrochureToAddressWithImages>\n</Body></Envelope>"];
        }
    }
    
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if(!isVariant)
        [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/SendBrochureToAddressWithImages" forHTTPHeaderField:@"SOAPAction"];
    else
        [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/SendNewBrochureToAddressWithImages" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)sendBrochureWithoutImagesAndIsSendPhotos:(BOOL)sendPhotos andIsSendVideos:(BOOL)sendVideos withUserHash:(NSString*)userHash andUsedVehicleStockId:(int)stockID andClientID:(int)ClientID withVideoDetails1:(NSArray*)array1 withVideoDetails2:(NSArray*)array2 WithEmail:(NSString*)email WithFirstName:(NSString*)firstName WithMobile:(NSString*)mobileNum WithLastName:(NSString*)lastName withComments:(NSString*)comments andIsVariant:(BOOL) isVariant
{
    
    NSString *boolValuePhotos;
    NSString *boolValueVideos;
    
    if(sendPhotos)
        boolValuePhotos = @"true";
    else
        boolValuePhotos = @"false";
    
    if(sendVideos)
        boolValueVideos = @"true";
    else
        boolValueVideos = @"false";
    
    NSArray *arrData = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:@"UsedImages",@"OptionName",boolValuePhotos,@"OptionValue",nil],[NSDictionary dictionaryWithObjectsAndKeys:@"UsedVideos",@"OptionName",boolValueVideos,@"OptionValue",nil],nil];
    
    NSMutableArray *arrOfVideo;
    
    if(array1 != nil)
    {
        arrOfVideo = [[NSMutableArray alloc] init];
        
        for(int i = 0; i<2;i++)
        {
            NSString* videoID = [array1 objectAtIndex:0];
            NSString* isPrivate = [array1 objectAtIndex:1];
            [arrOfVideo addObject:[NSDictionary dictionaryWithObjectsAndKeys:videoID,@"Address",isPrivate,@"IsPrivate", nil]];
            
            if(arrOfVideo.count == 1 && array2!= nil)
            {
                array1 = [array2 mutableCopy];
            }
            else
                break ;
            
        }
    }
    NSString *soapMessage;
    {
        if(!isVariant)
        {
            soapMessage = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                           "<Body>"
                           "<SendBrochureToAddressWithoutImages xmlns=\"http://tempuri.org/\">"
                           "<userHash>%@</userHash>\n"
                           "<usedVehicleStockId>%d</usedVehicleStockId>\n"
                           "<clientId>%d</clientId>\n"
                           "<recipient>\n<EmailAddress xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</EmailAddress>\n<FirstName xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</FirstName>\n<MobileNumber xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</MobileNumber>\n<Surname xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</Surname>\n</recipient>\n"
                           "<messageBoxComments>%@</messageBoxComments>\n",userHash,stockID,ClientID,email,firstName,mobileNum,lastName,comments];
        }
        else
        {
            soapMessage = [NSString stringWithFormat:
                           @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                           "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                           "<Body>"
                           "<SendNewBrochureToAddressWithoutImages xmlns=\"http://tempuri.org/\">"
                           "<userHash>%@</userHash>\n"
                           "<variantID>%d</variantID>\n"
                           "<clientId>%d</clientId>\n"
                           "<recipient>\n<EmailAddress xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</EmailAddress>\n<FirstName xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</FirstName>\n<MobileNumber xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</MobileNumber>\n<Surname xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">%@</Surname>\n</recipient>\n"
                           "<messageBoxComments>%@</messageBoxComments>\n",userHash,stockID,ClientID,email,firstName,mobileNum,lastName,comments];
        }
        
        
        //Append OptionName and OptionValue here to soap message
        
        soapMessage = [soapMessage stringByAppendingString:@"<options>\n"];
        
        for (NSDictionary *dictData in arrData)
        {
            NSString *optionName = [dictData objectForKey:@"OptionName"];
            NSString *optionValue = [dictData objectForKey:@"OptionValue"];
            soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ElectronicBrochureOption xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">\n<OptionName>%@</OptionName>\n<OptionValue>%@</OptionValue>\n</ElectronicBrochureOption>\n",optionName,optionValue]];
        }
        
        
        
        soapMessage = [soapMessage stringByAppendingString:@"</options>\n"];
        soapMessage = [soapMessage stringByAppendingString:@"<personalizedVideoLinkList>\n"];
        
        if(array1 != nil)
        {
            for (NSDictionary *dictData in arrOfVideo)
            {
                NSString *videoID = [dictData objectForKey:@"Address"];
                if (![videoID containsString:@"<Error>"]) {
                    NSString *isPrivate = [dictData objectForKey:@"IsPrivate"];
                    if ([isPrivate isEqualToString:@"1"]) {
                        isPrivate = @"0";
                    }else{
                        isPrivate = @"1";
                    }
                    
                    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<ElectronicBrochureVideoLink xmlns=\"http://schemas.datacontract.org/2004/07/EBrochureService\">\n<Address>%@</Address>\n<IsPrivate>%@</IsPrivate>\n</ElectronicBrochureVideoLink>\n",videoID,isPrivate]];
                }else{
                    
                }
                
            }
        }
        soapMessage = [soapMessage stringByAppendingString:@"</personalizedVideoLinkList>\n"];
        
        if(!isVariant)
            soapMessage = [soapMessage stringByAppendingString:@"</SendBrochureToAddressWithoutImages>\n</Body></Envelope>"];
        else
            soapMessage = [soapMessage stringByAppendingString:@"</SendNewBrochureToAddressWithoutImages>\n</Body></Envelope>"];
    }
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    if(!isVariant)
        [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/SendBrochureToAddressWithoutImages" forHTTPHeaderField:@"SOAPAction"];
    else
        [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/SendNewBrochureToAddressWithoutImages" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)uploadPersonalizedImageWithImageToken:(NSString*)imageToken andVehicleStockID:(NSString *)strVehicleStockID andBase64String:(NSString*)base64String
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UploadPersonalizedImageAsPng xmlns=\"http://tempuri.org/\">"
                             "<personalizedImageListToken>%@</personalizedImageListToken>"
                             "<usedVehicleStockID>%@</usedVehicleStockID>"
                             "<base64EncodedString>%@</base64EncodedString>"
                             "</UploadPersonalizedImageAsPng>"
                             "</Body>"
                             "</Envelope>",imageToken,strVehicleStockID,base64String];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/UploadPersonalizedImageAsPng" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)uploadVariantPersonalizedImageWithImageToken:(NSString*)imageToken andVariantID:(NSString *)strVariantID andBase64String:(NSString*)base64String
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UploadNewPersonalizedImageAsPng xmlns=\"http://tempuri.org/\">"
                             "<personalizedImageListToken>%@</personalizedImageListToken>"
                             "<variantID>%@</variantID>"
                             "<base64EncodedString>%@</base64EncodedString>"
                             "</UploadNewPersonalizedImageAsPng>"
                             "</Body>"
                             "</Envelope>",imageToken,strVariantID,base64String];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/IElectronicBrochureGeneratorService/UploadNewPersonalizedImageAsPng" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

#pragma mark - Synopsis module services

+(NSMutableURLRequest*)getSynopsisSummaryWithUserHash:(NSString*)userHash andYear:(int)year andMakeId:(int)makeId andModelId:(int)modelId andVariantId:(int)variantId andVIN:(NSString*)vinNumber andKiloMeters:(NSString*)kilometers andExtrasCost:(NSString*)extraCost andCondition:(NSString*)condition
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSynopsisXml xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<makeId>%d</makeId>"
                             "<modelId>%d</modelId>"
                             "<variantId>%d</variantId>"
                             "<VIN>%@</VIN>"
                             "<kilometers>%@</kilometers>"
                             "<extras>%@</extras>"
                             "<condition>%@</condition>"
                             "</GetSynopsisXml>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,makeId,modelId,variantId,vinNumber,kilometers,extraCost,condition];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/GetSynopsisXml",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getSynopsisSummaryByIxCodeWithUserHash:(NSString*)userHash andYear:(int)year andiXCode:(NSString*)ixCode
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSynopsisByIxCodeXml xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<ixCode>%@</ixCode>"
                             "</GetSynopsisByIxCodeXml>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,ixCode];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/GetSynopsisByIxCodeXml",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getSynopsisSummaryByMMCodeCodeWithUserHash:(NSString*)userHash andYear:(int)makeId andMMCode:(NSString*)mmCode withKiloMeters:(NSString*)kiloMeters andVIN:(NSString*)VinNumber andExtrasCost:(NSString*)extrasCost andCondition:(NSString*)condition
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSynopsisByMMCodeXml xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<mmcode>%@</mmcode>"
                             "<VIN>%@</VIN>"
                             "<kilometers>%@</kilometers>"
                             "<extras>%@</extras>"
                             "<condition>%@</condition>"
                             "</GetSynopsisByMMCodeXml>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,makeId,mmCode,VinNumber,kiloMeters,extrasCost,condition];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/GetSynopsisByMMCodeXml",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}


+(NSMutableURLRequest*)getSynopsisSummaryByVinNumberWithUserHash:(NSString*)userHash andYear:(int)year andVinNumber:(NSString*)vinNumber withKiloMeters:(NSString*)kiloMeters andExtrasCost:(NSString*)extrasCost andCondition:(NSString*)condition
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetSynopsisByVinNumberXml xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<vinNumber>%@</vinNumber>"
                             "<kilometers>%@</kilometers>"
                             "<extras>%@</extras>"
                             "<condition>%@</condition>"
                             "</GetSynopsisByVinNumberXml>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,vinNumber,kiloMeters,extrasCost,condition];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/GetSynopsisByVinNumberXml",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*) gettingOEMSpecsDetails:(NSString *) userHash
                                          Year:(NSString *)year
                                     variantID:(NSString *)variantID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadOEMSpecsByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "<year>%@</year>"
                             "</LoadOEMSpecsByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadOEMSpecsByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*) gettingLoadVINHistory:(NSString *) userHash                                                                            VIN:(NSString *)VIN
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVINHistory xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<VIN>%@</VIN>"
                             "</LoadVINHistory>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,VIN];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0f];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LoadVINHistory",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getAvaibilityWithUserHash:(NSString*)userHash  andModelID:(NSString *)strModelId andClientID:(NSString *)strClientID andGroupId:(NSString *)strGroupId
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadAvailability xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%@</modelID>"
                             "<clientID>%@</clientID>"
                             "<groupID>%@</groupID>"
                             "</LoadAvailability>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strModelId,strClientID,strGroupId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadAvailability",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getAverageDaysWithUserHash:(NSString*)userHash andModelId:(NSString *)strModelId  andClientID:(NSString *)strClientId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadAverageDaysInStock xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%@</modelID>"
                             "<clientID>%@</clientID>"
                             "</LoadAverageDaysInStock>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strModelId,strClientId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadAverageDaysInStock",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)getLeadPoolsWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadLeadPoolByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "<year>%@</year>"
                             "</LoadLeadPoolByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadLeadPoolByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getSalesHistoryWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadSalesHistoryByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "<year>%@</year>"
                             "</LoadSalesHistoryByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadSalesHistoryByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}


+(NSMutableURLRequest*)getReviewsWithUserHash:(NSString*)userHash andVariantId:(NSString*)strVariantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadReviewsForVariantByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "</LoadReviewsForVariantByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadReviewsForVariantByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getReviewsForModelIDExcludeVariantWithUserHash:(NSString*)userHash andModelID:(int) modelID andVariantId:(int) variantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadReviewsForModelByIDExcludeVariantByCode xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%d</modelID>"
                             "<variantID>%d</variantID>"
                             "</LoadReviewsForModelByIDExcludeVariantByCode>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,modelID,variantId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadReviewsForModelByIDExcludeVariantByCode",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getDemandsWithUserHash:(NSString*)userHash andVariantID:(NSString *)strVariantId andClientId:(NSString *)strClientId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadDemandForVariantByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "<clientID>%@</clientID>"
                             "</LoadDemandForVariantByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId,strClientId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadDemandForVariantByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listDealerMakesOpenXML:(NSString*)userHash andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerMakesOpenJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "</ListDealerMakesOpenJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerMakesOpenJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)listDealerMakesJSON:(NSString*)userHash andClientID:(int)clientID year:(NSString*)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerMakesJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<year>%@</year>"
                             "</ListDealerMakesJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerMakesJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listDealerModelOpenJSON:(NSString*)userHash andClientID:(int)clientID makeID:(int)makeID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerModelsOpenJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<makeID>%d</makeID>"
                             "</ListDealerModelsOpenJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,makeID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerModelsOpenJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listDealerModelJSON:(NSString*)userHash andClientID:(int)clientID year:(int)year makeID:(int)makeID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerModelsJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<year>%d</year>"
                             "<makeID>%d</makeID>"
                             "</ListDealerModelsJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,year,makeID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerModelsJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listDealerVariantOpenJSON:(NSString*)userHash andClientID:(int)clientID modelID:(int)modelID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerVariantsOpenJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<modelID>%d</modelID>"
                             "</ListDealerVariantsOpenJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,modelID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerVariantsOpenJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listDealerVariantJSON:(NSString*)userHash andClientID:(int)clientID year:(int)year modelID:(int)modelID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerVariantsJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<year>%d</year>"
                             "<modelID>%d</modelID>"
                             "</ListDealerVariantsJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,year,modelID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerVariantsJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)listDealerStockVariants:(NSString *)userHash clientID:(int)clientID modelID:(int)modelID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerStockByModelXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<modelID>%d</modelID>"
                             "</ListDealerStockByModelXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,modelID];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListDealerStockByModelXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*)getSimilarVehiclesWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadSimilarVehiclesByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "<year>%@</year>"
                             "</LoadSimilarVehiclesByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadSimilarVehiclesByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getNewPricePlotterWithUserHash:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadNewPricesByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "</LoadNewPricesByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadNewPricesByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getReviewsByModelWithUserHash:(NSString*)userHash  andModelID:(NSString *)strModelId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadReviewsForModelByID xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%@</modelID>"
                             "</LoadReviewsForModelByID>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strModelId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadReviewsForModelByID",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getReviewDetailsWithUserHash:(NSString*)userHash  andReviewID:(int)strReviewId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadReviewById xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<reviewID>%d</reviewID>"
                             "</LoadReviewById>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strReviewId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadReviewById",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

#pragma mark - Pricing

+(NSMutableURLRequest*)getAdvertRegionsList:(NSString*)userHash  andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadAdvertRegionForClient xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "</LoadAdvertRegionForClient>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadAdvertRegionForClient",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}
+(NSMutableURLRequest*)loadRetailPricingForCity:(NSString*)userHash andVariantID:(int)variantID year:(int)year cityID:(int) cityID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadRetailPricingHistoryForCity xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "<cityID>%d</cityID>"
                             "</LoadRetailPricingHistoryForCity>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year,cityID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadRetailPricingHistoryForCity",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)loadRetailPricingForNational:(NSString*)userHash andVariantID:(int)variantID year:(int)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadRetailPricingHistoryForNational xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "</LoadRetailPricingHistoryForNational>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadRetailPricingHistoryForNational",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}


+(NSMutableURLRequest*)loadRetailPricingForProvince:(NSString*)userHash andVariantID:(int)variantID year:(int)year provinceID:(int) provinceID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadRetailPricingHistoryForProvince xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "<provinceID>%d</provinceID>"
                             "</LoadRetailPricingHistoryForProvince>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year,provinceID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadRetailPricingHistoryForProvince",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)loadRetailPricingForGroup:(NSString*)userHash andVariantID:(int)variantID year:(int)year groupID:(int) groupID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadRetailPricingHistoryForGroup xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "<groupID>%d</groupID>"
                             "</LoadRetailPricingHistoryForGroup>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year,groupID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadRetailPricingHistoryForGroup",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)loadRetailPricingForGroupCity:(NSString*)userHash andVariantID:(int)variantID year:(int)year groupID:(int) groupID cityID:(int) cityID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadRetailPricingHistoryForGroupAndCity xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "<groupID>%d</groupID>"
                             "<cityID>%d</cityID>"
                             "</LoadRetailPricingHistoryForGroupAndCity>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year,groupID,cityID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadRetailPricingHistoryForGroupAndCity",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)loadRetailPricingForGroupProvince:(NSString*)userHash andVariantID:(int)variantID year:(int)year groupID:(int) groupID provinceID:(int) provinceID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadRetailPricingHistoryForGroupAndProvince xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "<groupID>%d</groupID>"
                             "<provinceID>%d</provinceID>"
                             "</LoadRetailPricingHistoryForGroupAndProvince>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year,groupID,provinceID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadRetailPricingHistoryForGroupAndProvince",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)loadiXTraderPricingForNational:(NSString*)userHash andVariantID:(int)variantID year:(int)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadTradePricingHistoryForNational xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "</LoadTradePricingHistoryForNational>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadTradePricingHistoryForNational",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)loadPrivatePricingForNational:(NSString*)userHash andVariantID:(int)variantID year:(int)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadPrivatePricingHistoryForNational xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%d</variantID>"
                             "<year>%d</year>"
                             "</LoadPrivatePricingHistoryForNational>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,variantID,year];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadPrivatePricingHistoryForNational",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getSimpleLogicForVariant:(NSString*)userHash andYear:(NSString *)year  andVariantID:(NSString *)strVariantId andMileage:(NSString *)strMileage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVehicleRetailDetailsForVariant xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<variantID>%@</variantID>"
                             "<year>%@</year>"
                             "<mileage>%@</mileage>"
                             "</LoadVehicleRetailDetailsForVariant>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVariantId,year,strMileage];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadVehicleRetailDetailsForVariant",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)getSimpleLogicForVehicleInStock:(NSString*)userHash andusedVehicleStockID:(NSString *)strUsedVehicleStockID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVehicleRetailDetailsForVehicleInStock xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<usedVehicleStockID>%@</usedVehicleStockID>"
                             "</LoadVehicleRetailDetailsForVehicleInStock>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strUsedVehicleStockID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadVehicleRetailDetailsForVehicleInStock",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)getLeadPoolSummary:(NSString*)userHash andModelId:(NSString*)strModelId andYear:(NSString*)strYear andClientId:(NSString*)strClientId andGroupId:(NSString*)strGroupId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadLeadPoolSummary xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%@</modelID>"
                             "<year>%@</year>"
                             "<ClientID>%@</ClientID>"
                             "<GroupID>%@</GroupID>"
                             "</LoadLeadPoolSummary>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strModelId,strYear,strClientId,strGroupId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadLeadPoolSummary",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}


+(NSMutableURLRequest*)getLeadPoolForClient:(NSString*)userHash andModelId:(NSString*)strModelId andYear:(NSString*)strYear andClientId:(NSString*)strClientId andLeadStatusId:(NSString*)strLeadStatusId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadLeadPoolDetailForClient xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%@</modelID>"
                             "<year>%@</year>"
                             "<clientID>%@</clientID>"
                             "<leadStatusTypeID>%@</leadStatusTypeID>"
                             "</LoadLeadPoolDetailForClient>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strModelId,strYear,strClientId,strLeadStatusId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadLeadPoolDetailForClient",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)getLeadPoolForGroupExcludeClient:(NSString*)userHash andModelId:(NSString*)strModelId andYear:(NSString*)strYear andGroupID:(NSString *)strGroupId andClientId:(NSString*)strClientId andLeadStatusId:(NSString*)strLeadStatusId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadLeadPoolDetailForGroupExcludeClient xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<modelID>%@</modelID>"
                             "<year>%@</year>"
                             "<groupID>%@</groupID>"
                             "<clientID>%@</clientID>"
                             "<leadStatusTypeID>%@</leadStatusTypeID>"
                             "</LoadLeadPoolDetailForGroupExcludeClient>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strModelId,strYear,strGroupId,strClientId,strLeadStatusId];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadLeadPoolDetailForGroupExcludeClient",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadTransUnionPricing:(NSString*)userHash andVINNum:(NSString*)strVinNum andYear:(NSString*)strYear andRegNumber:(NSString*)regNum andMMCode:(NSString *)strMMCode andMileage:(NSString*)strMileage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadTransUnionPricing xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<vinNumber>%@</vinNumber>"
                             "<manufactureYear>%@</manufactureYear>"
                             "<registrationNumber>%@</registrationNumber>"
                             "<MMCode>%@</MMCode>"
                             "<mileage>%@</mileage>"
                             "</LoadTransUnionPricing>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVinNum,strYear,regNum,strMMCode,strMileage];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadTransUnionPricing",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

////////////////////////////////// VIN Verification section  /////////////////////////

+(NSMutableURLRequest*)loadFullVerificationDetails:(NSString*)userHash andVINNum:(NSString*)strVinNum andYear:(NSString*)strYear andRegNumber:(NSString*)regNum andMMCode:(NSString *)strMMCode andMileage:(NSString*)strMileage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadTransUnionFullVerification xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<vinNumber>%@</vinNumber>"
                             "<manufactureYear>%@</manufactureYear>"
                             "<registrationNumber>%@</registrationNumber>"
                             "<MMCode>%@</MMCode>"
                             "<mileage>%@</mileage>"
                             "</LoadTransUnionFullVerification>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVinNum,strYear,regNum,strMMCode,strMileage];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadTransUnionFullVerification",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadVINVerificationDetails:(NSString*)userHash andVINNum:(NSString*)strVinNum andYear:(NSString*)strYear andRegNumber:(NSString*)regNum andMMCode:(NSString *)strMMCode andMileage:(NSString*)strMileage
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadTransUnionVINVerification xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<vinNumber>%@</vinNumber>"
                             "<manufactureYear>%@</manufactureYear>"
                             "<registrationNumber>%@</registrationNumber>"
                             "<MMCode>%@</MMCode>"
                             "<mileage>%@</mileage>"
                             "</LoadTransUnionVINVerification>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,strVinNum,strYear,regNum,strMMCode,strMileage];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadTransUnionVINVerification",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

# pragma mark - Do Appraisal section

+(NSMutableURLRequest*)loadAppraisalSellerDetails:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadSellerInformation xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<VinNumber>%@</VinNumber>"
                             "</LoadSellerInformation>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID, vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadSellerInformation",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadAppraisalPurchaseDetails:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadPurchaseDetails xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<VinNumber>%@</VinNumber>"
                             "</LoadPurchaseDetails>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID, vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadPurchaseDetails",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadInteriorReconditioning:(NSString*)userHash andAppraisalID:(int)appraisalID andVin:(NSString*) vinNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadInteriorReconditioning xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<VinNumber>%@</VinNumber>"
                             "</LoadInteriorReconditioning>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID, vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadInteriorReconditioning",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadLoadEngineDrivetrain:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadEngineDrivetrain xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<VinNumber>%@</VinNumber>"
                             "</LoadEngineDrivetrain>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID, vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadEngineDrivetrain",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadVehicleCondition:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVehicleCondition xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<VinNumber>%@</VinNumber>"
                             "</LoadVehicleCondition>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID,vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadVehicleCondition",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)saveVehicleCondition:(NSString*)userHash andConditionsArray:(NSMutableArray*) arrmOfConditions andRootConditionID:(NSString*) rootConditionID  andAppraisalID:(NSString*) appraisalID andOverallConditionID:(NSString*) overallConditionID andComments:(NSString*) comments andClientID:(NSString*) clientID andVin:(NSString*) vinNum
{
    
    NSMutableArray *arrmConditionIds = [[NSMutableArray alloc] init];
    for(SMInteriorReconditioningObject *individualObj in arrmOfConditions)
    {
        NSPredicate *predicateSelectedOption = [NSPredicate predicateWithFormat:@"isOptionSelected == %d",YES];
        
        NSArray *arrayLocalFiltered = [individualObj.arrmOptions filteredArrayUsingPredicate:predicateSelectedOption];
        if(arrayLocalFiltered.count>0)
        {
            SMConditionOptionsObject *optionObj = [arrayLocalFiltered objectAtIndex:0];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:individualObj.strInteriorReconditioningValue forKey:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%d",optionObj.isOptionSelected]]];
            [arrmConditionIds addObject:dict];
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setValue:individualObj.strInteriorReconditioningValue forKey:[NSString stringWithFormat:@"%@",@"0"]];
            [arrmConditionIds addObject:dict];
        }
        
        
    }
    
    NSString *soapMessage;
    
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveVehicleCondition xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<VehicleCondition>\n"
                   "<ConditionSaveResults>\n"
                   ,userHash];
    
    
    for (NSDictionary *dictData in arrmConditionIds)
    {
        for (id key in dictData)
        {
            soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Condition>\n<ConditionTypeID>%@</ConditionTypeID>\n<SelectedValue>%@</SelectedValue>\n</Condition>\n",[dictData objectForKey:key],key]];
        }
        
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<RootCondition>\n<ConditionId>%@</ConditionId>\n<AppraisalId>%@</AppraisalId>\n<VinNumber>%@</VinNumber>\n<ClientId>%@</ClientId>\n<OverallCondition>%@</OverallCondition>\n<Comments>%@</Comments>\n</RootCondition>\n",rootConditionID,appraisalID,vinNum,clientID,overallConditionID,comments]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</ConditionSaveResults>\n</VehicleCondition>\n</SaveVehicleCondition>\n</Body></Envelope>"]];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveVehicleCondition",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)savePurchaseDetails:(NSString*)userHash andPurchaseDetailsId:(NSString*) strPurchaseDetailID andAccountNum:(NSString*) accountNum andAppraisalID:(NSString*) appraisalID andBoughtFrom:(NSString*) boughtFrom andComments:(NSString*) comments andDate:(NSString*) date andDetails:(NSString*) details andFinanceHouse:(NSString*) financeHouse andSettlementR:(NSString*) settlementR andClientID:(NSString*) clientID andVinNum:(NSString*) vinNum{
    
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SavePurchaseDetails xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<PurchaseDetailsXML>\n"
                   "<PurchaseDetails>\n"
                   "<PurchaseDetailsId>%@</PurchaseDetailsId>\n"
                   "<AccountNo>%@</AccountNo>\n"
                   "<AppraisalId>%@</AppraisalId>\n"
                   "<BoughtFrom>%@</BoughtFrom>\n"
                   "<Comments>%@</Comments>\n"
                   "<Date>%@</Date>\n"
                   "<Details>%@</Details>\n"
                   "<FinanceHouse>%@</FinanceHouse>\n"
                   "<VinNumber>%@</VinNumber>\n"
                   "<ClientId>%@</ClientId>\n"
                   "<SettlementR>%@</SettlementR>\n"
                   "</PurchaseDetails>\n"
                   "</PurchaseDetailsXML>\n"
                   "</SavePurchaseDetails>\n"
                   "</Body>\n"
                   "</Envelope>\n"
                   ,userHash,strPurchaseDetailID,accountNum,appraisalID,boughtFrom,comments,date,details,financeHouse,vinNum,clientID,settlementR];
    
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SavePurchaseDetails",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)saveInteriorReconditioning:(NSString*)userHash andIRArray:(NSMutableArray*) arrmInteriorR andInteriorReconditioningID:(NSString*) InteriorReconditioningID  andAppraisalID:(NSString*) appraisalID andComments:(NSString*) comments andClientID:(NSString*) clientID andVinNumber:(NSString*) vinNum
{
    
    NSMutableArray *arrmConditionIds = [[NSMutableArray alloc] init];
    for(SMInteriorReconditioningObject *individualObj in arrmInteriorR)
    {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:individualObj.strInteriorReconditioningValue,@"InteriorReconditioningValueID",individualObj.strReconditioningTypeID,@"ReconditioningTypeID",individualObj.strTitle,@"CustomType",
                              individualObj.strValue,@"Value",
                              individualObj.isCheckBoxSelected,@"IsActive",nil];
        
        
        [arrmConditionIds addObject:dict];
        
    }
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveInteriorReconditioning xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<InteriorReconditioningXml>\n"
                   "<InteriorReconditioning>\n"
                   "<Items>\n",userHash];
    
    
    for (NSDictionary *dictData in arrmConditionIds)
    {
        
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Interior>\n<InteriorReconditioningValueID>%@</InteriorReconditioningValueID>\n<ReconditioningTypeID>%@</ReconditioningTypeID>\n<CustomType>%@</CustomType>\n<Value>%@</Value>\n<IsActive>%@</IsActive>\n</Interior>\n",[dictData objectForKey:@"InteriorReconditioningValueID"],[dictData objectForKey:@"ReconditioningTypeID"],[dictData objectForKey:@"CustomType"],[dictData objectForKey:@"Value"],[dictData objectForKey:@"IsActive"]]];
        
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</Items>\n<RootInfo>\n<InteriorReconditioningID>%@</InteriorReconditioningID>\n<AppraisalId>%@</AppraisalId>\n<VinNumber>%@</VinNumber>\n<ClientId>%@</ClientId>\n<Comments>%@</Comments>\n</RootInfo>\n",InteriorReconditioningID,appraisalID,vinNum,clientID,comments]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</InteriorReconditioning>\n</InteriorReconditioningXml>\n</SaveInteriorReconditioning>\n</Body></Envelope>"]];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveInteriorReconditioning",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)saveEngineDriveTrain:(NSString*)userHash andIRArray:(NSMutableArray*) arrmEngineD andEngineDriveTrainID:(NSString*) engineDriveTrainID  andAppraisalID:(NSString*) appraisalID andComments:(NSString*) comments andClientID:(NSString*) clientID andVinNum:(NSString*) vinNum
{
    
    NSMutableArray *arrmConditionIds = [[NSMutableArray alloc] init];
    for(SMInteriorReconditioningObject *individualObj in arrmEngineD)
    {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:individualObj.strInteriorReconditioningValue,@"EngineDriveTrainValueID",individualObj.strReconditioningTypeID,@"ReconditioningTypeID",individualObj.strTitle,@"CustomType",
                              individualObj.strValue,@"Value",
                              individualObj.isCheckBoxSelected,@"IsActive",nil];
        
        
        [arrmConditionIds addObject:dict];
        
    }
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveEngineDrivetrain xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<EngineDrivetrainXML>\n"
                   "<EngineDrivetrain>\n"
                   "<Items>\n",userHash];
    
    
    for (NSDictionary *dictData in arrmConditionIds)
    {
        
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Item>\n<EngineDriveTrainValueID>%@</EngineDriveTrainValueID>\n<ReconditioningTypeID>%@</ReconditioningTypeID>\n<CustomType>%@</CustomType>\n<Value>%@</Value>\n<IsActive>%@</IsActive>\n</Item>\n",[dictData objectForKey:@"InteriorReconditioningValueID"],[dictData objectForKey:@"ReconditioningTypeID"],[dictData objectForKey:@"CustomType"],[dictData objectForKey:@"Value"],[dictData objectForKey:@"IsActive"]]];
        
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</Items>\n<RootInfo>\n<EngineDrivetrainId>%@</EngineDrivetrainId>\n<AppraisalId>%@</AppraisalId>\n<ClientId>%@</ClientId>\n<VinNumber>%@</VinNumber>\n<Comments>%@</Comments>\n</RootInfo>\n",engineDriveTrainID,appraisalID,clientID,vinNum,comments]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</EngineDrivetrain>\n</EngineDrivetrainXML>\n</SaveEngineDrivetrain>\n</Body></Envelope>"]];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveEngineDrivetrain",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}


+(NSMutableURLRequest*)loadAppraisalInfo:(NSString*)userHash andVIN:(NSString *) vinNumber andClientID:(int)clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetAppraisalInfo xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<VinNumber>%@</VinNumber>"
                             "<ClientID>%d</ClientID>"
                             "</GetAppraisalInfo>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,vinNumber,clientID];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/GetAppraisalInfo",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)loadAppraisalVehicleExtras:(NSString*)userHash andAppraisalID:(int)appraisalID andVinNum:(NSString*) vinNum
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LoadVehicleExtras xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<VinNumber>%@</VinNumber>"
                             "</LoadVehicleExtras>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID, vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadVehicleExtras",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}


#pragma mark - Methods for Do Appraisal - Exterior Reconditining pages

+(NSMutableURLRequest*)saveSelectedExteriorReconditioning:(NSString*)userHash andERArray:(NSMutableArray*) arrmExteriorR andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum andComments:(NSString*) comments
{
    
    NSMutableArray *arrmERItems = [[NSMutableArray alloc] init];
    for(SMExteriorReconditioning *individualObj in arrmExteriorR)
    {
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:individualObj.strExteriorTypeID,@"ExteriorTypeID",[NSString stringWithFormat:@"%d",individualObj.isPriceSelected],@"PriceSelected",nil];
        
        
        [arrmERItems addObject:dict];
        
    }
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveSelectedExterior xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<ExteriorXML>\n"
                   "<ExteriorReconditioning xmlns=\"http://tempuri.org/\">\n"
                   "<Items>\n",userHash];
    
    
    for (NSDictionary *dictData in arrmERItems)
    {
        
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Item>\n<ExteriorValueId>%@</ExteriorValueId>\n<Selected>%@</Selected>\n</Item>",[dictData objectForKey:@"ExteriorTypeID"],[dictData objectForKey:@"PriceSelected"]]];
        
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</Items>\n<RootInfo>\n<AppraisalId>%@</AppraisalId>\n<ClientId>%@</ClientId>\n<VinNumber>%@</VinNumber>\n<Comments>%@</Comments>\n</RootInfo>\n",AppraisalID,ClientID,vinNum,comments]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</ExteriorReconditioning>\n</ExteriorXML>\n</SaveSelectedExterior>\n</Body></Envelope>"]];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveSelectedExterior",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}




// ================================================================================



+(NSMutableURLRequest*)saveExteriorReconditioning:(NSString*)userHash andExteriorTypeID:(NSString *) exteriorTypeID andIsRepair:(NSString *) isRepair andIsReplace: (NSString *) isReplace andPriceValue:(NSString *) priceValue andComments:(NSString *) comments andAppraisalID:(NSString*) AppraisalID andClientID:(NSString*) clientID andVIN: (NSString*) vinNum
{
    
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveExterior xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<ExteriorXML>\n"
                   "<ExteriorReconditioning xmlns=\"http://tempuri.org/\">\n"
                   "<Items>\n"
                   "<Item>\n"
                   "<ExteriorTypeId>%@</ExteriorTypeId>\n"
                   "<Replace>%@</Replace>\n"
                   "<Repair>%@</Repair>\n"
                   "<Value>%@</Value>\n"
                   "<Comments>%@</Comments>\n"
                   "</Item>\n"
                   "</Items>\n"
                   "<RootInfo>\n"
                   "<AppraisalId>%@</AppraisalId>\n"
                   "<ClientId>%@</ClientId>\n"
                   "<VinNumber>%@</VinNumber>\n"
                   "</RootInfo>\n"
                   "</ExteriorReconditioning>\n"
                   "</ExteriorXML>\n"
                   "</SaveExterior>\n"
                   "</Body>\n"
                   "</Envelope>\n",userHash, exteriorTypeID,isRepair,isReplace,priceValue,comments,AppraisalID,clientID,vinNum];
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveExterior",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)loadExterior:(NSString*)userHash andAppraisalID:(NSString*) AppraisalID andVin:(NSString*) vinNum
{
    
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<LoadExterior xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<AppraisalId>%@</AppraisalId>\n"
                   "<VinNumber>%@</VinNumber>\n"
                   "</LoadExterior>\n"
                   "</Body>\n"
                   "</Envelope>\n",userHash,AppraisalID,vinNum];
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/LoadExterior",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)deleteSelectedExteriorReconditioning:(NSString*)userHash andExteriorTypeID:(NSString *) exteriorTypeID andAppraisalID:(NSString*) AppraisalID andClientID:(NSString*) clientID andVIN: (NSString*) vinNum
{
    
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<DeleteSelectedExterior xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<ExteriorXML>\n"
                   "<ExteriorReconditioning xmlns=\"http://tempuri.org/\">\n"
                   "<Items>\n"
                   "<Item>\n"
                   "<ExteriorValueId>%@</ExteriorValueId>\n"
                   "</Item>\n"
                   "</Items>\n"
                   "<RootInfo>\n"
                   "<AppraisalId>%@</AppraisalId>\n"
                   "<ClientId>%@</ClientId>\n"
                   "<VinNumber>%@</VinNumber>\n"
                   "</RootInfo>\n"
                   "</ExteriorReconditioning>\n"
                   "</ExteriorXML>\n"
                   "</DeleteSelectedExterior>\n"
                   "</Body>\n"
                   "</Envelope>\n",userHash, exteriorTypeID,AppraisalID,clientID,vinNum];
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/DeleteSelectedExterior",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+(NSMutableURLRequest*)sendForwardAppraisalEmailsWithUserHash:(NSString*)userHash andAppraisalID:(NSString*) AppraisalID andEmailIDs:(NSString*) emailIDs andVin:(NSString*) vinNum
{
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SendFowardAppraisalEmails xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<AppraisalId>%@</AppraisalId>\n"
                   "<FowardEmails>%@</FowardEmails>\n"
                   "<VinNumber>%@</VinNumber>\n"
                   "</SendFowardAppraisalEmails>\n"
                   "</Body>\n"
                   "</Envelope>\n",userHash,AppraisalID,emailIDs,vinNum];
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SendFowardAppraisalEmails",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}


+(NSMutableURLRequest*)saveExteriorImages:(NSString*)userHash andImagesArray:(NSMutableArray*) arrmExteriorImages andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum andExteriorVaueID:(NSString*) exteriorValueID
{
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveExteriorImage xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<ExteriorImageXML>\n"
                   "<ExteriorImage xmlns=\"http://tempuri.org/\">\n"
                   "<Images>\n",userHash];
    
    
    for (NSDictionary *dictData in arrmExteriorImages)
    {
        
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Image><ExteriorValueId>%@</ExteriorValueId>\n<ExteriorImage>%@</ExteriorImage>\n</Image>",exteriorValueID,[dictData objectForKey:@"ExteriorImage"]]];
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</Images>\n<RootInfo>\n<AppraisalId>%@</AppraisalId>\n<ClientId>%@</ClientId>\n<VinNumber>%@</VinNumber>\n</RootInfo>\n",AppraisalID,ClientID,vinNum]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</ExteriorImage>\n</ExteriorImageXML>\n</SaveExteriorImage>\n</Body></Envelope>"]];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveExteriorImage",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest*)saveVehicleExtras:(NSString*)userHash andExtrasArray:(NSMutableArray*) arrmExtrasArray andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum andVehicleExtraID:(int) vehicleExtraID andComments:(NSString*) comments
{
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveVehicleExtras xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<VehicleExtrasXML>\n"
                   "<VehicleExtras xmlns=\"http://tempuri.org/\">\n"
                   "<Items>\n",userHash];
    
    
    for (NSDictionary *dictData in arrmExtrasArray)
    {
        
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Extra><VehicleExtraItemId>%@</VehicleExtraItemId>\n<IsActive>%@</IsActive>\n<Name>%@</Name>\n<Price>%@</Price>\n</Extra>",[dictData objectForKey:@"VehicleExtraItemId"],@"1",[dictData objectForKey:@"Name"],[dictData objectForKey:@"Price"]]];
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</Items>\n<RootInfo>\n<AppraisalId>%@</AppraisalId>\n<VehicleExtraID>%d</VehicleExtraID>\n<ClientId>%@</ClientId>\n<VinNumber>%@</VinNumber>\n<Comments>%@</Comments>\n</RootInfo>\n",AppraisalID,vehicleExtraID,ClientID,vinNum,comments]];
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</VehicleExtras>\n</VehicleExtrasXML>\n</SaveVehicleExtras>\n</Body></Envelope>"]];
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveVehicleExtras",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}


+(NSMutableURLRequest*)sendOfferGetDetailsWithUserHash:(NSString*)userHash andYear:(int)year andMakeID:(int)makeID andModelID:(int)modelID andVariantID:(int)variantID andAppraisalID:(int)appraisalID andSendOfferID:(int) sendOfferID andVinNum:(NSString*) vinNum
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SendOfferViewMessage xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<Year>%d</Year>"
                             "<MakeId>%d</MakeId>"
                             "<ModelId>%d</ModelId>"
                             "<VariantId>%d</VariantId>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<SendOfferId>%d</SendOfferId>"
                             "<VinNumber>%@</VinNumber>"
                             "</SendOfferViewMessage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,makeID,modelID,variantID,appraisalID,sendOfferID, vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SendOfferViewMessage",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)saveAndSendOfferWith:(NSString*)userHash andYear:(NSString*) year andMakeID:(NSString*) makeID andModelID:(NSString*) modelID andVariantId:(NSString*) variantId andSellerName:(NSString*) sellerName andSellerSurname:(NSString*) sellerSurname andCompany:(NSString*) company andEmailID:(NSString*) emailID andMobileNum:(NSString*) mobileNum andOffer:(NSString*) offer andExpiresIn:(NSString*) expiresIn andSubjectArray:(NSMutableArray*) arrmSubject andSMSNumbers:(NSString*) smsNums andSMSFlag:(NSString*) smsFlag andEmailIDs:(NSString*) emailIDs andEmailSendOfferFlag:(NSString*) emailSendOfferFlag andEmailSendCopyFlag:(NSString*) emailSendCopyFlag andAppraisalID:(NSString*) AppraisalID  andClientID:(NSString*) ClientID andVinNum:(NSString*) vinNum
{
    
    NSString *soapMessage;
    
    soapMessage = [NSString stringWithFormat:
                   @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                   "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                   "<Body>"
                   "<SaveAndSendOffer xmlns=\"http://tempuri.org/\">"
                   "<UserHash>%@</UserHash>\n"
                   "<SaveAndSendOfferXML>\n"
                   "<SendOffer xmlns=\"http://tempuri.org/\">\n"
                   "<CarInfo>\n"
                   "<Year>%@</Year>\n"
                   "<MakeId>%@</MakeId>\n"
                   "<ModelId>%@</ModelId>\n"
                   "<VariantId>%@</VariantId>\n"
                   "</CarInfo>\n"
                   "<SellerInfo>\n"
                   "<Name>%@</Name>\n"
                   "<Surname>%@</Surname>\n"
                   "<Company>%@</Company>\n"
                   "<Email>%@</Email>\n"
                   "<Mobile>%@</Mobile>\n"
                   "</SellerInfo>\n"
                   "<Offer>%@</Offer>\n"
                   "<OfferExpiresIn>%@</OfferExpiresIn>\n"
                   "<SubjectTo>\n",userHash,year,makeID,modelID,variantId,sellerName,sellerSurname,company,emailID,mobileNum,offer,expiresIn];
    
    
    for (int i = 0; i< arrmSubject.count; i++)
    {
        
        soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"<Subject><text>%@</text>\n</Subject>",[arrmSubject objectAtIndex:i]]];
        
    }
    
    soapMessage = [soapMessage stringByAppendingString:[NSString stringWithFormat:@"</SubjectTo>\n<SMS>\n<SMSNumbers>%@</SMSNumbers>\n<SMSFlag>%@</SMSFlag>\n</SMS>\n<Email>\n<SendCopyTo>%@</SendCopyTo>\n<EmailSendCopyToFlag>%@</EmailSendCopyToFlag>\n<EmailSendOfferFlag>%@</EmailSendOfferFlag>\n</Email>\n<RootInfo>\n<AppraisalId>%@</AppraisalId>\n<ClientId>%@</ClientId>\n<VinNumber>%@</VinNumber>\n</RootInfo>\n</SendOffer>\n</SaveAndSendOfferXML>\n</SaveAndSendOffer>\n</Body>\n</Envelope>\n",smsNums,smsFlag,emailIDs,emailSendOfferFlag,emailSendCopyFlag,AppraisalID,ClientID,vinNum]];
    
    
    NSLog(@"Auto Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveAndSendOffer",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}


+(NSMutableURLRequest*)getTheValuationPriceDetailsWithUserHash:(NSString*)userHash andAppraisalID:(int)appraisalID andVIN:(NSString*) vinNum
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ReturnValuation xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<AppraisalId>%d</AppraisalId>"
                             "<Vin>%@</Vin>"
                             "</ReturnValuation>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID,vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ReturnValuation",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)isGivenVINVerifiedWithUserHash:(NSString*)userHash andVIN:(NSString*) vinNum
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<IsVinVerified xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<vinNumber>%@</vinNumber>"
                             "</IsVinVerified>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,vinNum];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/IsVinVerified",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*)saveSellerInfoWithUserHash:(NSString*)userHash andAppraisalID:(int) appraisalID andCompany:(NSString*) company andEmailAddress:(NSString*) emailID andIDNumber:(NSString*) idNumber andMobileNum:(NSString*) mobileNum andName:(NSString*) name andSurname:(NSString*) surname andSellerID:(int) sellerID andClientID:(int) clientID andVIN:(NSString*) vinNum andStreetAddrs:(NSString*) streetAddress
{
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<SaveSellerInformation xmlns=\"%@/\">"
                             "<UserHash>%@</UserHash>"
                             "<SellerInformationXML>\n"
                             "<SellerInfo>\n"
                             "<AppraisalId>%d</AppraisalId>"
                             "<Company>%@</Company>"
                             "<Email>%@</Email>"
                             "<IDNumber>%@</IDNumber>"
                             "<Mobile>%@</Mobile>"
                             "<Name>%@</Name>"
                             "<Surname>%@</Surname>"
                             "<SellerId>%d</SellerId>"
                             "<ClientId>%d</ClientId>"
                             "<VinNumber>%@</VinNumber>"
                             "<StreetAddress>%@</StreetAddress>"
                             "</SellerInfo>"
                             "</SellerInformationXML>"
                             "</SaveSellerInformation>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,appraisalID,company,emailID,idNumber,mobileNum,name,surname,sellerID,clientID,vinNum,streetAddress];
    
    NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/SaveSellerInformation",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}


#pragma mark - Updated webservices for EBrochure screens

+(NSMutableURLRequest*)listMakesForNewVehicle:(NSString*)userHash andClientID:(int)clientID year:(int)year
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListDealerMakesGenericXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<year>%d</year>"
                             "</ListDealerMakesGenericXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,year];
    
    // NSLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListDealerMakesGenericXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
    
}

+(NSMutableURLRequest*) listModelsForNewVehicles:(NSString *) userHash
                                            Year:(int)year
                                          makeId:(int)makeId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListModelsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<makeID>%d</makeID>"
                             "</ListModelsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,makeId];
    
    DLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListModelsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*) listActiveModelsForNewVehicles:(NSString *) userHash
                                                  Year:(int)year
                                                makeId:(int)makeId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListActiveModelsXML xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<makeID>%d</makeID>"
                             "</ListActiveModelsXML>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,year,makeId];
    
    NSLog(@"Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListActiveModelsXML",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}

+(NSMutableURLRequest*) listVariantsForNewVehicles:(NSString *) strUserHash Year:(int)year withModel:(int) iModelId
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                             "<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListVariantsJSON xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<year>%d</year>"
                             "<modelID>%d</modelID>"
                             "</ListVariantsJSON>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,strUserHash,year,iModelId];
    
    DLog(@"****** Soap Message : %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: [NSString stringWithFormat:@"%@/%@/ListVariantsJSON",WEB_SERVICE_TEMPURI,WEB_SERVICE_ISTOCK_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    return request;
}



+(NSMutableURLRequest *)brochureCheckHasProfilePic:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<HasProfileImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</HasProfileImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    
    // NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/HasProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest *)brochureUpdateProfilePic:(NSString*)userHash andImageFileName:(NSString*) fileName andBase64String:(NSString*) base64String
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateProfileImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<imageFilename>%@</imageFilename>"
                             "<base64EncodedString>%@</base64EncodedString>"
                             "</UpdateProfileImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash, fileName, base64String];
    
    
    // NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/UpdateProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest *)brochureGetProfilePic:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetProfileImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</GetProfileImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    
    // NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/GetProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest *)getTheStockSummaryWith:(NSString*)userHash andClientID:(int) clientID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<StockSummary xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "</StockSummary>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash, clientID];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/StockSummary" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
    
}

+(NSMutableURLRequest *)sendStockSummaryEmailsWith:(NSString*)userHash andclientID:(int) clientID andusedExcluded:(BOOL) usedExcluded andusedInvalid:(BOOL) usedInvalid andnewExcluded:(BOOL) newExcluded andnewInvailid:(BOOL) newInvailid andrecipientslist:(NSString*) recipientslist
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<StockSummaryEmailList xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<clientID>%d</clientID>"
                             "<usedExcluded>%d</usedExcluded>"
                             "<usedInvalid>%d</usedInvalid>"
                             "<newExcluded>%d</newExcluded>"
                             "<newInvailid>%d</newInvailid>"
                             "<recipientslist>%@</recipientslist>"
                             "</StockSummaryEmailList>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,clientID,usedExcluded,usedInvalid,newExcluded,newInvailid,recipientslist];
    
    
    // NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self stockWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IStockService/StockSummaryEmailList" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

/////////////////////////////////Monami/////////////////////////////////////////
///////////////////////Upload Profile Img WS/////////////////////////////////////

+(NSMutableURLRequest *)UpdateProfileImageWith:(NSString*)userHash andimageFilename:(NSString*) imageFilename andbase64EncodedString:(NSString*) base64EncodedString
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<UpdateProfileImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<imageFilename>%@</imageFilename>"
                             "<base64EncodedString>%@</base64EncodedString>"
                             "</UpdateProfileImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,imageFilename,base64EncodedString];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IElectronicBrochureGeneratorService/UpdateProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

///////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////Monami/////////////////////////////////////////
///////////////////////ImageAvailability Check WS/////////////////////////////////////

+(NSMutableURLRequest *)ImageAvailableOrNot:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<HasProfileImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</HasProfileImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IElectronicBrochureGeneratorService/HasProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}
////////////// Get profile Image WS
+(NSMutableURLRequest *)GetProfileImage:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<GetProfileImage xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</GetProfileImage>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    
    NSLog(@"save Activity Soap Meassge is  %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self eBrochureWebService]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue: @"http://tempuri.org/IElectronicBrochureGeneratorService/GetProfileImage" forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
    
}

+ (NSMutableURLRequest*)loadRequestType:(NSString*)userHash
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<ListRequestType xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "</ListRequestType>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash];
    
    NSLog(@"RequestType request = %@",soapMessage);
    
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/ListRequestType",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return request;
}

+ (NSMutableURLRequest*)logNewSupportRequestWith:(NSString*)userHash andRequestType:(int) requestID andRequestTitle:(NSString*) requestTitle andRequestDetails:(NSString*) requestDetails
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<LogNewSupportRequest xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<ticketType>%d</ticketType>"
                             "<ticketTitle>%@</ticketTitle>"
                             "<ticketDetails>%@</ticketDetails>"
                             "</LogNewSupportRequest>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,requestID,requestTitle,requestDetails];
    
    NSLog(@"RequestType request = %@",soapMessage);
    
    //NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self authenticateWebserviceUrl]]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/LogNewSupportRequest",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return request;
}


+ (NSMutableURLRequest*)saveTheSupportRequestDocumentsWith:(NSString*)userHash andbase64DocString:(NSString*) base64String andFileName:(NSString*) fileName andPlanTaskID:(int) planTaskID
{
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<Envelope xmlns=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<Body>"
                             "<NewSupportRequestDoc xmlns=\"%@/\">"
                             "<userHash>%@</userHash>"
                             "<bas64Doc>%@</bas64Doc>"
                             "<fileName>%@</fileName>"
                             "<planTaskID>%d</planTaskID>"
                             "</NewSupportRequestDoc>"
                             "</Body>"
                             "</Envelope>",WEB_SERVICE_TEMPURI,userHash,base64String,fileName,planTaskID];
    
    NSLog(@"Docs request = %@",soapMessage);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[self plannerWebserviceUrl]]];
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    [request addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:[NSString stringWithFormat:@"%@/%@/NewSupportRequestDoc",WEB_SERVICE_TEMPURI,WEB_SERVICE_IPLANNER_SERVICE] forHTTPHeaderField:@"SOAPAction"];
    [request addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    return request;
}







//////////////////////////////////////   END   ////////////////////////////////////

@end

