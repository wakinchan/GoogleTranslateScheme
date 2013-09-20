// 
// GoogleTranslateScheme
// Test (Google Translate version 2.0.0.6287)
// 
// based on Daijirin-ActionMenu-Plugin
// https://github.com/r-plus/Daijirin-ActionMenu-Plugin/blob/master/Tweak.xm
// 

#define kURLScheme "googletranslate://translateText?q="

@interface TextTranslator : NSObject <UIApplicationDelegate>
- (id)initWithDelegate:(id)delegate userInfo:(id)info translateText:(id)text fromLanguage:(id)fromLang toLanguage:(id)toLang localeLanguage:(id)localeLang inputMethod:(int)method;
- (void)start;
@end

@interface TranslateViewController : UIViewController
@end

@interface GTRTabBarController : UIViewController
- (void)setSelectedIndex:(unsigned int)arg1;
@end

@interface TranslateAppDelegate : NSObject <UIApplicationDelegate>
@property(readonly) TranslateViewController * translateViewController;
@property(retain) GTRTabBarController * tabBarController;
@end

%hook TranslateAppDelegate
%new(c@:@@@@)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)application3 annotation:(id)annotation
{
    NSString *urlString = [url absoluteString];
    if ([urlString hasPrefix:@kURLScheme]) {
        NSString *query = [urlString substringFromIndex:[@kURLScheme length]];
        NSString *decodedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                kCFAllocatorDefault,
                (CFStringRef)query,
                CFSTR(""),
                kCFStringEncodingUTF8);
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [[languages objectAtIndex:0] substringToIndex:2];

        TextTranslator *tt = [[%c(TextTranslator) alloc] initWithDelegate:self.translateViewController
                                                                 userInfo:nil
                                                            translateText:decodedString
                                                             fromLanguage:@"auto"
                                                               toLanguage:currentLanguage
                                                           localeLanguage:@"en"
                                                              inputMethod:0];
        [tt start];
        [self.tabBarController setSelectedIndex:0];
        [decodedString release];

        return YES;
    } else {
        return NO;
    }
}
%end
