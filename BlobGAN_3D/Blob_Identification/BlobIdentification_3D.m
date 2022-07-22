% path of denoising results 
BlobGANPredImgfolder = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Image_Denoising\results\blob_gan_3D_Denoising\';

% path of final identified results
BlobGANpredictfolder = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Blob_Identification\Results';

for i = 1:1000
    
    imgname = strcat(num2str(i),'_fake_A.mat');
    pimgfilepath = fullfile(BlobGANPredImgfolder,imgname);
    
    % load denoised results
    PIMG = load(pimgfilepath);
    PIMGi = getfield(PIMG,'items');
    PIMG = double(PIMGi); 
    PIMG2=(PIMG-min(PIMG(:)))./(max(PIMG(:))-min(PIMG(:)));
    
    % get Hessian Convexity Mask 
    PIMG3 = 1-PIMG2;
    [HessianMask]=ConvexDetector3D(PIMG3,'negative');

    % get Blob Mask 
    BlobMask = PIMG3;
    BlobMask(BlobMask<0.3) = 0;
    BlobMask(BlobMask>0) = 1;
    
    % join Hessian Mask with Blob Mask
    MaskBlobGAN = HessianMask.*BlobMask;

    BlobGANmatname = strcat(num2str(i),'_BlobGAN_candidates.mat');
    BlobGANpredictmatpath = fullfile(BlobGANpredictfolder,BlobGANmatname);
    save(BlobGANpredictmatpath,'MaskBlobGAN');
   
end 




