// @(#)root/tmva/tmva/dnn:$Id$
// Author: Simon Pfreundschuh 14/07/16

/*************************************************************************
 * Copyright (C) 2016, Simon Pfreundschuh                                *
 * All rights reserved.                                                  *
 *                                                                       *
 * For the licensing terms see $ROOTSYS/LICENSE.                         *
 * For the list of contributors see $ROOTSYS/README/CREDITS.             *
 *************************************************************************/

#include "TMVA/DNN/Architectures/Cuda.h"
#include "TMVA/DNN/Architectures/Cuda/Device.h"
#include "Kernels.cuh"

/////////////////////////////////////////////////////////////////////
// Implementation of the Dropout function for TCuda architectures. //
/////////////////////////////////////////////////////////////////////

namespace TMVA {
namespace DNN  {

//____________________________________________________________________________
template<typename AFloat>
void TCuda<AFloat>::Dropout(TCudaMatrix<AFloat> &A,
                            AFloat dropoutProbability)
{
   dim3 blockDims = TDevice::BlockDims();
   dim3 gridDims  = TDevice::GridDims(A);
   cudaStream_t s = A.GetComputeStream();
   ::TMVA::DNN::Cuda::Dropout<<<gridDims, blockDims, 0, s>>>(
       A.GetDataPointer(),
       (int) A.GetNrows(),
       (int) A.GetNcols(),
       dropoutProbability,
       TCudaMatrix<AFloat>::GetCurandStatesPointer());
}

} // namespace DNN
} // namespace TMVA
