%a=arduino()
[Y1, fs]=audioread('D:/shruti_high.wav');
player1 = audioplayer(Y1,fs)
[Y2, fs]=audioread('D:/shruti_low.wav');
player2 = audioplayer(Y2,fs)


flag=0;
flag2=0;
flag3=0;
A=[];
c=clock;
fix(c);
t1=c(4)*60*60 + c(5)*60 + c(6);
t2=t1;
t3=t1;

%for i = 1:10000;
%    A=[A readVoltage(a,'A0')];
%end
k=0;
T=[]

while(t2-t1<=10.2)
   c=clock;
   fix(c);
   t2=c(4)*60*60 + c(5)*60 + c(6);
   k=k+0.2;
   %A=[A sawtooth(k)];
   A=[A readVoltage(a,'A0')];
   
   
   T=[T t2];
   
   
   
end
D=lowpass(A,200,10000);

len=length(A);

% plot(A);
% figure;
% %plot(abs(fftshift(fft(A))));
% D=lowpass(A,200,10000);
%[E, F]=findpeaks(A);
[E,F]=findpeaks(D,'MinPeakDistance',30);
plot(D);
%hold on
%scatter(F,E);
axis([0 length(D) 0 5])
drawnow;

% plot(D);
% hold on
% scatter(F,E);
%disp('BPM : ');
%disp(length(E)*6);
n_p=length(E);
t_p=T(F(length(E)))-T(1);
fprintf('BPM: %d\n', n_p*60/t_p);

if(length(E)*6>90);
    disp('WARNING: HIGH HEART RATE')
    
end
if(length(E)*6<60);
    disp('WARNING: LOW HEART RATE')
end
%x=round(length(E));
%y=x;
prev=n_p*60/t_p;
while(t2-t3<200)
    %clf('reset');
    B=A;
    t1=t2;
    A=[];
    T=[];
    ctr=0;
    while((t2-t1)<10.2)
      c=clock;
      fix(c);
      t2=c(4)*60*60 + c(5)*60 + c(6); 
      k=k+0.2;
%       A=[A sawtooth(k)];
      A=[A readVoltage(a,'A0')];
%       D=lowpass(A,200,10000);
      T=[T t2];
%       plot(D);
%       axis([0 len -2 2])
%       drawnow;
      
      if(mod(t2-t1,2)<0.1 && flag2==0 && (t2-t1)>2)
          D=lowpass(A,200,10000);
          clf;
          plot(D);
          %hold on
          %scatter(F,E);
          axis([0 len 0 5])
          drawnow;
          flag2=1;
%           [E,F]=findpeaks(A);
          [E,F]=findpeaks(D,'MinPeakDistance',30);
          %n_p = number of peaks; t_p = time between first and last peak
          n_p=length(E)-1;
          t_p=T(F(length(E)))-T(1);
          ctr=ctr+1;
          if(t_p==0 || ctr<=1)
              disp(prev);
              if(prev>75)
                  play(player1);
              elseif(prev<50)
                  play(player2);
              else
                  stop(player1);
                  stop(player2);
              end
              disp(ctr);
          else
              disp((n_p*60)/t_p);
              if((n_p*60)/t_p>75)
                  play(player1);
              elseif((n_p*60)/t_p<50)
                  play(player2);
              else
                  stop(player1);
                  stop(player2);
              end
              disp(ctr);
          end
      end
      if(flag2==1 && mod(t2-t1,1)>0.1)
          flag2=0;
      end
      
      
      
    end
    prev=(n_p*60)/t_p;
%     %disp(length(A))
% %     D=lowpass(A,200,10000);
%     [E,F]=findpeaks(A);
%     %disp((x+y+length(E))*2);
%     fprintf('BPM: %d\n', (x+y+length(E))*2);
% 
%     if((x+y+length(E))*2>90);
%         disp('WARNING: HIGH HEART RATE')
%     end
%     if((x+y+length(E))*2<60);
%         disp('WARNING: LOW HEART RATE')
%     end
%     if(flag==0)
%         y=length(E);
%         flag=1;
%     else
%         x=y;
%         y=length(E);
%     end
end
