function dis = dist(point1, point2)
%% compute dis

for i=1:match_size
    if(match(i)~=0)
        im2_x(i) = loc2(match(i),2);
        im2_y(i) = loc2(match(i),1);
    end
end

end