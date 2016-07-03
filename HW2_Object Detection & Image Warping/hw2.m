function hw2
tic
count_index = 1;
[gar match_size] = size(match);
ormatch = match;
for i=1:match_size
    if(match(i)>0)
        match_index(2,count_index) = match(1,i);
        match_index(1,count_index) = i;
        count_index = count_index + 1;
    end
end

max_inliner = 0;
loopcounter = 0;
NN = 4;
while(max_inliner<count_index*0.95 & loopcounter<2000)
    random_seed = randi([1,count_index-1],1,4);%randi([1,count_index-1],1,4);
    random_seed = sort(random_seed);
    
    
NNpdist = [];
NN_index = [];
for j = 1:4
    for i = 1 : count_index-1
        NNdist = [loc2(match_index(2,random_seed(j)),2),loc2(match_index(2,random_seed(j)),1);loc2(match_index(2,i),2),loc2(match_index(2,i),1)];
        %計算每一個點與其他對應的keypoint距離
        NNpdist(i) = pdist(NNdist);
    end
    [NNB NNI]= sort(NNpdist);%計算各點距離後依大小排序
    NN_index(j,1:4) = NNI(1:4);%取最短距離的四點(包含第一點為自己對應的點)
end    
for i = 1:NN
    for j = 1:NN
        for k = 1:NN
            for l = 1:NN
    x1 = loc1(match_index(1,NN_index(1,i)),2); y1 = loc1(match_index(1,NN_index(1,i)),1);
    X1 = loc2(match_index(2,NN_index(1,i)),2); Y1 = loc2(match_index(2,NN_index(1,i)),1);
    x2 = loc1(match_index(1,NN_index(2,j)),2); y2 = loc1(match_index(1,NN_index(2,j)),1);
    X2 = loc2(match_index(2,NN_index(2,j)),2); Y2 = loc2(match_index(2,NN_index(2,j)),1);
    x3 = loc1(match_index(1,NN_index(3,k)),2); y3 = loc1(match_index(1,NN_index(3,k)),1);
    X3 = loc2(match_index(2,NN_index(3,k)),2); Y3 = loc2(match_index(2,NN_index(3,k)),1);
    x4 = loc1(match_index(1,NN_index(4,l)),2); y4 = loc1(match_index(1,NN_index(4,l)),1);
    X4 = loc2(match_index(2,NN_index(4,l)),2); Y4 = loc2(match_index(2,NN_index(4,l)),1);
     A = [X1 Y1 1 0 0 0 -x1*X1 -x1*Y1 -x1; ...
          0 0 0 X1 Y1 1 -y1*X1 -y1*Y1 -y1; ...
          X2 Y2 1 0 0 0 -x2*X2 -x2*Y2 -x2; ...
          0 0 0 X2 Y2 1 -y2*X2 -y2*Y2 -y2; ...
          X3 Y3 1 0 0 0 -x3*X3 -x3*Y3 -x3; ...
          0 0 0 X3 Y3 1 -y3*X3 -y3*Y3 -y3; ...
          X4 Y4 1 0 0 0 -x4*X4 -x4*Y4 -x4; ...
          0 0 0 X4 Y4 1 -y4*X4 -y4*Y4 -y4];
    e = eig(A.'*A);
    [V D] = eig(A.'*A);%找出9個eigenvector
    minD = find(e==min(e(1:9)));%將最小的eigenvalue之eigenvector取出
    temp_U = [V(1,minD) V(2,minD) V(3,minD);V(4,minD) V(5,minD) V(6,minD); V(7,minD) V(8,minD) V(9,minD)];%排列為3*3的矩陣
    
    inliner = 0;%計算該model有多少inliner
    clear temp_inliner_index temp_matchkpo;
    temp_inliner_index = [];
    temp_matchkpo = [];
    for m = 1:count_index-1
        temp_orgkp = [loc1(match_index(1,m),2);loc1(match_index(1,m),1);1];
        checkkp = temp_U*double(temp_orgkp);
        checkm = [checkkp(1)/checkkp(3),checkkp(2)/checkkp(3);loc2(match_index(2,m),2),loc2(match_index(2,m),1)];
        if(pdist(checkm)<50)%歐式距離在50內我定義為inliner
            pdist(checkm);
            temp_inliner_index(match_index(1,m)) = match_index(2,m);
            temp_matchkpo(match_index(1,m),1) = checkm(1,1);
            temp_matchkpo(match_index(1,m),2) = checkm(1,2);
            temp_matchkpo(match_index(1,m),3) = checkm(2,1);
            temp_matchkpo(match_index(1,m),4) = checkm(2,2);%以上紀錄inliner是由那裡對應到哪裡，供後面檢查使用
            inliner = inliner + 1;%計算inliner數量++
         end
     end
     if(inliner>max_inliner)%如果當下modelinliner超過目前max_inliner，將原本的紀錄與max_inliner都更新
        clear inliner_index matchkpo recordkp U;
        inliner_index = temp_inliner_index;
        matchkpo = temp_matchkpo;
        recordkp = random_seed;
        U = temp_U;
        max_inliner = inliner;
     end
            end%l
        end%k
    end%j
end%i
    loopcounter = loopcounter+1;
end%while


%show keypoint inliner line
im3 = appendimages(im1,im2);%接object和target欲做對應點的檢查

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
[gar ,linesize] = size(inliner_index);
for i = 1: linesize
  if (inliner_index(i) > 0)
    line([loc1(i,2) matchkpo(i,1)+cols1], ...
         [loc1(i,1) matchkpo(i,2)], 'Color', 'c');%將inliner的對應連線顯示在圖上
  end
end
hold off;


%warping
[im1_h, im1_w] = size(im1);
[im2_h, im2_w] = size(im2);
result = im2;
for i=1:im1_h
    for j=1:im1_w
        if(im1(i,j)~=255)
            orgkp = [j;i;1];
            paste = U*double(orgkp);%U為最佳model，將非255的點丟進去運算得到結果
            targetx = paste(1)/paste(3); targety = paste(2)/paste(3);
            if(targetx>1 & targety >1 & targetx<im2_w & targety<im2_h)
                result(round(targety),round(targetx))=im1(i,j);%四捨五入將點貼到target中，故有些中間看得出一點點漏洞線條
            end
        end
    end
end
figure,imshow(result);title('Ans');
toc
end%function end