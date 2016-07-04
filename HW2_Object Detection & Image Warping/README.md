# Homework2_Object Detection & Image Warping  
NCTU Computer Vision homework  
  
  
## Technical discussion  
本次作業為image detection和warping的實現，利用的軟體為matlab  
完成的項目有1. SIFT(套用David Lowe的code) 2. KNN 3. RANSAC 4. Homography matrix 5. Warping，以下將一一解說。  
  
  
## How to Run?  
本次作業套用了David Lowe的code，但該code會在程式結束時無形中將佔存的變數清空，所以我在執行時在match.m的程式末標記了一個暫停點，如下：  
![readmeimg0](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img0.png)  
在command line下指令: match(‘object_22.bmp’, ‘target.bmp’);  
分別輸入object和target，執行後會卡在標記得暫停點，之後點開hw2.m執行全部程式碼(我是把function內全部框起來[tic & toc間]按f9)，如下：  
![readmeimg1](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img1.png)  
  
  
## Flow : 
![readmeimg2](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img2.png)  
  
  
1. SIFT  
這部分使用David Lowe的matlab code (來源：<http://www.cs.ubc.ca/~lowe/keypoints/>)  
會針對兩張圖中來找出對應最相近的的keypoint與該descriptor來配對，並畫出SIFT的連線配對，如下：  
![readmeimg3](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img3.png)  
並且生成矩陣match分別對應左圖的點對應到右圖的哪個點(內容存放為index，需要到loc1與loc2做查表找到x,y軸位置)，由圖中可以看到SIFT仍會有對應不佳的點，會造成之後建model時可能造成”選錯點”的情形。  
2. KNN  
節錄程式碼：

  >random_seed = randi([1,count_index-1],1,4);%隨機找尋match中任意4點  
  random_seed = sort(random_seed);  
  NNpdist = [];  
  NN_index = [];  
  for j = 1:4  
    for i = 1 : count_index-1  
      NNdist = [loc2(match_index(2,random_seed(j)),2),loc2(match_index(2,random_seed(j)),1);loc2(match_index(2,i),2),loc2(match_index(2,i),1)];  
      NNpdist(i) = pdist(NNdist); %計算每一個點與其他對應的keypoint距離  
    end  
    [NNB NNI]= sort(NNpdist); %計算各點距離後依大小排序  
    NN_index(j,1:4) = NNI(1:4); %取最短距離的四點(包含第一點為自己對應的點)  
  end  

利用random_seed隨機找尋match中的任意四點，將四點各自與其他keypoint correspondences比較距離，挑出最小的4個做為KNN的4個最近點，之後model將以4*4*4*4種方法去chain model  
3. Homographic matric & RANSAC  
將前面KNN做出的model做成homographic matrix，依照講義找出 min( ||Ux|| ) ，找出U^T * U的eigenvalue 與其 eigenvector，挑出最小的eigenvalue，將它的eigenvector排列成3*3的矩陣當作model，之後要進行RANSAC。  
將每個點丟進上面計算的matrix去看看對應到的點是不是跟原本的在附近(我設定歐式距離50以內判斷為inliner)，如果為inliner，計算inliner數量(inliner_counter ++)，並記錄inliner對應到的位置在哪供我們後面檢查使用。  
每一次的model計算inliner後都會比較目前inliner最大值，如超越最大值則將記錄全數更新。  
P.S. 如果途中發現有某個model計算inliner超過總共keypoint的7成，則直接判定它為最佳model，否則將重複執行2000次(所以最高計算model次數為2000*4*4*4*4)  
4. Warping  
最後我們會得到一個最佳的model，我們把原本的object中不等於255的點都丟進該model中，並將結果貼到target上。  
## Discussion of results :  
以object_22.bmp對應到target.bmp為例  
SIFT後的結果 :  
![readmeimg4](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img4.png)  
經過程式執行後可以找到229個inliner (總數246中佔229/246=0.93，高於9成的inliner)  
，花費程式執行時間為26.421284 seconds  
將對應的到點拿出來畫線檢查:  
![readmeimg5](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img5.png)  
肉眼可看到錯誤的點都不會被選到，與我們預期的效果相同。  
做Warping將object貼到target中：  
![readmeimg6](https://raw.githubusercontent.com/PohanYang/Computer-Vision/master/HW2_Object%20Detection%20%26%20Image%20Warping/docs/rd_img6.png)  
還是稍有誤差，可能要再提高門檻求得更好的model。(實驗9成5的inliner結果與此結果差不多)  
  
  
Thanks for your watching, if you have any advice you can email for me <swingcowrock@gmail.com>
