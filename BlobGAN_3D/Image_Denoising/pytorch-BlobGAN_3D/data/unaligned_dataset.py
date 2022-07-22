import os
from data.base_dataset import BaseDataset
import scipy.io as io
import numpy as np
from scipy.ndimage import zoom


def getVoxelFromMat(path, arrname):

    voxels = io.loadmat(path)[arrname]
    voxels = np.float32(voxels)

    # in 3D Blob synthesis, many blobs overlap so the minimum intensity is very small and make whole blobs image very dark, which is not clean
    if arrname =='img':
        voxels[voxels <0] = 0
    voxels = zoom(voxels, (2, 2, 2))

    if np.max(voxels)==np.min(voxels):
        return voxels

    voxels = (voxels - np.min(voxels)) / (np.max(voxels) - np.min(voxels))
    voxels = (voxels - 0.5)/0.5

    return voxels

class UnalignedDataset(BaseDataset):
    """
    This dataset class can load unaligned/unpaired datasets.

    It requires two directories to host training images from domain A '/path/to/data/trainA'
    and from domain B '/path/to/data/trainB' respectively.
    You can train the model with the dataset flag '--dataroot /path/to/data'.
    Similarly, you need to prepare two directories:
    '/path/to/data/testA' and '/path/to/data/testB' during test time.
    """

    def __init__(self, opt):

        BaseDataset.__init__(self, opt)

        self.files_A_path = os.path.join(os.path.join(opt.dataroot, opt.phase), 'A')
        self.files_B_path = os.path.join(os.path.join(opt.dataroot, opt.phase), 'B')

        self.files_A = os.listdir(self.files_A_path)
        self.files_B = os.listdir(self.files_B_path)

        if opt.blob_type == "noisy_blob":
            self.arrname_A = 'img'
            self.arrname_B = 'img_noise'

        if opt.blob_type == "human_glom":
            self.arrname_A = 'img'
            self.arrname_B = 'IMGi'

        if opt.blob_type == "mouse_glom":
            self.arrname_A = 'img'
            self.arrname_B = 'IMGi'

    def __getitem__(self, index):
        # load 3D blob image
        f_A = os.path.join(self.files_A_path, self.files_A[index])
        item_A = np.asarray(getVoxelFromMat(f_A, self.arrname_A), dtype=np.float32)

        # load 3D glom or 3D noisy blobs image
        f_B = os.path.join(self.files_B_path, self.files_B[index])
        item_B = np.asarray(getVoxelFromMat(f_B, self.arrname_B), dtype=np.float32)

        return {'A': item_A, 'B': item_B,'A_paths': f_A, 'B_paths': f_B}


    def __len__(self):
        return max(len(self.files_A), len(self.files_B))
