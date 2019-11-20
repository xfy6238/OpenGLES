//
//  GLKViewController.m
//  OpenGLES
//
//  Created by 胥福阳 on 2019/11/19.
//  Copyright © 2019 微光星芒. All rights reserved.
//

#import "GLBaseViewController.h"

@interface GLBaseViewController ()

//可以初始化兼容不同版本的OpenGL ES的上下文环境
@property (strong, nonatomic) EAGLContext *context;
@property (assign, nonatomic) GLuint shaderProgram;
@property (nonatomic,strong) GLKView *glView;
@property (assign, nonatomic) GLfloat elapsedTime;

@end

@implementation GLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupContext];
    [self setupShader];
}




- (void)setupContext {
    self.context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    GLKView *view = (GLKView *)self.view;

    self.glView = view;
    self.glView.context = self.context;
    
    //开启深度缓冲区
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
//    [EAGLContext setCurrentContext: self.context];
    [EAGLContext setCurrentContext:self.context];
}

//设置着色器
- (void)setupShader {
    NSString *vertexShaderPath = [[NSBundle mainBundle] pathForResource:@"vertex" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"fragment" ofType:@"glsl"];
    NSString *vertextShaderContent = [NSString stringWithContentsOfFile:vertexShaderPath encoding:NSUTF8StringEncoding error:nil];
    NSString *fragmenttShaderContent = [NSString stringWithContentsOfFile:fragmentShaderPath encoding:NSUTF8StringEncoding error:nil];

    //已经获得了两个着色器的字符串内容
    GLuint program;
    createProgram(vertextShaderContent.UTF8String,fragmenttShaderContent.UTF8String, &program);
    self.shaderProgram = program;
}

//MARK: Prepare Shders 自定义方法创建着色器程序
bool createProgram (const char *vertexShader, const char *fragmentShader, GLuint *pProgram) {
    GLuint program, vertShader, fragShader;

    //创建着色器程序
    program = glCreateProgram();
    
    //将传入的字符串 转为GLchar 类型
    const GLchar *vssource = (GLchar *)vertexShader;
    const GLchar *fssource = (GLchar *)fragmentShader;
    
    //是否编译成功(内部进行了着色器的编译)
    if (!complieShader(&vertShader, GL_VERTEX_SHADER, vssource)) {
        printf("Failed to complile vertex shader");
        return  false;
    }
    
    if (!complieShader(&fragShader, GL_FRAGMENT_SHADER, fssource)) {
        printf("Failed to compile fragment shader");
        return false;
    }
    
    //将编译的着色器附加到程序对象上
    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);
    
    //判断着色器程序是否链接成功
    //不论是否链接成功 ,需要将之前创建的 Vertext Shader 和 Fragment Shader 删除以释放不用的内存空间
    if (!linkProgram(program)) {
        printf("Failed to link program: %d", program);
                
        if (vertShader) {
            glDeleteShader(vertShader);
        }
        if (fragShader) {
             glDeleteShader(fragShader);
         }
        if (program) {
            glDeleteProgram(program);
        }
        return  false;
    }
    if (vertShader) {
        glDetachShader(program, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program, fragShader);
        glDeleteShader(fragShader);
    }
    *pProgram = program;
    printf("Effect build success => %d \n",program);
    return true;
}


//编译着色器
bool complieShader(GLuint *shader, GLenum type, const GLchar *source){
    GLuint status;
    if (!source) {
        printf("Failed to load vertext shader");
        return false;
    }
    //创建一个着色器对象(这里的 *好像可以去掉)?
    *shader = glCreateShader(type);
    
    //把着色器源码附加到着色器对象上
    glShaderSource(*shader, 1, &source, NULL);
    //编译着色器对象
    glCompileShader(*shader);
    

//    glGetShaderiv(<#GLuint shader#>, <#GLenum pname#>, <#GLint *params#>)
//    glShaderSource(<#GLuint shader#>, <#GLsizei count#>,
    
    //检测编译是否成功
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return  false;
    }
    return true;
}

bool linkProgram(GLuint prog){
    GLint status;
    //之前已经把着色器对象添加到程序上了, 然后链接它们
    glLinkProgram(prog);
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return  false;
    }
    return true;
}


//MARK: 代理方法 进行绘制

- (void)update {
    // 距离上一次调用update过了多长时间，比如一个游戏物体速度是3m/s,那么每一次调用update，
    // 他就会行走3m/s * deltaTime，这样做就可以让游戏物体的行走实际速度与update调用频次无关
    NSTimeInterval deltaTime = self.timeSinceLastUpdate;
    self.elapsedTime += deltaTime;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    //清空绘制
    glClearColor(1, 0.2, 0.2, 1);
    //只清楚缓存区的颜色部分
    glClear(GL_COLOR_BUFFER_BIT);
    
    //使用shader
    glUseProgram(self.shaderProgram);
    
    //设置shader 中的uniform elapsdTime的值
    GLuint elapsedTimeUniformLocation = glGetUniformLocation(self.shaderProgram, "elapsedTime");
    //glUniform1f 这里的1f表示传递一个 为float类型的参数
    glUniform1f(elapsedTimeUniformLocation, (GLfloat)self.elapsedTime);
    [self drawTriangle];
}

//MARK: 绘制
- (void)drawTriangle {
    static GLfloat triangleData[18] = {
        0,      0.5f, 0, 1, 0, 0,
        -0.5f, -0.5f, 0, 0, 1, 0,
        0.5f,  -0.5f, 0, 0, 0, 1,
    };
    //启动Shder的两个属性
    //attribute vec4 position
    //attribute vec4 color

    [self bindAttribs:triangleData];
}


- (void)bindAttribs:(GLfloat *)triangleData {
    //启用Shader的两个属性
    //attribute vec4 position
    //attribute vec4 color

    GLuint positionAtttribute = glGetAttribLocation(self.shaderProgram, "position");
    glEnableVertexAttribArray(positionAtttribute);
    GLuint colorAttribLocation = glGetAttribLocation(self.shaderProgram, "color");
    glEnableVertexAttribArray(colorAttribLocation);
    
    //为shader中的position和color赋值
    
    glVertexAttribPointer(positionAtttribute, 3, GL_FLOAT, GL_FALSE,6 * sizeof(GL_FLOAT), (char *)triangleData);

    glVertexAttribPointer(colorAttribLocation, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(GL_FLOAT), (char *)triangleData + 3 * sizeof(GL_FLOAT));
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
