#include <stdint.h>
#import "../../build/ffigen/maplibre_flutter_map-Swift.h"

#if !__has_feature(objc_arc)
#error "This file must be compiled with ARC enabled"
#endif

id objc_retain(id);
id objc_retainBlock(id);

typedef void  (^ListenerBlock)(NSDictionary* , struct _NSRange , BOOL * );
ListenerBlock wrapListenerBlock_ObjCBlock_ffiVoid_NSDictionary_NSRange_bool(ListenerBlock block) NS_RETURNS_RETAINED {
  return ^void(NSDictionary* arg0, struct _NSRange arg1, BOOL * arg2) {
    block(objc_retain(arg0), arg1, arg2);
  };
}

typedef void  (^ListenerBlock1)(id , struct _NSRange , BOOL * );
ListenerBlock1 wrapListenerBlock_ObjCBlock_ffiVoid_objcObjCObject_NSRange_bool(ListenerBlock1 block) NS_RETURNS_RETAINED {
  return ^void(id arg0, struct _NSRange arg1, BOOL * arg2) {
    block(objc_retain(arg0), arg1, arg2);
  };
}

typedef void  (^ListenerBlock2)(NSDate* , BOOL , BOOL * );
ListenerBlock2 wrapListenerBlock_ObjCBlock_ffiVoid_NSDate_bool_bool(ListenerBlock2 block) NS_RETURNS_RETAINED {
  return ^void(NSDate* arg0, BOOL arg1, BOOL * arg2) {
    block(objc_retain(arg0), arg1, arg2);
  };
}

typedef void  (^ListenerBlock3)(NSTimer* );
ListenerBlock3 wrapListenerBlock_ObjCBlock_ffiVoid_NSTimer(ListenerBlock3 block) NS_RETURNS_RETAINED {
  return ^void(NSTimer* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock4)(NSFileHandle* );
ListenerBlock4 wrapListenerBlock_ObjCBlock_ffiVoid_NSFileHandle(ListenerBlock4 block) NS_RETURNS_RETAINED {
  return ^void(NSFileHandle* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock5)(NSDictionary* , NSError* );
ListenerBlock5 wrapListenerBlock_ObjCBlock_ffiVoid_NSDictionary_NSError(ListenerBlock5 block) NS_RETURNS_RETAINED {
  return ^void(NSDictionary* arg0, NSError* arg1) {
    block(objc_retain(arg0), objc_retain(arg1));
  };
}

typedef void  (^ListenerBlock6)(NSArray* );
ListenerBlock6 wrapListenerBlock_ObjCBlock_ffiVoid_NSArray(ListenerBlock6 block) NS_RETURNS_RETAINED {
  return ^void(NSArray* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock7)(NSTextCheckingResult* , NSMatchingFlags , BOOL * );
ListenerBlock7 wrapListenerBlock_ObjCBlock_ffiVoid_NSTextCheckingResult_NSMatchingFlags_bool(ListenerBlock7 block) NS_RETURNS_RETAINED {
  return ^void(NSTextCheckingResult* arg0, NSMatchingFlags arg1, BOOL * arg2) {
    block(objc_retain(arg0), arg1, arg2);
  };
}

typedef void  (^ListenerBlock8)(NSCachedURLResponse* );
ListenerBlock8 wrapListenerBlock_ObjCBlock_ffiVoid_NSCachedURLResponse(ListenerBlock8 block) NS_RETURNS_RETAINED {
  return ^void(NSCachedURLResponse* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock9)(NSDictionary* );
ListenerBlock9 wrapListenerBlock_ObjCBlock_ffiVoid_NSDictionary(ListenerBlock9 block) NS_RETURNS_RETAINED {
  return ^void(NSDictionary* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock10)(NSURLCredential* );
ListenerBlock10 wrapListenerBlock_ObjCBlock_ffiVoid_NSURLCredential(ListenerBlock10 block) NS_RETURNS_RETAINED {
  return ^void(NSURLCredential* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock11)(NSArray* , NSArray* , NSArray* );
ListenerBlock11 wrapListenerBlock_ObjCBlock_ffiVoid_NSArray_NSArray_NSArray(ListenerBlock11 block) NS_RETURNS_RETAINED {
  return ^void(NSArray* arg0, NSArray* arg1, NSArray* arg2) {
    block(objc_retain(arg0), objc_retain(arg1), objc_retain(arg2));
  };
}

typedef void  (^ListenerBlock12)(NSArray* );
ListenerBlock12 wrapListenerBlock_ObjCBlock_ffiVoid_NSArray1(ListenerBlock12 block) NS_RETURNS_RETAINED {
  return ^void(NSArray* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock13)(NSData* );
ListenerBlock13 wrapListenerBlock_ObjCBlock_ffiVoid_NSData(ListenerBlock13 block) NS_RETURNS_RETAINED {
  return ^void(NSData* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock14)(NSData* , BOOL , NSError* );
ListenerBlock14 wrapListenerBlock_ObjCBlock_ffiVoid_NSData_bool_NSError(ListenerBlock14 block) NS_RETURNS_RETAINED {
  return ^void(NSData* arg0, BOOL arg1, NSError* arg2) {
    block(objc_retain(arg0), arg1, objc_retain(arg2));
  };
}

typedef void  (^ListenerBlock15)(NSError* );
ListenerBlock15 wrapListenerBlock_ObjCBlock_ffiVoid_NSError(ListenerBlock15 block) NS_RETURNS_RETAINED {
  return ^void(NSError* arg0) {
    block(objc_retain(arg0));
  };
}

typedef void  (^ListenerBlock16)(NSURLSessionWebSocketMessage* , NSError* );
ListenerBlock16 wrapListenerBlock_ObjCBlock_ffiVoid_NSURLSessionWebSocketMessage_NSError(ListenerBlock16 block) NS_RETURNS_RETAINED {
  return ^void(NSURLSessionWebSocketMessage* arg0, NSError* arg1) {
    block(objc_retain(arg0), objc_retain(arg1));
  };
}

typedef void  (^ListenerBlock17)(NSData* , NSURLResponse* , NSError* );
ListenerBlock17 wrapListenerBlock_ObjCBlock_ffiVoid_NSData_NSURLResponse_NSError(ListenerBlock17 block) NS_RETURNS_RETAINED {
  return ^void(NSData* arg0, NSURLResponse* arg1, NSError* arg2) {
    block(objc_retain(arg0), objc_retain(arg1), objc_retain(arg2));
  };
}

typedef void  (^ListenerBlock18)(NSURL* , NSURLResponse* , NSError* );
ListenerBlock18 wrapListenerBlock_ObjCBlock_ffiVoid_NSURL_NSURLResponse_NSError(ListenerBlock18 block) NS_RETURNS_RETAINED {
  return ^void(NSURL* arg0, NSURLResponse* arg1, NSError* arg2) {
    block(objc_retain(arg0), objc_retain(arg1), objc_retain(arg2));
  };
}

typedef void  (^ListenerBlock19)(void * , NSObject* );
ListenerBlock19 wrapListenerBlock_ObjCBlock_ffiVoid_ffiVoid_NSObject(ListenerBlock19 block) NS_RETURNS_RETAINED {
  return ^void(void * arg0, NSObject* arg1) {
    block(arg0, objc_retain(arg1));
  };
}
