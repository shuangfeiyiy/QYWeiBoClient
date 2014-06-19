#import <UIKit/UIKit.h>

char pinyinFirstLetter(unsigned short hanzi);

@interface ChineseToPinyin : NSObject {
    
}

+ (NSString *) pinyinFromChiniseString:(NSString *)string;
+ (char) sortSectionTitle:(NSString *)string; 

@end