
#import <Foundation/Foundation.h>

@class User;

@interface Post : NSObject

@property (readonly) NSUInteger postID;
@property (readonly) NSString *text;

@property (readonly) User *user;

- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)globalTimelinePostsWithBlock:(NSString *)query forQuery:(void (^)(NSArray *posts, NSError *error))block;

@end
