close all

x = 0:0.001:10;

for i = 1%:10
    
    freq(i) = i;
    
    thresh = 0.5;
    
    y1 = sin(freq(i)*2*pi*x);
    y2 = -y1;
    y1 = y1 - thresh;
    y2 = y2 - thresh;
    
    figure(1)
    subplot(2,2,1)
    plot(x,y1)
    hold on 
    plot(x,y2,'g')
    
    y1(y1<0) = 0;
    y2(y2<0) = 0;
    
    hold on
    plot(x,y1,'r')
    
    subplot(2,1,2)
    plot(x,cumsum(y1))
    hold on 
    
    inty1 = cumsum(y1);
    
    areas(i)=inty1(end);
    
end

figure(i+1)
plot(freq, areas)
