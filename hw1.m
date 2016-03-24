function hw1

clear all;
%read image
pic1 = imread('CV\HW1\bunny\pic1.bmp');
pic2 = imread('CV\HW1\bunny\pic2.bmp');
pic3 = imread('CV\HW1\bunny\pic3.bmp');
pic4 = imread('CV\HW1\bunny\pic4.bmp');
pic5 = imread('CV\HW1\bunny\pic5.bmp');
pic6 = imread('CV\HW1\bunny\pic6.bmp');
%initial matiex
x=zeros(120,120,3);
answ=zeros(120,120);answt=zeros(120,120);
answ1=zeros(120,120);
answ1t=zeros(120,120);
answ2=zeros(120,120);
answ3=zeros(120,120);
answ2t=zeros(120,120);
for i=1:120
    for j=1:120
        %{
        ¥ú·½source:
        pic1: (238,235,2360)
        pic2: (298,65,2480)
        pic3: (-202,225,2240)
        pic4: (-252,115,2310)
        pic5: (18,45,2270)
        pic6: (-22,295,2230)
        %}
        %print 6 light sourcr in txt make 6*3 metrix
        S=[238/sqrt(238*238+235*235+2360*2360),235/sqrt(238*238+235*235+2360*2360),2360/sqrt(238*238+235*235+2360*2360);
           298/sqrt(298*298+65*65+2480*2480),65/sqrt(298*298+65*65+2480*2480),2480/sqrt(298*298+65*65+2480*2480);
           -202/sqrt(202*202+225*225+2240*2240),225/sqrt(202*202+225*225+2240*2240),2240/sqrt(202*202+225*225+2240*2240);
           -252/sqrt(252*252+115*115+2310*2310),115/sqrt(252*252+115*115+2310*2310),2310/sqrt(252*252+115*115+2310*2310);
           18/sqrt(18*18+45*45+2270*2270),45/sqrt(18*18+45*45+2270*2270),2270/sqrt(18*18+45*45+2270*2270);
           -22/sqrt(22*22+295*295+2230*2230),295/sqrt(22*22+295*295+2230*2230),2230/sqrt(22*22+295*295+2230*2230)];
       %
       y=zeros(6,1); y(1,1)=pic1(i,j); y(2,1)=pic2(i,j); y(3,1)=pic3(i,j); y(4,1)=pic4(i,j); y(5,1)=pic5(i,j); y(6,1)=pic6(i,j);
       %compute inv(transport(S)*S)*tanswport(S)*y
       S2=S.' * S;
       S3=inv(S2);
       S4=S3*S.';
       x_temp=[S4*y];
       %save result in a 120*120*3 metrix  x, 1 layer is normal vector's
       %x, 2 layer is y, 3 layer is z
       if (x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3))~=0
        x(i,j,1)=x_temp(1)/sqrt(x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3));
        x(i,j,2)=x_temp(2)/sqrt(x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3));
        x(i,j,3)=x_temp(3)/sqrt(x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3));
       end
    end
end

%from 0.0 integral
for i=1:120
    for j=1:120
        temp = 0;
        for k=1:j
            if x(1,k,3)~=0
                %from 1 to y integral, plus every normal vector's -a/c 
                temp = temp + -(x(1,k,1))/x(1,k,3);
            end
        end
        for m=1:i
            if x(m,j,3)~=0
                %and then integral x, plus every normal vector's -b/c
                temp = temp + -(x(m,j,2))/x(m,j,3);
            end
        end
        answ1(i,j) = temp;
    end
end
%from 0.0 integral finish

%from 120.120 integral
for i=1:120
    for j=1:120
        temp = 0;
        for m=120:-1:i
            if x(m,120,3)~=0
                %from 120 to x integral, plus every normal vector's -b/c 
                temp = temp + -(x(m,120,2))/x(m,120,3);
            end
        end
        for k=120:-1:j
            if x(i,k,3)~=0
                %and then integral y, plus every normal vector's -a/c
                temp = temp + -(x(i,k,1))/x(i,k,3);
            end
        end
        answ2(i,j) = temp;
    end
end
%from 120.120 integral finish

%print ply file
fid = fopen('bunnyans.ply', 'w');
fprintf(fid, 'ply\r\n');
fprintf(fid, 'format ascii 1.0\r\n');
fprintf(fid, 'comment alpha=3.0\r\n');
fprintf(fid, 'element vertex 14400\r\n');
fprintf(fid, 'property float x\r\n');
fprintf(fid, 'property float y\r\n');
fprintf(fid, 'property float z\r\n');
fprintf(fid, 'property uchar red\r\n');
fprintf(fid, 'property uchar green\r\n');
fprintf(fid, 'property uchar blue z\r\n');
fprintf(fid, 'end_header\r\n');
%average answ1 and answ2 neighbor to smooth 3D surface
for i=2:119
    for j=2:119
        answ1t(i,j)=(answ1(i-1,j-1)+answ1(i,j-1)+answ1(i+1,j-1)+answ1(i-1,j)+answ1(i,j)+answ1(i+1,j)+answ1(i-1,j+1)+answ1(i,j+1)+answ1(i+1,j+1))/9;
    end
end
for i=2:119
    for j=2:119
        answ2t(i,j)=(answ2(i-1,j-1)+answ2(i,j-1)+answ2(i+1,j-1)+answ2(i-1,j)+answ2(i,j)+answ2(i+1,j)+answ2(i-1,j+1)+answ2(i,j+1)+answ2(i+1,j+1))/9;
    end
end
%print every point to ply file
for i=1:120
    for j=1:120
        if answ1t(i,j)~=0 && answ2t(i,j)~=0
            answ(i,j)=(answ1t(i,j)+answ2t(i,j))/2;
        end
    end
end

for i=2:119
    for j=2:119
        answ(i,j)=(answ(i-1,j-1)+answ(i,j-1)+answ(i+1,j-1)+answ(i-1,j)+answ(i,j)+answ(i+1,j)+answ(i-1,j+1)+answ(i,j+1)+answ(i+1,j+1))/9;
    end
end

for i=1:120
    for j=1:120
        fprintf(fid, '%d %d %1.5f',i, j, -answ(i,j));
        fprintf(fid, ' 255 255 255\r\n');
    end
end

%print normal map
fid = fopen('bunnymap.txt', 'w');
for i=1:120
    for j=1:120
        fprintf(fid, '%d ', -answ(i,j));
    end
        fprintf(fid, '\r\n');
end
