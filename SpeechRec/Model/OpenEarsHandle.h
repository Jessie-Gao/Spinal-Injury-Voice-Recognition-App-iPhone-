
//  Created by gj on 2016/10/10.
//  Copyright © 2016年 SpeechRec. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <OpenEars/OEEventsObserver.h>

@protocol OpenEarsHandleDelegate<NSObject>
    
-(void)received:(NSString *)text;

@end

@interface OpenEarsHandle : NSObject <OEEventsObserverDelegate>

@property (nonatomic, weak) id<OpenEarsHandleDelegate> delegate;


- (void) suspendListening ; // This is the action for the button which suspends listening without ending the recognition loop

- (void) resumeListening ; // This is the action for the button which resumes listening if it has been suspended

- (void) stop ;

- (void) start;

@end
