clear;
tic
%% Ustawienie ilości punktów
N=1000;
in = 0;
out= 0;
%% Wczytywanie zdjecia i informacji o nim.
maska=imread("BW.jpg");
[row,col,colour]=size(maska);

%% Rozdzielanie kanałów
gray=rgb2gray(maska);

%% Ustawianie generatora liczb losowych
Punkty=[randi(col,N,1),randi(row,N,1)];
X=(Punkty(:,1));
Y=(Punkty(:,2));
%% Test trafionych punktow;
imshow(gray)
hold on;

%%Visual representation of random points
scatter(X(:),Y(:),'blue');

for i= 1:1:N-1
    if gray(Y(i,1),X(i,1)) == 255 
        in=in+1;
    else
        out=out+1;
    end
end
%% Liczdenie pola
wynikMC = in/(in+out) %(row*col)
toc