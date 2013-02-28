

#import <Foundation/Foundation.h>

extern NSString * const kUserProfileImageDidLoadNotification;

@interface User : NSObject

@property (readonly, nonatomic) NSUInteger userID;
@property (readonly, nonatomic) NSString *username;
@property (readonly, nonatomic, unsafe_unretained) NSURL *avatarImageURL;

- (id)initWithAttributes:(NSDictionary *)attributes;

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
@property (nonatomic, strong) NSImage *profileImage;
#endif

@end
