//
//  PWSetTagsRequest.m
//  Pushwoosh SDK
//  (c) Pushwoosh 2012
//

#import "PWSetTagsRequest.h"

@implementation PWSetTagsRequest
@synthesize tags;

- (NSString *) methodName {
	return @"setTags";
}

- (NSDictionary *) requestDictionary {
	NSMutableDictionary *dict = [self baseDictionary];
	NSMutableArray *encodedTagsBuilder = [NSMutableArray new];
	
	for (NSString *key in [tags allKeys]) {
		NSString *valueString;
		NSObject *value = [tags objectForKey:key];
		
		if ([value isKindOfClass:[NSString class]]) {
			valueString = [self encodeString:(NSString *) value];
		} else {
			valueString = [self encodeObject:value];
		}
		
		[encodedTagsBuilder addObject:[NSString stringWithFormat:@"%@:%@", [self encodeString: key], valueString]];
	}

	
	NSString *encodedTags = [NSString stringWithFormat:@"{%@}", [encodedTagsBuilder componentsJoinedByString:@", "]];
	[dict setObject:encodedTags forKey:@"tags"];
	
	[encodedTagsBuilder release]; encodedTagsBuilder = nil;
	return dict;
}
- (void) dealloc {
	self.tags = nil;
	[super dealloc];
}

@end
