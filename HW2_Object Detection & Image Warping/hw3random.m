function hw3random(mm)
[gar match_size] = size(match);
ormatch = match;
for i=1:match_size
    match(2,i) = match(1,i);
    match(1,i) = i;
end
for i=1:match_size
    temp = [match(1,i);match(2,i)];
    r = randi([1 match_size]);
    match(1,i) = match(1,r);
    match(2,i) = match(2,r);
    match(1,r) = temp(1);
    match(2,r) = temp(2);
end
end