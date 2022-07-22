% load raw human kidney data 

% load('C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Raw\IMG1.m')
% load('C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Raw\cmask_CF1_V3.m')
% load('C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Raw\IMG2.m')
% load('C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Raw\cmask_CF2_V3.m')
% load('C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Raw\IMG3.m')
% load('C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Raw\cmask_CF3_V3.m')

% cmask1 = cmask_CF1_V3;
% cmask2 = cmask_CF2_V3;
% cmask3 = cmask_CF3_V3;


IMG = IMG1.*cmask1;
% IMG = IMG2.*cmask2;
% IMG = IMG3.*cmask3;
[sx,sy,sz] = size(IMG);

cmask =cmask1;
% cmask = cmask2;
% cmask = cmask3;

% path to the generated patches 
fpath = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Patch\CF1';
% fpath = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Patch\CF2';
% fpath = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Human\Patch\CF3';

tx = 64;
ty = 64;
tz = 32;

% nx = sx/ts;
% ny = sy/ts;
nx = (sx-tx)/(tx/4)+1;
ny = (sy-ty)/(ty/4)+1;
nz = (sz-tz)/(tz/4)+1;

si = 0;

for nzi = 1:nz
    
     wzl = 8*(nzi-1)+1;
     wzr = wzl + tz -1;
    
    for nxi = 1:nx
        
        wxl = 16*(nxi-1)+1;
        wxr = wxl + tx -1;
        
        for nyi = 1:ny
            
            wyl = 16*(nyi-1)+1;
            wyr = wyl + ty -1;
            
    
            IMGi = IMG(wxl:wxr,wyl:wyr,wzl:wzr);
            cmaski = cmask(wxl:wxr,wyl:wyr,wzl:wzr);
            
            
            if sum(cmaski(:)) == tx*ty*tz
                
                file = strcat(num2str(si),'.mat');
                filepath = fullfile(fpath,file);
                save(filepath,'IMGi'); 
 
                si = si+1;
                
           
            end 
            
            
        end 
    end 
end 

