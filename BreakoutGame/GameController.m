//
//  GameController.m
//  BreakoutGame
//
//  Created by Nguyen Minh Khue on 8/2/15.
//  Copyright (c) 2015 Nguyen Minh Khue. All rights reserved.
//

#import "GameController.h"

@interface GameController ()

@end

@implementation GameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeValues];
    
    selectedLevel=1;
    
    timer=nil;
    
    //Phan thuong
    powerUpFlag = NO;
    
    self.levelLabel.hidden = NO;
    self.levelLabel.text = [NSString stringWithFormat:@"Level: %d", selectedLevel];
    
    [self loadBricks];
    [self loadAudio];
    [self initializeTimer];
    self.paddle.userInteractionEnabled=true;
    [self.paddle addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(onDragBar:)]];
}

- (void) gameOverAlertView {
    [self pauseGame];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chia buồn!" message:@"Bạn chơi kém quá, cố gắng lên!" delegate:self cancelButtonTitle:nil otherButtonTitles: @"Chơi lại", @"Thoát", nil];
    alert.tag = 1;
    [alert show];
}

- (void) finishGameAlertView {
    [self pauseGame];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Chúc mừng!" message:@"Bạn đã chiến thắng, cũng giỏi đấy!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    alert.tag=2;
    [alert show];
}

- (void) pauseAlertView {
    [self pauseGame];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tạm dừng" message:@"" delegate:self cancelButtonTitle:@"Chơi tiếp"  otherButtonTitles:nil, nil];
    alert.tag = 3;
    [alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 1) { //GAME OVER
        if (buttonIndex == 0) {
            //CHOI LAI
            score = 0;
            [self stopSounds];
            [self viewDidLoad];
            [self resetPowerUp];
            [self resetBall];
            
        } else if (buttonIndex == 1) { //KHONG CHOI NUA
            [musicPlayer stop];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }
    } else if (actionSheet.tag == 1) { //PHA DAO TRO CHOI
        if (buttonIndex == 0) {
            [musicPlayer stop];
            [self dismissViewControllerAnimated:YES completion:nil];

        }
    } else if (actionSheet.tag == 3) { //Tạm dừng trò chơi
        if (buttonIndex == 0) { //Chơi tiếp
            [musicPlayer play];
            [self initializeTimer];
        }
    }
}

- (void) stopSounds {
    //[musicPlayer stop];
    [player1 pause];
    [player2 pause];
}


-(void) pauseGame {
    [musicPlayer pause];
    //tam dung bong
    [timer invalidate];
}

- (void)initializeValues {
    
    
    //set volume
    volume = 1;
    musicVolume = 1;

    score = 0;
    lives = 1;
    
    self.livesLabel.text = [NSString stringWithFormat:@"%d", lives];
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    ballVelocity = 8;
    ballVelocityX = 1;
    
    //Chieu thanh do
    halfWidth = self.paddle.image.size.width / 2;
    halfHeight = self.paddle.image.size.height / 2;
    
    //Ban kinh qua bong
    ballRadius = self.ball.image.size.height / 2;
    
    //kich thuoc man hinh
    screenWidth = self.view.bounds.size.width;
    screenHeight = self.view.bounds.size.height;
    
    //So luong bong da va cham
    brickNumberHit = -1;
    
    [self loadBackground];
}

- (void)initializeTimer {
    float interval = 1.0 / 30.0;

    timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(animateBall:) userInfo:nil repeats:YES];
}

- (void)loadBricks {
    brickArray = [[NSMutableArray alloc] init];
    //Level 1
    CGFloat xInit = 40;
    CGFloat yInit = 80;
    
    
    CGFloat xOffset = 60;
    CGFloat yOffset = 40;
        
    for (int i=1;i<4;i++){
        if (i!=2){
        
            UIImageView *brickImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red brick.png"]];
            brickImage.center = CGPointMake(xInit + xOffset*i, yInit + yOffset*0);
            [brickArray addObject:brickImage];
            [self.view addSubview:brickImage];
        }
    }
    
    for (int i=0;i<5;i++){
        UIImageView *brickImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red brick.png"]];
        brickImage.center = CGPointMake(xInit + xOffset*i, yInit + yOffset*1);
        [brickArray addObject:brickImage];
        [self.view addSubview:brickImage];
    }
    
    for (int i=0;i<5;i++){
        UIImageView *brickImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red brick.png"]];
        brickImage.center = CGPointMake(xInit + xOffset*i, yInit + yOffset*2);
        [brickArray addObject:brickImage];
        [self.view addSubview:brickImage];
    }
    
    for (int i=1;i<4;i++){
        UIImageView *brickImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red brick.png"]];
        brickImage.center = CGPointMake(xInit + xOffset*i, yInit + yOffset*3);
        [brickArray addObject:brickImage];
        [self.view addSubview:brickImage];
    }
    
    for (int i=2;i<3;i++){
        UIImageView *brickImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red brick.png"]];
        brickImage.center = CGPointMake(xInit + xOffset*i, yInit + yOffset*4);
        [brickArray addObject:brickImage];
        [self.view addSubview:brickImage];
    }
    
}

- (void)animateBall:(NSTimer *) theTimer {

    self.ball.center = CGPointMake(self.ball.center.x + ballMovement.x, self.ball.center.y + ballMovement.y);

    //Co phan thuong
    if(powerUpFlag){
        powerUp.center = CGPointMake(powerUp.center.x , powerUp.center.y + 1);
    }
    
    //Het tac dung cua phan thuong
    if(powerUpTimer>=10*30){
        powerUpTimer=0;
        reverse = NO;
        // het thoi gian nhan thuong, tro ve trang thai binh thuong
        CGFloat sign = 1;
        if (ballMovement.y < 0) {
            sign = -1;
        }
        ballMovement = CGPointMake(ballMovement.x, ballVelocity*sign);
    }
    
    //Tang bien dem thoi gian nhan thuong
    powerUpTimer++;
    
    //Neu an phan thuong
    if(CGRectIntersectsRect(self.paddle.frame, powerUp.frame) && powerUpFlag){
        powerUp.alpha = 0;
        powerUpFlag = NO;
        
        
        //Phan thuong tang luot choi
        if (powerUpType==1){
            lives++;
            self.livesLabel.text = [NSString stringWithFormat:@"%d", lives];
        }
        
        //Phan thuong tang toc do bong
        else if(powerUpType==2){
            CGFloat sign = 1;
            if (ballMovement.y < 0) {
                sign = -1;
            }
            ballMovement = CGPointMake(ballMovement.x, 12*sign);
            
        }
    }
    
    
    //Neu khong an duoc phan thuong
    if (powerUp.center.y > screenHeight){
        if(powerUpFlag){
            powerUpFlag = NO;
            powerUp.alpha = 0;
        }
    }
    
    // Bong cham vao thanh do
    if (self.ball.center.y < self.paddle.center.y) {
        
        // Kiem tra va cham o cac mat (mat tren, mat trai, mat phai) mat duoi thi khong can
        BOOL paddleCollision = self.ball.center.y >= self.paddle.center.y - halfHeight - ballRadius &&
        self.ball.center.x > self.paddle.center.x - halfWidth - ballRadius &&
        self.ball.center.x < self.paddle.center.x + halfWidth + ballRadius;
        
        //Neu va cham
        if(paddleCollision) {
            [player1 play];
            
            //Bong doi chieu
            ballMovement.y = -ballMovement.y;
            ballMovement.x = (self.ball.center.x - self.paddle.center.x) / 4;
        }
    }
    
    // Kiem tra bong va cham 2 ben trai phai
    if (self.ball.center.x < ballRadius || self.ball.center.x > screenWidth - ballRadius){
        [player1 play];
        wallHit = YES;
        ballMovement.x = -ballMovement.x;
    }
    
    // Bong cham len dinh
    if (self.ball.center.y < ballRadius + 40){
        [player1 play];
        wallHit = YES;
        ballMovement.y = -ballMovement.y;
    }
    
    
    // Bong roi xuong day man hinh (khong do duoc bong)
    if (self.ball.center.y > screenHeight + ballRadius) {
        lives--;
        
        if(lives >= 0){
            self.livesLabel.text = [NSString stringWithFormat:@"%d", lives];
        } else {
            // GAME OVER
            [timer invalidate];
            timer=nil;
            [self gameOverAlertView];
        }
        
        //Choi lai, bong lai ve giua thanh do
        [self resetBall];
        ballMovement = CGPointMake(0, 0);
        self.ball.center = CGPointMake(self.paddle.center.x, self.paddle.center.y-halfHeight - ballRadius - 1);
    }
    
    
    // Bong va cham vao gach
    int bricksGone = 0; //So luong bach da va cham
    int brickNumberInArray = 0;
    
    for (UIImageView *thisBrick in brickArray) {
        brickNumberInArray++;
        
        //Gach con hien thi moi kiem tra tiep
        if (thisBrick.alpha >= 0.05) {
            
            //Giao nhau giua bong va gach
            if (CGRectIntersectsRect(self.ball.frame, thisBrick.frame)) {
                wallHit = NO;
                
                //Do rong cua hinh chu nhat cac canh
                CGFloat rectBuffer = 1;
                
                
                //Chia vien gach ra lam 4 hinh chu nhat do rong = 1
                CGRect up = CGRectMake(thisBrick.frame.origin.x, thisBrick.frame.origin.y, thisBrick.frame.size.width-rectBuffer, thisBrick.frame.size.height/4);
                
                CGRect left = CGRectMake(thisBrick.frame.origin.x, thisBrick.frame.origin.y + thisBrick.frame.size.height/4+rectBuffer, thisBrick.frame.size.width/4, thisBrick.frame.size.height/2-rectBuffer*2);
                
                CGRect right = CGRectMake(thisBrick.frame.origin.x+(thisBrick.frame.size.width/4)*3, thisBrick.frame.origin.y + thisBrick.frame.size.height/4+rectBuffer, thisBrick.frame.size.width/4, thisBrick.frame.size.height/2-rectBuffer*2);
                
                //Cham ben trai
                if (CGRectIntersectsRect(self.ball.frame, left)) {
                    if (ballMovement.x >= 0) {
                        ballMovement.x = -ballMovement.x;
                    }
                } //Cham ben phai
                else if (CGRectIntersectsRect(self.ball.frame, right)) {
                    if (ballMovement.x <= 0) {
                        ballMovement.x = -ballMovement.x;
                    }
                } //cham ben tren
                else if (CGRectIntersectsRect(self.ball.frame, up)){
                    if (ballMovement.y >= 0) {
                        ballMovement.y = -ballMovement.y;
                    }
                } //cham ben duoi
                else {
                    if (ballMovement.y <= 0) {
                        ballMovement.y = -ballMovement.y;
                    }
                    
                    else {
                        NSLog(@"Toa do hien tai %f %f %f %f", ballMovement.x, ballMovement.y, self.ball.center.x, self.ball.center.y);
                    }
                }
                
                [player2 play];
                //giam alpha cua vien gach
                thisBrick.alpha -= (CGFloat)1/2;
                
                //tang diem
                score +=100;

                [self.scoreLabel setText:[NSString stringWithFormat:@"%d", score]];
                
                //Phan thuong
                float random = arc4random()%100;
                int yPowerPos = 60;
                
                //Phan thuong tang luot choi
                if(random >85 && !powerUpFlag){
                    powerUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"life.png"]];
                    powerUpFlag = YES;
                    powerUpType=1;
                    
                    [self.view addSubview:powerUp];
                    random = arc4random()%250 + 20;
                    powerUp.center = CGPointMake(random, yPowerPos);
                    powerUp.alpha = 1;
                } //Phan thuong tang toc do bong
                else if (random < 85 && random >65 && !powerUpFlag){
                    powerUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fast.png"]];
                    powerUpFlag = YES;
                    powerUpType=2;
                    powerUpTimer = 0;
                    
                    [self.view addSubview:powerUp];
                    random = arc4random()%250 + 20;
                    powerUp.center = CGPointMake(random, yPowerPos);
                    powerUp.alpha = 1;
                }
            }
        }
        else {
            thisBrick.alpha = 0;
            bricksGone++;
        }
    }
   
    //Da pha vo het cac gach
    if (bricksGone >= [brickArray count]) {
        [timer invalidate];
        timer=nil;
        [self resetPowerUp];
        [self finishGameAlertView];
        
    }
}

- (void)loadAudio {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"wallAndPaddle" ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: filePath];
    player1 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    filePath = [[NSBundle mainBundle] pathForResource:@"music" ofType:@"mp3"];
    fileURL = [[NSURL alloc] initFileURLWithPath: filePath];
    musicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    musicPlayer.numberOfLoops = -1;
    
    [musicPlayer play];

    filePath = [[NSBundle mainBundle] pathForResource:@"bricks" ofType:@"wav"];
    fileURL = [[NSURL alloc] initFileURLWithPath: filePath];
    player2 = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    [player1 prepareToPlay];
    [player2 prepareToPlay];
}

- (void)resetBall {
    ballMovement = CGPointMake(0, 0);
    self.ball.center = CGPointMake(self.paddle.center.x, self.paddle.center.y-halfHeight - ballRadius - 1);
}

- (void) resetPowerUp{
    powerUp.alpha = 0;
    powerUpFlag = NO;
}

- (void) onDragBar:(UIPanGestureRecognizer *) gestureRecognizer{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        if (ballMovement.y == 0) {
            ballMovement = CGPointMake(ballVelocityX, ballVelocity);
        }
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
        
        CGRect recognizerFrame = gestureRecognizer.view.frame;
        recognizerFrame.origin.x += translation.x;
        
        if (CGRectContainsRect(self.view.bounds, recognizerFrame)) {
            gestureRecognizer.view.frame = recognizerFrame;
        }
        else{
            if (recognizerFrame.origin.x < self.view.bounds.origin.x) {
                recognizerFrame.origin.x = 0;
            }
            else if (recognizerFrame.origin.x + recognizerFrame.size.width > self.view.bounds.size.width) {
                recognizerFrame.origin.x = self.view.bounds.size.width - recognizerFrame.size.width;
            }
        }
        
        [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:gestureRecognizer.view];
    }
    
}

- (void)viewDidUnload
{
    [player1 stop];
    [player2 stop];
    [musicPlayer stop];
}

- (void)loadBackground {
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"breakout background.png"]];
}

- (IBAction)PauseClick:(id)sender {
    [self pauseAlertView];
}

@end
