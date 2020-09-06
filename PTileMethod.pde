        //opencvをインポートし、各変数を宣言
        import gab.opencv.*;
        OpenCV cv;
        Histogram grayHist;
        import org.opencv.core.Mat;
        PImage im;
        
        int sample_number=9;
        im = loadImage("sample"+str(sample_number)+".png");
        
        float bright[][]= new float [im.width][im.height]; 
        
        void chain(int x,int y, int val){
          for(int i=-1;i<=1;i++){
           for(int j=-1;j<=1;j++){
            if(bright[x+i][y+j]==255)bright[x+i][y+j]=val;
           } 
          }
        }
        
        void setup() {
        // 画像の読み込み
        // 画面サイズ　画像のサイズに合わせて変更
        /*演習問題６－１*/
        size(im.width*600/im.height,600);
        cv = new OpenCV(this, im);
        // グレースケールのヒストグラムを計算
        grayHist = cv.findHistogram(cv.getGray(), 256);
        // 画面を真っ黒にする
        background(0);
        /*演習問題６－２*/
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
            print(remain[l+1]/total+"\n");
            //初めて超える輝度値
            print(remain[l]/total+"\n");
            //二値化の閾値
            print(threshold);
          }
          l--;
        }
        
        /*
        // 二値化画像を貼る 
        image(im,  0, 0, width,height);
        filter(THRESHOLD,(float)threshold/lina.length);
        //出力画像の保存
        //saveFrame("sample"+str(sample_number+2)+"_"+str((int)threshold)+"_"+str(per[sample_number]*100)+"%.png");
        }*/
        
            
            
            image(im,  width/2, 0, width/2,height/2);// 入力画像を画面右上に貼る 
          
            im.filter(THRESHOLD, (float)threshold/lina.length);
            image(im,  width/2,height/2, width/2,height/2);// 二値化画像を画面右下に貼る 
            //filter(THRESHOLD,(float)threshold/lina.length);
            
            float bright[][]= new float [im.width][im.height]; 
            //int bright[][]= new int [im.width][im.height];     
            for(int y=0; y<im.height; y++){ 
              for(int x=0; x<im.width; x++){
               if(brightness(im.get(x,y))!=0) 
                bright[x][y]=x+y*im.height;
                stroke(bright[x][y]);
                rect(x,y,0,0);
              }
            }
            
            int val=0;
            
            for(int y=0; y<im.height; y++){ 
              for(int x=0; x<im.width; x++){
               if(bright[x][y]==255){
                 chain(x,y,val)=val;
               } 
              }
            }
            
            /*
            for(int y=0; y<im.height; y++){ 
              for(int x=0; x<im.width; x++){ 
                for(int j=-1;j<=0;j++){
                  for(int i=-1;i<=0;i++){
                  if(x!=0 && x!=im.width-1 && y!=0 && y!=im.height-1)
                  if(abs(bright[x+i][y+j])>0 && abs(bright[x][y])>0)
                  bright[x][y]=-abs(bright[x][y]);
                  bright[x][y]=bright[x+i][y+j];
                  } 
                }
                stroke(bright[x][y]/500);
                rect(x,y+height/2,0,0);
              }
              }*/
              
              /*
              
              for(int y=0; y<im.height; y++){ 
              for(int x=0; x<im.width; x++){ 
                for(int n=0;n<num_chain.length;n++){
                if(bright[x][y]!=num_chain[n]){
                if(n==num_chain.length-1)
                num_chain = (float[])append(num_chain,bright[x][y]);
                }else{
                n=num_chain.length;
                }
                }
              }
              }
              println("");
              println((int)num_chain.length);
              */
            
            
            
            
            
            /*
            
            stroke(255); noFill();
            rect(10, 10, width/2-20, height/2-20); // ヒストグラム欄の外枠を描く
            fill(200); 
            noStroke();
            grayHist.draw(10, 10, width/2-20, height/2-20); // ヒストグラムの棒を描く
            
            stroke(255); noFill();
            rect(10, 10+height/2, width/2-20, height/2-20); // pタイル欄の外枠を描く
            float line_width=(width/2-20);
            float line_height=(height/2-20);
            
            fill(255);
            
            //ヒストグラムの頻度を輝度値の高い方から足していったグラフ
            //しきい値も記載
            for(int r=0;r<remain.length-1;r++){
              //ヒストグラムの頻度を輝度値の高い方から足していったグラフ
             line(10+r*line_width/remain.length,    height-10-remain[r]*line_height/remain[0],
                  10+(r+1)*line_width/remain.length,height-10-remain[r+1]*line_height/remain[0]);
             if(r==threshold){//しきい値関連
             stroke(255,0,0);
             //しきい値
             line(10+r*line_width/remain.length,height-10-remain[r]*line_height/remain[0],
                  10+r*line_width/remain.length,height-10);
             //二値化する輝度の割合
             line(10+r*line_width/remain.length,height-10-remain[r]*line_height/remain[0],
                  10,height-10-remain[r]*line_height/remain[0]);
             text(per[sample_number]*100+"%",10,height-10-remain[r]*line_height/remain[0]);//二値化する輝度の割合
             text((int)threshold,10+r*line_width/remain.length,height-10);//しきい値
             stroke(255);
             }
             if(r%100==0){//100ごとに位置の値を書いていく
             text(r,10+r*line_width/remain.length,height/2);
             text(r,10+r*line_width/remain.length,height);
             }
            }
             text(remain.length-1,remain.length*line_width/remain.length,height/2);//最大幅の値
             text(remain.length-1,remain.length*line_width/remain.length,height);//最大幅の値
             
             saveFrame("sample"+str(sample_number+2)+"_"+str((int)threshold)+"_"+str(per[sample_number]*100)+"%.png");
             */
             
             
            }
            
