function angle = cosine( v1,v2 )
%COSINE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
angle=0;
l1=0;
l2=0;
mul=0;
mul=sum(v1.*v2);
l1=sum(v1.*v1);
l2=sum(v2.*v2);
if l1>0 && l2>0
    angle=mul/(sqrt(l1)*sqrt(l2));
end
end

