% path of raw data 
kidneypath = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Mouse\Raw';
% path of patch data 
fpath = 'C:\Users\yanzhexu\Desktop\Phase II\BlobGAN\BlobGAN_3D\Dataset_3D\Mouse\Patch';

kidneys = dir(kidneypath);

% random pick location to get each one 
si = 0;

for kidx = 3:length(kidneys)
    
    kname = kidneys(kidx).name;
    display(kname);
    kpath = fullfile(kidneypath,kname);
    knamesplit = split(kname,'.mat'); 
    
    kimg = load(kpath);
    
    IMG = getfield(kimg,knamesplit{1,1});
    IMGB = logical(IMG);
    
    [sx,sy,sz] = size(IMG);
   
    
    tx = 64;
    ty = 64;
    tz = 32;
    
    interv = 8;
    
    nx = (sx-tx)/(tx/interv)+1;
    ny = (sy-ty)/(ty/interv)+1;
    nz = (sz-tz)/(tz/interv)+1;

    si = 0;

    for nzi = 1:nz

         wzl = (tz/interv) *(nzi-1)+1;
         wzr = wzl + tz -1;

        for nxi = 1:nx

            wxl = (tx/interv)*(nxi-1)+1;
            wxr = wxl + tx -1;

            for nyi = 1:ny

                wyl = (ty/interv)*(nyi-1)+1;
                wyr = wyl + ty -1;


                IMGi = IMG(wxl:wxr,wyl:wyr,wzl:wzr);
                IMGBi = IMGB(wxl:wxr,wyl:wyr,wzl:wzr);


                if sum(IMGBi(:)) == tx*ty*tz

                    file = strcat(num2str(si),'.mat');
                    filepath = fullfile(fpath,file);
                    save(filepath,'IMGi'); 

                    si = si+1;


                end 


            end 
        end 
    end 
  
end 