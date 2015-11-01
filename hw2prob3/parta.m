
%question 3)a. 
fid = fopen('SMSSpamCollection');            % read file
data = fread(fid);
fclose(fid);
lcase = abs('a'):abs('z');
ucase = abs('A'):abs('Z');
caseDiff = abs('a') - abs('A');
caps = ismember(data,ucase);
data(caps) = data(caps)+caseDiff;     % convert to lowercase
data(data == 9) = abs(' ');          % convert tabs to spaces
validSet = [9 10 abs(' ') lcase];         
data = data(ismember(data,validSet)); % remove non-space, non-tab, non-(a-z) characters

char(data(1:100));                    % view the first 100 characters
data = char(data);                    % convert from vector to characters

words = strread(data, '%s');          % convert from character to strings

% split into examples
count = 0;
examples = {};

for i=1:length(words)
   if (strcmp(words{i}, 'spam') || strcmp(words{i}, 'ham'))
       count = count+1;
       examples(count).spam = strcmp(words{i}, 'spam');
       examples(count).words = [];
   else
       examples(count).words{length(examples(count).words)+1} = words{i};
   end
end

%split into training and test
random_order = randperm(length(examples));
train_examples = examples(random_order(1:floor(length(examples)*.9)));
test_examples = examples(random_order(floor(length(examples)*.9)+1:end));


% count occurences for spam and ham 


spamcounts = java.util.HashMap;
numspamwords = 0;
hamcounts = java.util.HashMap;
numhamwords = 0;

alpha = 0.1;

for i=1:length(train_examples)
    for j=1:length(train_examples(i).words)
        word = train_examples(i).words{j};
        
        if (train_examples(i).spam == 1)
            numspamwords = numspamwords+1;
            current_count = spamcounts.get(word);
            if (isempty(current_count))
                spamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                spamcounts.put(word, current_count+1);  % increment
            end
        else
            numhamwords = numhamwords+1;
            current_count = hamcounts.get(word);
            if (isempty(current_count))
                hamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                hamcounts.put(word, current_count+1);  % increment
            end
        end
        
    end    
end

%disp(spamcounts.get('free')/(numspamwords+alpha*20000));   % probability of word 'free' given spam
%(hamcounts.get('free')/(numhamwords+alpha*20000));   % probability of word 'free' given ham
% will need to check if count is empty!
spamtrain=0;
for i=1:length(train_examples)
    if(train_examples(i).spam==1)
        spamtrain=spamtrain+1;
    end
end
sprior=(spamtrain/length(train_examples)); %computing the prior if the given message is a spam. 
hprior=1-sprior; % computing the prior if the given message is a ham. 
for i=1:length(test_examples)
    sposterior=0;  % spam posterior for every message 
    hposterior=0;  % ham posterior for every message 
    for j=1:length(test_examples(i).words)
        if(spamcounts.get(char(test_examples(i).words(j))))
        sposterior=sposterior+log(spamcounts.get(char(test_examples(i).words(j))))-log(numspamwords+alpha*20000); %likelihood of the message given spam
        end
        if(hamcounts.get(char(test_examples(i).words(j))))
        hposterior=hposterior+log(hamcounts.get(char(test_examples(i).words(j))))-log(numhamwords+alpha*20000); % likelihood of the message given ham
        end
    end
    sposterior=sposterior+log(sprior); %multiplying the likelihood with prior to compute spam posterior
    hposterior=hposterior+log(hprior); %multiplying the likelihood with prior to compute ham posterior
    if(exp(sposterior)>exp(hposterior)) %predicting the value based on the values of both the posteriors
        predictor(i)=1;
    else
        predictor(i)=0;
    end
end
 for i=1:length(test_examples)
len(i)=length(test_examples(i).words);
 end
distinct=unique(len);  % finding messages of distinct length
 for i=1:length(distinct)
counter=0;
a=find(len==distinct(i));
for j=1:length(a)
if(test_examples(a(j)).spam==predictor(a(j)))
counter=counter+1;
end
end
p(i)=counter/length(a); % finding accuracy of messages in different lengths separately
 end
 sum=zeros(1,6);
 c=zeros(1,6); 
for i=1:length(distinct)    %grouping the accuracies by calculating the average accuracy for every group. 
    if(distinct(i)<=10)
        j=1;            
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>10 && distinct(i)<=20)
        j=2;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>20 && distinct(i)<=30)
        j=3;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>30 && distinct(i)<=40)
        j=4;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>40 && distinct(i)<=50)
        j=5;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    else
        j=6;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    end
end    
for i=1:length(sum)
    sum(i)=sum(i)/c(i);
end
plot(linspace(10,60,6),sum,'r*-');
set(gca,'xtick',[10,20,30,40,50,60]);
set(gca,'xticklabel',{'1 to 10','10 to 20','20 to 30','30 to 40','40 to 50','50 and above'});
xlabel('message lengths');
ylabel('average accuracies');
figure;












% Question 3) b The following part separates the least and most frequent
% words into two string arrays. 

wordfreq=java.util.HashMap;
for i=1:length(train_examples)
    for j=1:length(train_examples(i).words)
        word = train_examples(i).words{j};
       
         
            current_count = wordfreq.get(word);
            if (isempty(current_count))
                wordfreq.put(word, 1);    
            else
               wordfreq.put(word, current_count+1);  % increment
            end
    end    
end

a=wordfreq.keySet.toArray.cell;
freq={};
for i=1:wordfreq.size()
	freq(i).word=a(i);
	freq(i).value=wordfreq.get(char(a(i)));
end

[~,sx]=sort([freq.value]);
ss=freq(sx);
freq=ss;
freq1=freq(1:(length(freq)/2)); %freq1 is the least probable N/2 words of training examples. 
freq2=freq(((length(freq)/2)+1):length(freq));  %freq2 is the most probable N/2 words of training examples.

for i=1:length(freq1)
    f1(i)=freq1(i).word;    %f1 is the array that contains the least frequent N/2 words
end

for i=1:length(freq2)
    f2(i)=freq2(i).word;    %f2 is the array that contains the most frequent N/2 words
end






%The following part predicts only for the least frequent N/2 words. 
%using the same methods that were used for 3)a
% count occurences for spam and ham 
% including the least N/2 probable words only


spamcounts = java.util.HashMap;
numspamwords = 0;
hamcounts = java.util.HashMap;
numhamwords = 0;

alpha = 0.1;

for i=1:length(train_examples)
    for j=1:length(train_examples(i).words)
        word = train_examples(i).words{j};
        if(strmatch(word,f1))
        if (train_examples(i).spam == 1)
            numspamwords = numspamwords+1;
            current_count = spamcounts.get(word);
            if (isempty(current_count))
                spamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                spamcounts.put(word, current_count+1);  % increment
            end
        else
            numhamwords = numhamwords+1;
            current_count = hamcounts.get(word);
            if (isempty(current_count))
                hamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                hamcounts.put(word, current_count+1);  % increment
            end
        end
        end
    end    
end

%disp(spamcounts.get('free')/(numspamwords+alpha*20000));   % probability of word 'free' given spam
%(hamcounts.get('free')/(numhamwords+alpha*20000));   % probability of word 'free' given ham
% will need to check if count is empty!
spamtrain=0;
for i=1:length(train_examples)
    if(train_examples(i).spam==1)
        spamtrain=spamtrain+1;
    end
end
sprior=(spamtrain/length(train_examples));
hprior=1-sprior;
for i=1:length(test_examples)
    sposterior=0;
    hposterior=0;
    for j=1:length(test_examples(i).words)
        if(spamcounts.get(char(test_examples(i).words(j))))
        sposterior=sposterior+log(spamcounts.get(char(test_examples(i).words(j))))-log(numspamwords+alpha*20000); 
        end
        if(hamcounts.get(char(test_examples(i).words(j))))
        hposterior=hposterior+log(hamcounts.get(char(test_examples(i).words(j))))-log(numhamwords+alpha*20000); 
        end
    end
    sposterior=sposterior+log(sprior);
    hposterior=hposterior+log(hprior);
    if(exp(sposterior)>exp(hposterior))
        predictor(i)=1;
    else
        predictor(i)=0;
    end
end
 for i=1:length(test_examples)
len(i)=length(test_examples(i).words);
 end
distinct=unique(len);
 for i=1:length(distinct)
counter=0;
a=find(len==distinct(i));
for j=1:length(a)
if(test_examples(a(j)).spam==predictor(a(j)))
counter=counter+1;
end
end
p(i)=counter/length(a);
 end
 sum=[0 0 0 0 0 0];
 c=zeros(1,6);
for i=1:length(distinct)
    if(distinct(i)<=10)
        j=1;            
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>10 && distinct(i)<=20)
        j=2;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>20 && distinct(i)<=30)
        j=3;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>30 && distinct(i)<=40)
        j=4;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>40 && distinct(i)<=50)
        j=5;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    else
        j=6;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    end
end    
plot([10 20 30 40 50 60],sum,'g*-');
set(gca,'xtick',[10,20,30,40,50,60]);
set(gca,'xticklabel',{'1 to 10','10 to 20','20 to 30','30 to 40','40 to 50','50 and above'});
xlabel('message lengths');
ylabel('average accuracies');
figure;






%The following part predicts only for the most frequent words using the
%same methods used for 3)a

spamcounts = java.util.HashMap;
numspamwords = 0;
hamcounts = java.util.HashMap;
numhamwords = 0;

alpha = 0.1;
for i=1:length(train_examples)
    for j=1:length(train_examples(i).words)
        word = train_examples(i).words{j};
        if(strmatch(word,f2))
        if (train_examples(i).spam == 1)
            numspamwords = numspamwords+1;
            current_count = spamcounts.get(word);
            if (isempty(current_count))
                spamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                spamcounts.put(word, current_count+1);  % increment
            end
        else
            numhamwords = numhamwords+1;
            current_count = hamcounts.get(word);
            if (isempty(current_count))
                hamcounts.put(word, 1+alpha);    % initialize by including pseudo-count prior
            else
                hamcounts.put(word, current_count+1);  % increment
            end
        end
        end
    end    
end

%disp(spamcounts.get('free')/(numspamwords+alpha*20000));   % probability of word 'free' given spam
%(hamcounts.get('free')/(numhamwords+alpha*20000));   % probability of word 'free' given ham
% will need to check if count is empty!
spamtrain=0;
for i=1:length(train_examples)
    if(train_examples(i).spam==1)
        spamtrain=spamtrain+1;
    end
end
sprior=(spamtrain/length(train_examples));
hprior=1-sprior;
for i=1:length(test_examples)
    sposterior=0;
    hposterior=0;
    for j=1:length(test_examples(i).words)
        if(spamcounts.get(char(test_examples(i).words(j))))
        sposterior=sposterior+log(spamcounts.get(char(test_examples(i).words(j))))-log(numspamwords+alpha*20000); 
        end
        if(hamcounts.get(char(test_examples(i).words(j))))
        hposterior=hposterior+log(hamcounts.get(char(test_examples(i).words(j))))-log(numhamwords+alpha*20000); 
        end
    end
    sposterior=sposterior+log(sprior);
    hposterior=hposterior+log(hprior);
    if(exp(sposterior)>exp(hposterior))
        predictor(i)=1;
    else
        predictor(i)=0;
    end
end
 for i=1:length(test_examples)
len(i)=length(test_examples(i).words);
 end
distinct=unique(len);
 for i=1:length(distinct)
counter=0;
a=find(len==distinct(i));
for j=1:length(a)
if(test_examples(a(j)).spam==predictor(a(j)))
counter=counter+1;
end
end
p(i)=counter/length(a);
 end
 sum=[0 0 0 0 0 0];
 c=zeros(1,6);
for i=1:length(distinct)
    if(distinct(i)<=10)
        j=1;            
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>10 && distinct(i)<=20)
        j=2;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>20 && distinct(i)<=30)
        j=3;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>30 && distinct(i)<=40)
        j=4;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    elseif(distinct(i)>40 && distinct(i)<=50)
        j=5;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    else
        j=6;
        sum(j)=sum(j)+p(i);
        c(j)=c(j)+1;
    end
end    
for i=1:length(sum)
    sum(i)=sum(i)/c(i);
end
plot(linspace(10,60,6),sum,'b*-');
set(gca,'xtick',[10,20,30,40,50,60]);
set(gca,'xticklabel',{'1 to 10','10 to 20','20 to 30','30 to 40','40 to 50','50 and above'});
xlabel('message lengths');
ylabel('average accuracies');
figure;

