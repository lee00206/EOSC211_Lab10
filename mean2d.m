function outmat=mean2d(inmat,winlen)
% MEAN2D Takes a 2D running mean of an input 
% matrix. A 2D running mean is basically
% a box, with WINLEN rows and columns,
% centered around the point you are
% 'smoothing'.
%
% The mean 'wraps' around the sides,
% because 361 degrees is really 1 degree, but 
% not the  top/bottom (because there is no 91 
% degrees latitude)
% and can handle 'missing data' within
% the matrix, specified with NaN


if rem(winlen,1)~=0 %consider one more case 
    error('Window size is not an integer')
elseif rem(winlen,2)==0 %Error message pops up if winlen is an even number so the remainder should be 0
  error('Window size is an even number'); 
elseif winlen==1  % 1 point window means do nothing
   outmat=inmat;
else
   outmat=do_mean(inmat,winlen);
end

end



function Y=do_mean(X,win) %input order changed
%  DO_MEAN - 2D average missing NaNs
% performs a 2D average over
% a spatial box with WIN rows
% and columns

[nrows,ncols]=size(X); %rows come first in matrix
wn=(win-1)/2;

Y=X;
for i=1:nrows  %for all rows %one = is needed 
  for j=1:ncols % for all columns %one = is needed
      if i-wn>0 & nrows >= i+wn & j-wn>0 & ncols >= j+wn %specifying the range
     iv=i+[-wn:wn];  % indexes of rows to use
     jv=j+[-wn:wn];  % " for columns

     % Don't include points
     % above the top, below
     % the bottom

     iv(iv<1)=[];
     iv(iv>nrows)=[];

     % longitudes 'past the E or W edge'
     % wrap around.

     jv(jv<1)=jv(jv<1)+ncols;
     jv(jv>ncols)=jv(jv>ncols)-ncols;

     % Once all the indexes are selected
     % correctly, get the 2D averaging window in
     % a temporary matrix
     tmp=X(iv,jv);

     % How to handle 'edge effects' around
     % land - I will only average over the
     % water points (i.e. the ones that aren't
     % NaN), AS LONG AS we are averaging 
     % AROUND a central point that is in the
     % ocean
     if isfinite(X(i,j)) %check that we're over ocean
       ii=isfinite(tmp(:));
       Y(i,j)=mean(tmp(ii)); %row index (i) should come first
     end
      end

  end
end
 
end

%   partner.name='Christopher Ng';
%   Time_spent= 06;

