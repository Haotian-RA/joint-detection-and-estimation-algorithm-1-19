#ifndef __Phasor_est_sd_H
#define __Phasor_est_sd_H

#include <vector>
#include <complex>
#include <cmath>
#include "Frame.h"

//! @brief Compute numerator of phasor of the SD estimator.
//!
//! This class can increase the throughput of pipeline by computing sub numerator of phasor.
template<typename T,typename U> 
class Phasor_sd{

    private:

        //! @brief a multiplier for correcting frequency offset (mid point of subvector). 
        float mid_of_subv;

        //! @brief a state stores the number of sub computation of numerator of phasor.
        size_t _nth_sub; 

    public:

        //! @brief A constructor that initializes a multiplier for correcting frequency offset.
        Phasor_sd(size_t nth_sub,size_t n_sub,size_t preamble_len):_nth_sub(nth_sub){
            
            mid_of_subv=(float)preamble_len/(2*n_sub);
        }; 

    //! @brief A functor computes numerator of phasor of the SD estimator. 
    //!
    //! @param frame_ptr includes (sub) cross-correlation between received data and (part of) the preamble.
    //! @return The same shared pointer pointing to the frame that stores a vector of (sub) numerator of phasor of the SD estimator.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        static const float pi = std::acos(-1.0);
        static const std::complex<float> J(0,1);
        T sub_s;

        for (size_t i=0;i<frame_ptr->sub_ctxrx[2*(_nth_sub-1)].size();i++){

            sub_s=0;
            for (size_t j=2*(_nth_sub-1);j<2*_nth_sub;j++)
                frame_ptr->S[i]+=frame_ptr->sub_ctxrx[j][i]*std::exp(J*(-2*pi*frame_ptr->delta_sd[i]*(2*j+1)*mid_of_subv)); 
                // sample at index n in vector of numerator of phasor = sum_{m=0}{16}(r_{mn}s*_{mn})e^{-j2*pi*delta_sd[m]*(2*m+1)*N/32}
        }
    
        return frame_ptr;

    }; // functor
}; // class Phasor_sd

#endif // __Phasor_est_sd_H 