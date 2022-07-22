% folder of the clean sythentic blob image
blobImgDir = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Blob\GAN3DBlobs_64_64_32\Blobs';
% folder of the noisy sythentic blob image
blobImgWNoiseDir = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Blob\GAN3DBlobs_64_64_32\BlobsWNoises';
% folder of centroids label of sythentic blob 
blobCenterDir = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Blob\GAN3DBlobs_64_64_32\Center';
% folder of centroids coordinates of sythentic blob 
blobCoordsDir = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Blob\GAN3DBlobs_64_64_32\Coords';
% folder of segmentation label of sythentic blob 
blobLabelDir = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Blob\GAN3DBlobs_64_64_32\Label';
% folder of overlap label of sythentic blob 
blobOverlapDir = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Blob\GAN3DBlobs_64_64_32\Overlap';


% Note:
% We only use Blobs (clean blobs) and BlobsWNoises (noisy blobs) in BlobGAN
% for BlobMask, it is generated in python code

% create folders
mkdir(blobImgDir);
mkdir(blobImgWNoiseDir);
mkdir(blobCenterDir);
mkdir(blobCoordsDir);
mkdir(blobLabelDir);
mkdir(blobOverlapDir);

% Blob size is 64x64x32
imgsize = 64;
imgsizeZ = 32;

% Number of blob images
% numsamples = 1000;
numsamples = 10;

for blobidx = 1:numsamples
    
    % random noise degree (SNR)
    sdb = randi([1,100],1)*0.01;
    
    % random number of blobs per image 
    blobnum = randi([500,800],1);

    img = zeros(imgsize,imgsize,imgsizeZ);
    imgcenter = zeros(imgsize,imgsize,imgsizeZ);
    imgoverlap = zeros(imgsize,imgsize,imgsizeZ);
    gtcoords = zeros(1,3);

    for i = 1:blobnum
        % random blob params 
        theta = randi([0,100],1)*0.01 * pi ;
        fi = randi([0,100],1)*0.01 * pi ;
        sigmax = randi([5,15],1) * 0.1;
        sigmay = randi([5,15],1) * 0.1;
        sigmaz = randi([5,15],1) * 0.1;
        sigma = [sigmax,sigmay,sigmaz];
       
        radii = 3;  
        blobrad = [radii-1,radii-1,radii-1];

        Range = [radii imgsize-radii];
        RangeZ = [radii imgsizeZ-radii];

        % random blob location by generating random blob centroids
        centerX = randi(Range,1);
        centerY = randi(Range,1);
        centerZ = randi(RangeZ,1);
        
        % coordinates of blobs centroids
        gtcoords(i,1) = centerX;
        gtcoords(i,2) = centerY;
        gtcoords(i,3) = centerZ;
        
        % generate blobs with random parameters
        blobpatch = gauss3var(sigma,theta,fi,blobrad);

        % center of label 
        blobcenter = zeros(5,5,5);  
        blobcenter(3,3,3) = 1;

        % segmented label for each blob  
        seggt = blobpatch;
        seggt(seggt<0.1) = 0;
        seggt(seggt>0) = 1;

        img(centerX-2:centerX+2,centerY-2:centerY+2,centerZ-2:centerZ+2) = img(centerX-2:centerX+2,centerY-2:centerY+2,centerZ-2:centerZ+2)+ blobpatch;
        imgcenter(centerX-2:centerX+2,centerY-2:centerY+2,centerZ-2:centerZ+2) = imgcenter(centerX-2:centerX+2,centerY-2:centerY+2,centerZ-2:centerZ+2)+ blobcenter;
        imgoverlap(centerX-2:centerX+2,centerY-2:centerY+2,centerZ-2:centerZ+2) = imgoverlap(centerX-2:centerX+2,centerY-2:centerY+2,centerZ-2:centerZ+2)+ seggt; 

    end 

img = 1-img;
imglabel = imgoverlap;
imglabel(imglabel>1) = 1;

% generate noisy blobs images
v = var(img(:))/(10^(sdb/10));
img_noise = imnoise(img,'gaussian',0,v);


% plot these images 
% figure;imshow3D(1-img);
% figure;imshow3D(imglabel);
% figure;imshow3D(imgcenter);
% figure;imshow3D(imgoverlap);

% save 3D data as mat datatype 
blobmat = strcat(num2str(blobidx),'.mat');

blobpath = fullfile(blobImgDir,blobmat);
save(blobpath,'img');

blobnoisepath = fullfile(blobImgWNoiseDir,blobmat);
save(blobnoisepath,'img_noise');

blobCenterpath = fullfile(blobCenterDir,blobmat);
save(blobCenterpath,'imgcenter');

blobCoordspath = fullfile(blobCoordsDir,blobmat);
save(blobCoordspath,'gtcoords');

blobLabelpath = fullfile(blobLabelDir,blobmat);
save(blobLabelpath,'imglabel');

blobOverlappath = fullfile(blobOverlapDir,blobmat);
save(blobOverlappath,'imgoverlap');


end

