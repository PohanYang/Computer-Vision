function hw1_kanahei

clear all;
%read image
pic1 = imread('CV\HW1\kanahei\img1.bmp');
pic2 = imread('CV\HW1\kanahei\img2.bmp');
pic3 = imread('CV\HW1\kanahei\img3.bmp');
pic4 = imread('CV\HW1\kanahei\img4.bmp');
pic5 = imread('CV\HW1\kanahei\img5.bmp');
pic6 = imread('CV\HW1\kanahei\img6.bmp');
pic7 = imread('CV\HW1\kanahei\img7.bmp');
%initial matiex
x=zeros(114,114,3);
answ=zeros(114,114);answt=zeros(114,114);
answ1=zeros(114,114);
answ1t=zeros(114,114);
answ2=zeros(114,114);
answ3=zeros(114,114);
answ2t=zeros(114,114);
for i=1:114
    for j=1:114
        %{
        ¥ú·½source:
        pic1: (23,88,295)
        pic2: (-19,91,261)
        pic3: (-1,88,181)
        pic4: (-59,90,216)
        pic5: (96,114,102)
        pic6: (-18,88,251)
        pic7: (-62,114,174)
        %}
        %print 7 light sourcr in txt make 7*3 metrix
        S=[23/sqrt(23*23+88*88+295*295),88/sqrt(23*23+88*88+295*295),295/sqrt(23*23+88*88+295*295);
           -19/sqrt(-19*-19+91*91+261*261),91/sqrt(-19*-19+91*91+261*261),261/sqrt(-19*-19+91*91+261*261);
           -1/sqrt(1*1+88*88+181*181),88/sqrt(1*1+88*88+181*181),181/sqrt(1*1+88*88+181*181);
           -59/sqrt(-59*-59+90*90+216*216),90/sqrt(-59*-59+90*90+216*216),216/sqrt(-59*-59+90*90+216*216);
           96/sqrt(96*96+114*114+102*102),114/sqrt(96*96+114*114+102*102),102/sqrt(96*96+114*114+102*102);
           -18/sqrt(18*18+88*88+251*251),88/sqrt(18*18+88*88+251*251),251/sqrt(18*18+88*88+251*251);
           -62/sqrt(62*62+114*114+174*174),114/sqrt(62*62+114*114+174*174),174/sqrt(62*62+114*114+174*174)];
       %
       y=zeros(7,1); y(1,1)=pic1(i,j); y(2,1)=pic2(i,j); y(3,1)=pic3(i,j); y(4,1)=pic4(i,j); y(5,1)=pic5(i,j); y(6,1)=pic6(i,j); y(7,1)=pic7(i,j);
       %compute inv(transport(S)*S)*tanswport(S)*y
       S2=S.' * S;
       S3=inv(S2);
       S4=S3*S.';
       x_temp=[S4*y];
       %save result in a 114*114*3 metrix  x, 1 layer is normal vector's
       %x, 2 layer is y, 3 layer is z
       if (x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3))~=0
        x(i,j,1)=x_temp(1)/sqrt(x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3));
        x(i,j,2)=x_temp(2)/sqrt(x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3));
        x(i,j,3)=x_temp(3)/sqrt(x_temp(1)*x_temp(1)+x_temp(2)*x_temp(2)+x_temp(3)*x_temp(3));
       end
    end
end

%from 0.0 integral
for i=1:114
    for j=1:114
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

%from 114.114 integral
for i=1:114
    for j=1:114
        temp = 0;
        for m=114:-1:i
            if x(m,114,3)~=0
                %from 114 to x integral, plus every normal vector's -b/c 
                temp = temp + -(x(m,114,2))/x(m,114,3);
            end
        end
        for k=114:-1:j
            if x(i,k,3)~=0
                %and then integral y, plus every normal vector's -a/c
                temp = temp + -(x(i,k,1))/x(i,k,3);
            end
        end
        answ2(i,j) = temp;
    end
end
%from 114.114 integral finish

%print ply file
fid = fopen('kanaheians.ply', 'w');
fprintf(fid, 'ply\r\n');
fprintf(fid, 'format ascii 1.0\r\n');
fprintf(fid, 'comment alpha=3.0\r\n');
fprintf(fid, 'element vertex 12769\r\n');
fprintf(fid, 'property float x\r\n');
fprintf(fid, 'property float y\r\n');
fprintf(fid, 'property float z\r\n');
fprintf(fid, 'property uchar red\r\n');
fprintf(fid, 'property uchar green\r\n');
fprintf(fid, 'property uchar blue z\r\n');
fprintf(fid, 'end_header\r\n');
%average answ1 and answ2 neighbor to smooth 3D surface
for i=2:113
    for j=2:113
        answ1t(i,j)=(answ1(i-1,j-1)+answ1(i,j-1)+answ1(i+1,j-1)+answ1(i-1,j)+answ1(i,j)+answ1(i+1,j)+answ1(i-1,j+1)+answ1(i,j+1)+answ1(i+1,j+1))/9;
    end
end
for i=2:113
    for j=2:113
        answ2t(i,j)=(answ2(i-1,j-1)+answ2(i,j-1)+answ2(i+1,j-1)+answ2(i-1,j)+answ2(i,j)+answ2(i+1,j)+answ2(i-1,j+1)+answ2(i,j+1)+answ2(i+1,j+1))/9;
    end
end
%print every point to ply file
for i=1:114
    for j=1:114
        if answ1t(i,j)~=0 && answ2t(i,j)~=0
            answ(i,j)=(answ1t(i,j)+answ2t(i,j))/2;
        end
    end
end

for i=2:113
    for j=2:113
        answ(i,j)=(answ(i-1,j-1)+answ(i,j-1)+answ(i+1,j-1)+answ(i-1,j)+answ(i,j)+answ(i+1,j)+answ(i-1,j+1)+answ(i,j+1)+answ(i+1,j+1))/9;
    end
end

for i=1:114
    for j=1:114
        fprintf(fid, '%d %d %1.5f',i, j, -answ(i,j));
        fprintf(fid, ' 255 255 255\r\n');
    end
end
%{
%print normal map
fid = fopen('bunnymap.txt', 'w');
for i=1:114
    for j=1:114
        fprintf(fid, '%d ', -answ(i,j));
    end
        fprintf(fid, '\r\n');
end
%}

