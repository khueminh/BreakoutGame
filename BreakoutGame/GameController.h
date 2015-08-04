//
//  GameController.h
//  BreakoutGame
//
//  Created by Nguyen Minh Khue on 8/2/15.
//  Copyright (c) 2015 Nguyen Minh Khue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface GameController : UIViewController
{
    //UILabel *scoreLabel;
    int score;
    
    int screenWidth, screenHeight;
    
    //UIImageView *ball;
    
    CGPoint ballMovement;
    CGFloat ballVelocity;
    CGFloat ballVelocityYNew;
    CGFloat ballVelocityX;
    BOOL wallHit;
    int brickNumberHit;
    
    //UIImageView *paddle;
    CGFloat halfWidth, halfHeight, ballRadius;
    float touchOffset;
    
    int lives;
    //UILabel *livesLabel;
    
    int selectedLevel;
    float volume;
    float musicVolume;
    
    UIButton *menuButton;
    
    NSMutableArray * brickArray;
    NSTimer *timer;
    
    AVAudioPlayer *player1;
    AVAudioPlayer *player2;
    AVAudioPlayer *musicPlayer;
    
    UIImageView *powerUp;
    BOOL powerUpFlag;
    int powerUpType;
    int powerUpTimer;
    BOOL reverse;
}
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (weak, nonatomic) IBOutlet UIImageView *ball;

@property (weak, nonatomic) IBOutlet UIImageView *paddle;

@property (weak, nonatomic) IBOutlet UILabel *livesLabel;

@property (nonatomic, weak) IBOutlet UILabel *levelLabel;

- (void)loadAudio;
- (void)initializeTimer;
- (void)animateBall:(NSTimer *) theTimer;
- (void)resetBall;
- (void)loadBricks;
- (void)initializeValues;
- (void)gameOverAlertView;
- (void)finishGameAlertView;
- (void)loadBackground;
- (void) resetPowerUp;

@end


