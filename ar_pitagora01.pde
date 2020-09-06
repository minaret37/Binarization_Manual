import megamu.shapetween.*;
import processing.serial.*;

//ここから

Serial serialPort;  // Arduinoにデータを送るシリアルポート
boolean firstContact = false;  //Arduinoからのはじめの送信を確認する
byte[] inByte = new byte[3]; // 受信データ用バッファ

boolean arduinoOn = false; //Arduinoを使用するときはtrueにする。


//ここまで

void scene(int i){//シーン指定のＶＯＩＤ化
   switch(i){
    case 0:
    scene0();
    break;
    case 1:
    scene1();
    break;
    case 2:
    scene2();
    break;
    case 3:
    scene3();
    break;
    case 4:
    scene4();
    break;
    case 5:
    scene5();
    break;
    case 6:
    scene6();
    break;
    case 7:
    scene7();
    break;
    case 8:
    scene8();
    break;
    case 9:
    scene9();
    break;
    case 10:
    scene10();
    break;
    case 11:
    scene11();
    break;
    case 12:
    scene12();
    break;
    case 13:
    scene13();
    break;
    case 14:
    scene14();
    break; 
   }
}

int oval1; // サーボ1用変数
int oval2; // サーボ2用変数

int mono=0;

float el=80;//ellipse直径
float er=el/2;//ellipse半径

int i;

void setup() {
  //描画の基本設定
  noCursor();
  smooth();
  ellipseMode(CENTER);
  
  //スクリーン設定（フルスクリーンは後にあるsketchFullScreenメソッドの戻り値をtrueにする。）
  size(displayWidth, displayHeight);
  
  //ここから
  
  //Arduino設定
  if(arduinoOn){
    println(Serial.list()); // 使用可能なシリアルポート一覧の出力。デバッグ用
    String portName = Serial.list()[0]; // 使用するシリアルポート名
    serialPort = new Serial(this, portName, 9600);
    serialPort.buffer(inByte.length); // 読み込むバッファの長さをの指定
  }
  
  //ここまで
  
  
  //シーン設定
  setScene0();
  setScene1();
  setScene2();
  setScene3();
  setScene4();
  setScene5();
  setScene6();
  setScene7();
  setScene8();
  setScene9();
  setScene10();
  setScene11();
  setScene12();
  setScene13();
  setScene14();
  
  // アニメーションのリセットとゲートを閉じる
  reset();
}

void draw() { 
  // 初期描画
  background(0);
  fill(0);
  
   noStroke();
   
//ここから

if(arduinoOn){
    //text("oval1: "+oval1, 10, 20); // デバッグ用。実演時には非表示にすること
    //text("oval2: "+oval2, 10, 40); // デバッグ用。実演時には非表示にすること
  }

//ここまで



  // シーンの制御
  
  
  for(i=0;i<scene_num-2;i++){//シーンの再生に関する
    
    if(tween[i].isTweening()){ //シーン?が再生中
    scene(i);
  }else if(tween[i].time() == 1.0){ //シーン?が再生しきったら…
    startScene(i+1);
  }
  
  }
  
  
  if(tween[13].isTweening()){ //シーン13が再生中
    scene(13);
  }else if(tween[13].time() == 1.0){ //シーン13が再生しきったら…
    
    if(arduinoOn){
      oval1 = 120;
      sendServo(1, oval1);
    }
    
    startScene(14);
  }
  
  
  if(tween[14].isTweening()){ //シーン14が再生中
    scene(14);
  }else if(tween[14].time() == 1.0){ //シーン14が再生しきったら…
 
  }
  
  
  
}


  



void mousePressed(){
  if(mouseButton == LEFT){
      reset();
      startScene(0);
  } else if(mouseButton == RIGHT){
      reset();
  }
}

void keyPressed()//デバック用
{
  switch(key)
  {
    case ' ':
     reset();
     break;
    case '1':
     startScene(6);
     break;
    case '2':
     startScene(7);
     break;
    case '3':
     startScene(8);
     break;
    case '4':
     startScene(9);
     break;
    case '5':
     startScene(10);
     break;
    case '6':
     startScene(11);
     break;
    case '7':
     startScene(12);
     break;
    case '8':
     startScene(13);
     break;
    default:
     break;
  }
}

boolean sketchFullScreen(){
  return true;
}


//ここから


// 終了時に呼び出されるメソッド（綺麗に終了するため）
void stop()
{
  if(arduinoOn){
      oval1 = oval2 = 120;
      sendServo(1, oval1);
      sendServo(2, oval2);
  }
}



// シリアルポートにデータが受信されると呼び出されるメソッド
void serialEvent(Serial port) {
  inByte = port.readBytes();

  if(firstContact == false) {
    if(inByte[0] == 'C') {
      println("connect!");
      port.clear();
      firstContact = true;
      reset();
    }
  }
}

// シリアルポートにサーボの値を送るメソッド
void sendServo(int id, int value)
{
  if(!firstContact) return;
  int v = value;
  if(v < 15) v = 15; // サーボの最小値。個体差による。
  if(v > 125) v = 125; // サーボの最大値。個体差による。
  serialPort.write((byte)'S');
  serialPort.write((byte)id);
  serialPort.write((byte)v);
}


//ここまで



int scene_num = 14+1; //シーン数
int setscene_num=scene_num*2;
Tween[] tween = new Tween[setscene_num];
boolean[] played = new boolean[scene_num];

//アニメーションリセット
void reset()
{
  for(int i = 0; i < scene_num; i++)
  {
    tween[i].start();
    tween[i].pause();
    played[i] = false;
    tween[i+scene_num].start();
    tween[i+scene_num].pause();
  }
  
    
  if(arduinoOn){
    // サーボを初期化
    oval1 = oval2 = 20;
    sendServo(1, oval1); //ゲートを閉じる
    sendServo(2, oval2); //ゲートを閉じる
  }  
}

//シーン開始トリガー
void startScene(int i)
{
  if(!played[i]) {
   tween[i].start();
   tween[i+scene_num].start();
   played[i] = true;
  }
}

/*--------------------- シーン0関係 -------------------*/
void setScene0()
{
  //tween[0] = new Tween(this, 2, Tween.SECONDS, Shaper.BOUNCE);
  //tween[0] = new Tween(this, 2, Tween.SECONDS, Shaper.COSINE);
  //tween[0] = new Tween(this, 2, Tween.SECONDS, Shaper.CIRCULAR);
  //tween[0] = new Tween(this, 2, Tween.SECONDS, Shaper.LINEAR);
  tween[0] = new Tween(this, 2, Tween.SECONDS, Shaper.BEZIER);
  tween[0].pause();
  tween[scene_num] = new Tween(this, 1.2, Tween.SECONDS, Shaper.BOUNCE);
  tween[scene_num].pause();
}


void scene0()//上にバウンドする
{
  
  float sx = width;
  float sy = height/2-10;
  float ex = width*0 +er;
  float ey = height*0+er;
  
    
    float px = lerp(sx, ex, tween[0].position());
    float py = lerp(sy, ey, tween[scene_num].position());
    fill(255);
    ellipse(px, py, el, el);  
    

}

/*--------------------- シーン1関係 -------------------*/
void setScene1()//ふちを移動する
{
  tween[1] = new Tween(this, 0.5, Tween.SECONDS, Shaper.LINEAR);
  tween[1].pause();
  tween[scene_num+1] = new Tween(this, 0.5, Tween.SECONDS, Shaper.LINEAR);
  tween[scene_num+1].pause();
}

void scene1()
{
  float sx = width*0 +er;
  float sy = height*0+er;
  float ex = width*1 -er;
  float ey = height*0+er;
  
    
    float px = lerp(sx, ex, tween[1].position());
    float py = lerp(sy, ey, tween[scene_num+1].position());
    fill(255);
    ellipse(px, py, el, el);  
    
    ellipse(sx,sy,el,el);
    rect(sx, sy-er, px-er, el);
  
  
}

/*--------------------- シーン2関係 -------------------*/
void setScene2()
{
  tween[2] = new Tween(this, 0.25, Tween.SECONDS, Shaper.LINEAR);
  tween[2].pause();
  tween[scene_num+2] = new Tween(this, 0.25, Tween.SECONDS, Shaper.LINEAR);
  tween[scene_num+2].pause();
}

void scene2()
{
  float sx = width*1 -er;
  float sy = height*0+er;
  float ex = width*1 -er;
  float ey = height*1-er;
  
    
    float px = lerp(sx, ex, tween[2].position());
    float py = lerp(sy, ey, tween[scene_num+2].position());
    fill(255);
    ellipse(px, py, el, el);  
    
    ellipse(sx,sy,el,el);
    rect(sx-er, sy, el, py-er);
    
   
    ellipse(width*0 +er,height*0+er,el,el);
    rect(width*0 +er,height*0,width*1 -el,height*0+el);
  
}

/*--------------------- シーン3関係 -------------------*/
void setScene3()
{
  tween[3] = new Tween(this, 0.5, Tween.SECONDS, Shaper.LINEAR);
  tween[3].pause();
  tween[scene_num+3] = new Tween(this, 0.5, Tween.SECONDS, Shaper.LINEAR);
  tween[scene_num+3].pause();
}

void scene3()
{
  float sx = width*1 -er;
  float sy = height*1-er;
  float ex = width*0 +er;
  float ey = height*1-er;
  
    
    float px = lerp(sx, ex, tween[3].position());
    float py = lerp(sy, ey, tween[scene_num+3].position());
    fill(255);
    ellipse(px, py, el, el);  
    
    ellipse(sx,sy,el,el);
    rect(sx, sy-er, -width+(px+er), el);
    
    ellipse(width*0 +er,height*0+er,el ,el);
    rect(width*0 +er,height*0,width*1 -el,height*0+el);
    ellipse(width*1 -er,height*0+er,el ,el);
    rect(width*1 -el,height*0+er,width*0 +el,height*1-el);
}

void setScene4()
{
  tween[4] = new Tween(this, 0.25, Tween.SECONDS, Shaper.LINEAR);
  tween[4].pause();
  tween[scene_num+4] = new Tween(this, 0.25, Tween.SECONDS, Shaper.LINEAR);
  tween[scene_num+4].pause();
}
void scene4()
{
  float sx = width*0 +er;
  float sy = height*1-er;
  float ex = width*0 +er;
  float ey = height*0+er;
  
    
    float px = lerp(sx, ex, tween[4].position());
    float py = lerp(sy, ey, tween[scene_num+4].position());
    fill(255);
    ellipse(px, py, el, el);   
   
    ellipse(sx,sy,el,el);
    rect(sx-er, sy, el, -height+(py+er));
    
    ellipse(width*0 +er,height*0+er,el ,el);
    rect(width*0 +er,height*0,width*1 -el,height*0+el);
    ellipse(width*1 -er,height*0+er,el ,el);
    rect(width*1 -el,height*0+er,width*0 +el,height*1-el);
    ellipse(width*1 -er,height*1-er,el ,el);
    rect(width*0 +er,height*1-el,width*1 -el,height*0+el);
    
  
}

void setScene5()
{
  tween[5] = new Tween(this, 1, Tween.SECONDS, Shaper.BEZIER);
  tween[5].pause();
  tween[scene_num+5] = new Tween(this, 1, Tween.SECONDS, Shaper.COSINE);
  tween[scene_num+5].pause();
}

void scene5()//中の四角形が落ちる
{
  float sx = width*0;
  float sy = height*0;
  float ex = width*0 +er;
  float ey = height*2;
  
    
    float px = lerp(sx, ex, tween[5].position());
    float py = lerp(sy, ey, tween[scene_num+5].position());
    fill(255);//四角がずれたとのふちありの四角形
    ellipse(width*0 +er,height*0+er,el ,el);
    ellipse(width*1 -er,height*0+er,el ,el);
    ellipse(width*1 -er,height*1-er,el ,el);
    ellipse(width*0 +er,height*1-er,el ,el);
    rect(0, er, width, height-el);
    rect(er, 0, width-el, height);
 
    fill(0);//中の四角の部分
    rect(px+el, py+el, width-el*2, height-el*2);
}

void setScene6()//ズームアウトしながらチェス盤のような背景が見える
{
  tween[6] = new Tween(this, 3, Tween.SECONDS, Shaper.COSINE);
  tween[6].pause();
  tween[scene_num+6] = new Tween(this, 3, Tween.SECONDS, Shaper.COSINE);
  tween[scene_num+6].pause();
}

void scene6()
{
  float bw = lerp(width, el, tween[6].position());
  float bh = lerp(height, el, tween[6].position());
  
  float sx = width*0;
  float sy = height*0;
  float ex = width/2+bw*2;
  float ey = height/2+bh*(-2);
  
  
  float sx2 = width*0-bw*5;
  float sy2 = height*0-bh*(-2);
  float ex2 = width/2-bw*3;
  float ey2 = height/2-bh*(0);
  
    float px = lerp(sx, ex, tween[scene_num+6].position());
    float py = lerp(sy, ey, tween[scene_num+6].position());
    
    float px2 = lerp(sx2, ex2, tween[scene_num+6].position());
    float py2 = lerp(sy2, ey2, tween[scene_num+6].position());

    
    for(int i=-50; i<50; i++){//四角を作っていく
      for(int j=-50;j<50;j++){
    
     if( (i+j)%2==0 ){
     fill(0);
    }else{
     fill(255); 
    }
    rect(px+bw*i,py+bh*j,bw,bh);

      }
    }
    
    
    fill(255);//四角の幅が狭くなると共に中のふち有も小さくなっていく
    ellipse(px+er,py+er,el,el);
    ellipse(px-er+bw,py+er,el,el);
    ellipse(px+er,py-er+bh,el,el);
    ellipse(px-er+bw,py-er+bh,el,el);
    rect(px+er,py,bw-el,bh);
    rect(px,py+er,bw,bh-el);  
  
}


void setScene7()//一段ずれていき、黒と白の列ができる
{
  tween[7] = new Tween(this, 6, Tween.SECONDS, Shaper.BOUNCE);
  tween[7].pause();
  tween[scene_num+7] = new Tween(this, 5, Tween.SECONDS, Shaper.BOUNCE);
  tween[scene_num+7].pause();
}



void scene7()
{
  float bw = el;//四角形の幅
  float bh = el;//　　　　高さ
  
  float s = 0;
  float sy = bh*(s);
  float e = 7;
  float ey = bh*(e);
  
  float elix1 = width/2+bw*2;//白球のｘ座標
  float eliy1 = height/2+bh*(-2);//ｙ座標
  float elix2 = width/2-bw*3;//黒球の初めのｘ座標
  float eliy2 = height/2-bh*(-1)-(-sy+ey);//y座標
  
    float py = lerp(sy, ey, tween[7].position());//四角形が落ちていく

    
    for(int i=-20; i<30; i++){//四角形を作っていく
      for(int j=-30;j<30;j++){
    
     if( (i+j)%2==0 ){
     fill(0);
    }else{
     fill(255); 
    }
    
    if(i%2==0){//動く列と動かない列をつくる
    rect(elix1+bw*i,eliy1+bh*j,bw,bh);
    }else{
    rect(elix1+bw*i,eliy1+bh*j+py,bw,bh);
    }
                
    
      }
    }
    
    fill(255);
    ellipse(elix1+er,eliy1+er,el,el);
    fill(0);
    ellipse(elix2+er,eliy2+er+py,el,el);
    
    
    
  
}

void setScene8()//列が集まり白と黒に分かれる
{
  tween[8] = new Tween(this, 5, Tween.SECONDS, Shaper.LINEAR);
  tween[8].pause();
  tween[scene_num+8] = new Tween(this, 5, Tween.SECONDS, Shaper.COSINE);
  tween[scene_num+8].pause();
}

void scene8()
{
  float bw = el;//四角形の幅
  float bh = el;//　　　　高さ
  
  float elix1 = width/2+bw*2;//白球のｘ座標
  float eliy1 = height/2+bh*(-2);//ｙ座標
  float elix2 = width/2-bw*3;//黒球のｘ座標
  float eliy2 = height/2+bh*(0);//y座標
  
  float sh=1;//四角のラインの幅
  float eh=2;
  float sy=0;
  float ey=el*10;
  
  float sy2=0;
  float ey2=el/2;
  
  float ph = lerp(sh, eh, tween[8].position());//四角形の幅が小さくなる
  float py = lerp(sy, ey, tween[scene_num+8].position());//四角形が落ちていく
  float py2 = lerp(sy2, ey2, tween[scene_num+8].position());//誤差修正
  
      for(int j=-17;j<30;j++){//白い列を作成、黒い列は背景でそう見せる
    
     if( j%2!=0 ){
     fill(255); 
     rect(0,eliy1+bh*j/ph+py+py2,width,bh);  
    }
    
   
    
  }
  
  
  
    fill(255);
    ellipse(elix1+er,eliy1+er,el,el);
    
    fill(0);
    ellipse(elix2+er,eliy2+er+bh,el,el);
  
  
}

void setScene9()//陰陽対極図を作る
{
  tween[9] = new Tween(this, 3, Tween.SECONDS, Shaper.LINEAR);
  tween[9].pause();
  tween[scene_num+9] = new Tween(this, 3, Tween.SECONDS, Shaper.COSINE);
  tween[scene_num+9].pause();
}

void scene9()
{
  float bw = el;//四角形の幅
  float bh = el;//　　　　高さ
  
  float elix1 = bw*2+er;//白球のｘ座標
  float eliy1 = bh*(-2)+er;//ｙ座標
  float elix2 = -bw*2-er;//黒球のｘ座標
  float eliy2 = -bh*(-2)-er;//y座標
  
  float dis=235;
     
//陰陽太極図  

  translate(width/2,height/2);
  rotate( PI*tween[9].position());//右回り
    fill(255);
    rect(-width,0,width*2,height*2);
    fill(0);
    rect(-width,0,width*2,-height*2);
  rotate( -PI*tween[9].position());//回転を止める
    
    fill(255);
    arc(0,0,dis*4,dis*4,0,PI);
    fill(0);
    arc(0,0,dis*4,dis*4,PI,PI*2);
    fill(255);
    ellipse(dis,0,dis*2,dis*2*tween[9].position());  
    fill(0);
    ellipse(-dis,0,dis*2,dis*2*tween[9].position());
    
  
  rotate( (0.173*PI-PI)*tween[9].position());//左回り
  
    fill(255);
    ellipse(elix1,eliy1,el,el);
    
    fill(0);
    ellipse(elix2,eliy2,el,el);
  
  
}

void setScene10()
{
  tween[10] = new Tween(this, 5, Tween.SECONDS, Shaper.CIRCULAR);
  tween[10].pause();
  tween[scene_num+10] = new Tween(this, 5, Tween.SECONDS, Shaper.BEZIER);
  tween[scene_num+10].pause();
}

void scene10()//陰陽対極図を回す
{

  float dis=235;  
 
 //陰陽太極図 
    translate(width/2,height/2);
    
    rotate( -PI*167/16*tween[10].position() );
    fill(255);
    rect(-width,0,width*2,-height*2);
    fill(0);
    rect(-width,0,width*2,height*2); 
    
    fill(255);
    arc(0,0,dis*4,dis*4,0,PI);
    fill(0);
    arc(0,0,dis*4,dis*4,PI,PI*2);
    fill(0);
    ellipse(-dis,0,dis*2,dis*2);
    fill(255);
    ellipse(dis,0,dis*2,dis*2);
    fill(0);
    ellipse(dis,0,el,el);
    fill(255);
    ellipse(-dis,0,el,el); 
    
  
}

void setScene11()//陰陽対極図の一部が移動
{
  tween[11] = new Tween(this, 0.2, Tween.SECONDS, Shaper.LINEAR);
  tween[11].pause();
  tween[scene_num+11] = new Tween(this, 0.2, Tween.SECONDS, Shaper.BEZIER);
  tween[scene_num+11].pause();
}

void scene11()
{
  float dis=235; 
  
  float px = lerp(0, width, tween[11].position());
  
  translate(width/2,height/2);
  rotate(PI/16);

  fill(255);
  rect(-width,-height,width,height*4);
  fill(0);
  rect(0,0,width,height*2);  
  fill(0);
  arc(0,0,dis*4,dis*4,PI/2,PI+PI/2);
  fill(255);
  arc(px,0,dis*4,dis*4,PI+PI/2,PI*2+PI/2);//移動する部分
  fill(255);
  ellipse(0,-dis,dis*2,dis*2);
  fill(0);
  ellipse(px,dis,dis*2,dis*2);//移動する部分
  
  fill(255);
  rect(px,-dis*3,-px,dis*3);//移動する部分
  fill(0);
  rect(-1,0,px,dis*2);
  
  fill(255);
  ellipse(px,dis,el,el);//移動する部分
  fill(0);
  ellipse(0,-dis,el,el); 
  
  
   
  
}

void setScene12()//黒い球がゆっくりと落ちてくる
{
  tween[12] = new Tween(this, 5, Tween.SECONDS, Shaper.BEZIER);
  tween[12].pause();
  tween[scene_num+12] = new Tween(this, 5, Tween.SECONDS, Shaper.BEZIER);
  tween[scene_num+12].pause();
}

void scene12()
{
  float dis=235; 
  float ey=dis*cos(PI/16)-er+5;//+5は誤差修正
  
  float py = lerp(0, ey, tween[12].position());
  
  translate(width/2,height/2);
  rotate(PI/16);

  fill(255);
  rect(-width,-height,width*2,height);
  rect(-width,-height,width,height*4);
  fill(0);
  rect(-1,0,width,height*2);  
  fill(0);
  arc(0,0,dis*4,dis*4,PI/2,PI+PI/2);
  fill(255);
  ellipse(0,-dis,dis*2,dis*2);  
  fill(0);
  ellipse(0,-dis+py,el,el); 
 
 
}

void setScene13()//黒い球が坂を下っていく
{
  tween[13] = new Tween(this, 1, Tween.SECONDS, Shaper.COSINE);
  tween[13].pause();
  tween[scene_num+13] = new Tween(this, 1, Tween.SECONDS, Shaper.BEZIER);
  tween[scene_num+13].pause();
}

void scene13()
{
  float dis=235; 
  float ey=dis*cos(PI/16)-er+5;
  
  float px = lerp(0, width+er, tween[13].position());
  
  translate(width/2,height/2);
  rotate(PI/16);

  fill(255);
  rect(-width,-height,width*2,height);
  rect(-width,-height,width,height*4);
  fill(0);
  rect(-1,0,width,height*2);  
  fill(0);
  arc(0,0,dis*4,dis*4,PI/2,PI+PI/2);
  fill(255);
  ellipse(0,-dis,dis*2,dis*2);  
  fill(0);
  ellipse(px,-dis+ey,el,el); 
  
}

void setScene14()//弾が出ていった後の背景
{
  tween[14] = new Tween(this, 60, Tween.SECONDS, Shaper.BOUNCE);
  tween[14].pause();
  tween[scene_num+14] = new Tween(this, 60, Tween.SECONDS, Shaper.BEZIER);
  tween[scene_num+14].pause();
}

void scene14()
{
  float dis=235; 
  
  
  translate(width/2,height/2);
  rotate(PI/16);

  fill(255);
  rect(-width,-height,width*2,height);
  rect(-width,-height,width,height*4);
  fill(0);
  rect(-1,0,width,height*2);  
  fill(0);
  arc(0,0,dis*4,dis*4,PI/2,PI+PI/2);
  fill(255);
  ellipse(0,-dis,dis*2,dis*2);  
}


