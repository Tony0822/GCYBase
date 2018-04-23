//
//  GCYNetworkConfigure.h
//  GCYBase
//
//  Created by gaochongyang on 2018/4/23.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GCYAPIRequestHttpMethod)
{
    GCYAPIRequestGET = 0,
    GCYAPIRequestPOST = 1 << 0,
    GCYAPIRequestDELETE = 1 << 1,
    GCYAPIRequestPUT = 1 << 2,
    
    GCYAPIRequestPOSTFILE = 1 << 3,
    GCYAPIRequestOtherGET = 1 << 4,
    GCYAPIRequestOtherPOST = 1 <<5,
    GCYAPIRequestNoJsonGET = 1 << 6,
    GCYAPIRequestNoJsonPOST = 1 << 7,
};

typedef NS_ENUM(NSUInteger, GCYAFNetworkingRequestType) {
    GCYAFNetworkingRequestTypeJson = 0,
    GCYAFNetworkingRequestTypeHttp = 1,
    GCYAFNetworkingRequestTypeImage = 2,
};

@interface GCYNetworkConfigure : NSObject

@end
