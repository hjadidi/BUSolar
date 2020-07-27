%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This code is written by Hossein Jadidi (email:hossein.jadidi@gmail.com)
%The code relates to the original paper in the Solar Energy Journal with the subject of
%"Bayesian updating of solar resource data for risk mitigation in project finance"
%The code updates the probability distribution of hourly long-term GHI using ground
%measurements via the Bayesian updating method. The details of the method are
%available in the mentioned paper.  
%The output of the code is "post" matrix. Each row of the
%matrix shows the estimated mean value(first column) and 
%standard deviation(second column) of GHI probability distribution
%at the selected location for ith hour throughout a year.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc
clear
close all
Num_Counter = waitbar(0,'Please wait...');
A=xlsread('SourceMCMC_NSRDB','D2:X8761');    %Satellite-based matrix
C=xlsread('SourceMCMC_NSRDB','Y2:AB8761');   %Observation matrix
 TotalYear=size(A);
 X1=A(:,17);     %2014 Solcast
 X2=A(:,18);    %2015 Solcast
 X3=A(:,19);    %2016 Solcast
 X4=A(:,21);    %2018 Solcast
 X=[X1;X2;X3;X4];
 Y1=C(:,1);    %2014 obs
 Y2=C(:,2);    %2015 obs
 Y3=C(:,3);    %2016 obs
 Y4=C(:,4);    %2018 obs
 Y=[Y1;Y2;Y3;Y4];     
 
it=100;     %iteration
TotalHour=8760;
dataSim=A;
prr=zeros(TotalHour,2);
post=zeros(TotalHour,2); 
Theta=zeros(TotalHour,it); 
for i=1:TotalHour
    if nansum(A(i,:))>TotalYear(2)   
       prr(i,:)=mle(dataSim(i,:),'distribution','Normal');       %prior distribution 
       if Y1(i)+Y2(i)+Y3(i)+Y4(i)~=0   
           %%%%%%%%%%%%%%%%%%%%%%%%%%%Posterior Distribution%%%%%%%%%%%%%%%%%5555
           Lk1=1;
           Lk2=1;
           Lk3=1;
           Lk4=1;
           Lk5=1;
           sigma=1*prr(i,2);       
           pd=makedist('Normal','mu',prr(i),'sigma',prr(i,2));
           T1=random(pd);
           T2=random(pd);
           for j=1:it      
               F1=prior(T1,prr(i),prr(i,2));
               F2=prior(T2,prr(i),prr(i,2));
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%First Observation%%%%%%%%%%%%%%%%%%%%%%%%%
               if Y1(i)>0 
               Lk1=lk(T1,Y1(i),sigma);
               end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Second Observation%%%%%%%%%%%%%%%%%%%%%%%%%     
               if Y2(i)>0
               Lk2=lk(T1,Y2(i),sigma);           
               end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Third Observation%%%%%%%%%%%%%%%%%%%%%%%%% 
               if Y3(i)>0
               Lk3=lk(T1,Y3(i),sigma);
               end
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Fourth Observation%%%%%%%%%%%%%%%%%%%%%%%%% 
               if Y4(i)>0
               Lk4=lk(T1,Y4(i),sigma);
               end
               %%%%%%%%%%%%%%%
               L1=Lk1*Lk2*Lk3*Lk4;
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
               Lk11=1;
               Lk22=1;
               Lk33=1;
               Lk44=1;
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%First Observation%%%%%%%%%%%%%%%%%%%%%%%%%
                if Y1(i)>0 
                Lk11=lk(T2,Y1(i),sigma);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Second Observation%%%%%%%%%%%%%%%%%%%%%%%%%     
                if Y2(i)>0
                Lk22=lk(T2,Y2(i),sigma);           
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Third Observation%%%%%%%%%%%%%%%%%%%%%%%%% 
                if Y3(i)>0
                Lk33=lk(T2,Y3(i),sigma);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Fourth Observation%%%%%%%%%%%%%%%%%%%%%%%%% 
                if Y4(i)>0
                Lk44=lk(T2,Y4(i),sigma);
                end
                %%%%%%%%%%%%%%%%
                %%%%%%%%%%%%%%%%
                L2=Lk11*Lk22*Lk33*Lk44;   
                %%%%%%%%%%%%
                %%%%%%%%%%%%
                u=rand;                          
                delta=(F2*L2)/(F1*L1);
                if delta>u
                    T1=T2;
                    Theta(i,j)=T1;
                    T2=random(pd);
                else
                    c=0;
                    check=0;
                    while c<1
                        T2=random(pd);
                        F2=prior(T2,prr(i),prr(i,2));
                        Lk111=1;
                        Lk222=1;
                        Lk333=1;
                        Lk444=1;
                        Lk555=1;
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%First Observation%%%%%%%%%%%%%%%%%%%%%%%%%
                        if Y1(i)>0 
                        Lk111=lk(T2,Y1(i),sigma);
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Second Observation%%%%%%%%%%%%%%%%%%%%%%%%%     
                        if Y2(i)>0
                        Lk222=lk(T2,Y2(i),sigma);           
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Third Observation%%%%%%%%%%%%%%%%%%%%%%%%% 
                        if Y3(i)>0
                        Lk333=lk(T2,Y3(i),sigma);
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Fourth Observation%%%%%%%%%%%%%%%%%%%%%%%%% 
                        if Y4(i)>0
                        Lk444=lk(T2,Y4(i),sigma);
                        end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        L2=Lk111*Lk222*Lk333*Lk444;                              
                        u=rand;                          
                        delta=(F2*L2)/(F1*L1);
                        if delta>u  
                           T1=T2;
                           Theta(i,j)=T1;
                           T2=random(pd);
                           c=c+1;
                        end
                        check=check+1;
                        if check>1000
                           c=c+1;
                        end
                    end
                end
           end
           z=Theta(i,:);
           z=z(z>0);
           post(i,:)=mle(z,'distribution','Normal');
       else
            post(i,1)=prr(i);
            post(i,2)=prr(i,2);
       end
    end
waitbar(i/TotalHour) 
end

close(Num_Counter);