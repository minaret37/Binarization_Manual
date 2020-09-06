//opencvをインポートし、各変数を宣言
import gab.opencv.*;
OpenCV cv;
Histogram grayHist;
import org.opencv.core.Mat;
PImage im;

/*演習問題12-2*/
//与えられる画像よりも大きいplaceを用意
//入る値は、最初に０以外の各画素の位置の値　このとき０以外はすべて違う値
//次に対象の点と連結している値が同じになるようにする　
float place[][]= new float [2000][2000];
//連結成分の個数を数え上げる
int chain_num() {
  //連結成分の個数　０は含まれない
  int cn=0;
  //各連結成分のplaceの値　０も含まれる
  float []value= {
    0
  };
  //画素の数だけplaceを調べる
  for (int y=1; y<im.height; y++) { 
    for (int x=1; x<im.width; x++) {
      for (int z=0; z<value.length; z++) {
        //既出の連結成分のplaceの値でなかったとき
        if (value[z]!=place[x][y]) {
          //既出のすべての連結成分のplaceの値でなかったとき
          if (z==value.length-1) {
            //既出の連結成分として扱う
            value=(float[])append(value, place[x][y]);
            //連結成分の個数を加算
            cn++;
          }
        } else {
          //既出の連結成分のplaceの値であった場合、次のplaceに移る
          break;
        }
      }
    }
  }
  //連結成分の値を返す
  return cn;
}

//対象の点(value)と連結しているplaceを見つけ、隣り合う点(value2)と連結しているplaceを連結
void search(float value, float value2) {
  for (int y=1; y<im.height; y++) { 
    for (int x=1; x<im.width; x++) {
      //対象の点(value)と連結しているplaceを見つけ、隣り合う点(value2)と連結しているplaceの値にする
      if (place[x][y]==value)place[x][y]=value2;
    }
  }
}


//8連結した回数
int val=0;
//placeを連結する
void chain() {
  //連結した回数を記録する
  int val2=val;
  for (int y=1; y<im.height; y++) { 
    for (int x=1; x<im.width; x++) {
      //対象の
      for (int i=-1; i<=1; i++) {
        for (int j=-1; j<=1; j++) {
          //対象の点と8連結で隣り合う点が０以外で、お互い違う値の時
          if (place[x][y]!=0 
            && place[x+i][y+j]!=0 
            && place[x+i][y+j]!=place[x][y]){
            //対象の点と連結しているplaceと、8連結で隣り合う点に連結しているplaceを連結
            search(place[x][y], place[x+i][y+j]);
            //連結した回数を加算する
            val++;
            println("val="+str(val));
            println(str(x)+":"+str(y));
          }
        }
      }
    }
  }
  //連結した場合、もう一度行い、連結しなくなるまで繰り返す
  if (val2==val)chain();
}
void setup() {
  /*演習問題6-1*/
  // 画像の読み込み
  String name="sample2";
  im = loadImage(name+".png");
  // 画面サイズ　画像のサイズに合わせて変更
  size(im.width*600/im.height, 600);
  cv = new OpenCV(this, im);
  // グレースケールのヒストグラムを計算
  grayHist = cv.findHistogram(cv.getGray(), 256);
  // 画面を真っ黒にする
  background(0);
  /*演習問題9-4*/
  //Mat形式に変換
  Mat mat=  grayHist.getMat();
  float total=0;//輝度の合計
  //0~255の配列
  float lina[]=new float [mat.rows()*mat.cols()];
  for (int r=0; r<mat.rows (); r++) {
    //一度double型に入れる
    double d[]=mat.get(r, 0);
    //0~255の配列に対応した輝度の頻度の値を代入していく
    lina[r]=(float)d[0];
    //輝度の合計の計算
    total+=(float)d[0];
  }
  //二値化する輝度の割合 1.0のとき100%
  float per = 0.12;
  //二値化の閾値
  float threshold=-1;
  //ヒストグラムの頻度を輝度値の高い方から足していく
  float remain[] = new float [lina.length];
  int l=lina.length-1;
  remain[l]=lina[l];
  while (l>0) {
    remain[l-1]=remain[l]+lina[l];
    //頻度を輝度値の高い方から足していき、
    //二値化する割合を初めて超える輝度値を閾値とする
    if (remain[l]/total>per && threshold==-1) {
      threshold=l;
      //初めて超える輝度値の一歩手前
      print(remain[l+1]/total+"\n");
      //初めて超える輝度値
      print(remain[l]/total+"\n");
      //二値化の閾値
      print(threshold);
    }
    l--;
  }
  // 二値化画像を貼る 
  image(im, width/2, 0, width/2, height/2);// 入力画像を画面右上に貼る 

  im.filter(THRESHOLD, (float)threshold/lina.length);
  image(im, 0, 0, width, height);// 二値化画像を画面右下に貼る 

  /*演習問題12-2*/
  
  //輝度が０以外はplaceに個々の場所の値を入れる
  for (int y=0; y<im.height; y++) { 
    for (int x=0; x<im.width; x++) {
      if (brightness(im.get(x, y))!=0)//輝度値０以外 
        place[x][y]=x+y*im.height;//場所の値を入れる　このとき全ては違い値になっている
    }
  }

  chain();//placeの値を変えて8連結する
  println(chain_num());//placeの値が何種類あるか判別する　＝　連結数

  //出力画像の保存
  saveFrame("chain sample2"
    +" threshold="+str((int)threshold)
    +" P="+str(per*100)
    +"% chain num="+str(chain_num())+".png");
}

/*

 //opencvをインポートし、各変数を宣言
 import gab.opencv.*;
 OpenCV cv;
 Histogram grayHist;
 import org.opencv.core.Mat;
 PImage im;
 
 //与えられる画像よりも大きいplaceを用意
 //入る値は、最初に０以外の各画素の位置の値　このとき０以外はすべて違う値
 //次に対象の点と連結している値が同じになるようにする　
 float place[][]= new float [2000][2000];
 //連結成分の個数を数え上げる
 int chain_num(){
 //連結成分の個数　０は含まれない
 int cn=0;
 //各連結成分のplaceの値　０も含まれる
 float []value={0};
 //画素の数だけplaceを調べる
 for(int y=1; y<im.height; y++){ 
 for(int x=1; x<im.width; x++){
 for(int z=0;z<value.length;z++){
 //既出の連結成分のplaceの値でなかったとき
 if(value[z]!=place[x][y]){
 //既出のすべての連結成分のplaceの値でなかったとき
 if(z==value.length-1){
 //既出の連結成分として扱う
 value=(float[])append(value,place[x][y]);;
 //連結成分の個数を加算
 cn++;
 }
 }else{
 //既出の連結成分のplaceの値であった場合、次のplaceに移る
 break;
 }
 }
 }
 }
 //連結成分の値を返す
 return cn;
 }
 
 //対象の点(value)と連結しているplaceを見つけ、隣り合う点(value2)と連結しているplaceを連結
 void search(float value,float value2){
 for(int y=1; y<im.height; y++){ 
 for(int x=1; x<im.width; x++){
 //対象の点(value)と連結しているplaceを見つけ、隣り合う点(value2)と連結しているplaceの値にする
 if(place[x][y]==value)place[x][y]=value2;
 }
 }
 }
 
 
 //連結した回数
 int val=0;
 //placeを連結する
 void chain(){
 //連結した回数を記録する
 int val2=val;
 for(int y=1; y<im.height; y++){ 
 for(int x=1; x<im.width; x++){
 //対象の
 for(int i=-1;i<=1;i++){
 for(int j=-1;j<=1;j++){
 //対象の点と隣り合う点が０以外で、お互い違う値の時
 if(place[x][y]!=0 
 && place[x+i][y+j]!=0 
 && place[x+i][y+j]!=place[x][y]
 && i+j!=0){
 //対象の点と連結しているplaceと、隣り合う点に連結しているplaceを連結
 search(place[x][y],place[x+i][y+j]);
 //連結した回数を加算する
 val++;
 println("val="+str(val));
 println(str(x)+":"+str(y));
 }
 }
 } 
 }
 }
 //連結した場合、もう一度行い、連結しなくなるまで繰り返す
 if(val2==val)chain();
 }
 
 void setup() {
 
 // 画像の読み込み
 int sample_number=4;
 im = loadImage("sample"+str(sample_number)+".png");
 
 size(im.width*600/im.height,600);
 cv = new OpenCV(this, im);
 // グレースケールのヒストグラムを計算
 grayHist = cv.findHistogram(cv.getGray(), 256);
 // 画面を真っ黒にする
 background(0);
 //Mat形式に変換
 Mat mat=  grayHist.getMat();
 float total=0;//輝度の合計
 //0~255の配列
 float lina[]=new float [mat.rows()*mat.cols()];
 for(int r=0;r<mat.rows();r++){
 //一度double型に入れる
 double d[]=mat.get(r,0);
 //0~255の配列に対応した輝度の頻度の値を代入していく
 lina[r]=(float)d[0];
 //輝度の合計の計算
 total+=(float)d[0];
 }
 //二値化する輝度の割合 1.0のとき100%
 float per[] ={0.5, 0.12, 0.20, 0.12, 0.18, 0.6, 0.7, 0.8, 0.23 };
 sample_number-=1;
 //二値化の閾値
 float threshold=-1;
 //ヒストグラムの頻度を輝度値の高い方から足していく
 float remain[] = new float [lina.length];
 int l=lina.length-1;
 remain[l]=lina[l];
 while(l>0){
 remain[l-1]=remain[l]+lina[l];
 //頻度を輝度値の高い方から足していき、
 //二値化する割合を初めて超える輝度値を閾値とする
 if(remain[l]/total>per[sample_number] && threshold==-1){
 threshold=l;
 //初めて超える輝度値の一歩手前
 println(remain[l+1]/total);
 //初めて超える輝度値
 println(remain[l]/total);
 //二値化の閾値
 println(threshold);
 }
 l--;
 }
 
 image(im,  width/2, 0, width/2,height/2);// 入力画像を画面右上に貼る 
 
 im.filter(THRESHOLD, (float)threshold/lina.length);
 image(im,  0, 0, width,height);// 二値化画像を画面右下に貼る 
 
 //輝度が０以外はplaceに個々の場所の値を入れる
 for(int y=0; y<im.height; y++){ 
 for(int x=0; x<im.width; x++){
 if(brightness(im.get(x,y))!=0)//輝度値０以外 
 place[x][y]=x+y*im.height;//場所の値を入れる　このとき全ては違い値になっている
 }
 }
 
 chain();//placeを変えて連結する
 println(chain_num());//placeの値が何種類あるか判別する　＝　連結数
 
 
 //出力画像の保存
 saveFrame("chain sample"+str(sample_number)
 +" threshold="+str((int)threshold)
 +" P="+str(per[sample_number]*100)
 +"% chain num="+str(chain_num())+".png");
 
 
 }
 
 */

