
#import "Post.h"
#import "User.h"

#import "TwitterClient.h"

@implementation Post
@synthesize postID = _postID;
@synthesize text = _text;
@synthesize user = _user;

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _postID = [[attributes valueForKeyPath:@"id"] integerValue];
    _text = [attributes valueForKeyPath:@"text"];
    
    NSDictionary *userAttributes = @{@"id":[attributes valueForKeyPath:@"from_user_id"],@"username":[attributes valueForKeyPath:@"from_user"],@"avatar_image.url":[attributes valueForKeyPath:@"profile_image_url"]};
    
    _user = [[User alloc] initWithAttributes:userAttributes];
    
    return self;
}

#pragma mark -

+ (void)globalTimelinePostsWithBlock:(NSString *)query forQuery:(void (^)(NSArray *posts, NSError *error))block {
    [[TwitterClient sharedClient] getPath:[NSString stringWithFormat:@"search.json?q=%@", query] parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        //NSLog(@"%@", JSON);
        NSArray *postsFromResponse = [JSON valueForKeyPath:@"results"];
        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
        for (NSDictionary *attributes in postsFromResponse) {
            Post *post = [[Post alloc] initWithAttributes:attributes];
            [mutablePosts addObject:post];
        }
        
        if (block) {
            block([NSArray arrayWithArray:mutablePosts], nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block([NSArray array], error);
        }
    }];
}

@end
