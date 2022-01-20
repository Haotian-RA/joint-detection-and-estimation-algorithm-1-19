#ifndef __Innerp_ctxcrx_H
#define __Innerp_ctxcrx_H

#include <vector>
#include "FFT.h"
#include "Frame.h"
#include <complex>

//! @brief Compute inner-product between auto-correlation of received data and of the preamble with pre-defined sample difference. 
template<typename T,typename U> 
class Innerp_ctxcrx{

    private:

        //! @brief a state stores the fast fourier transform of the auto-correlation of the preamble.
        std::vector<T> _fft_ctx;

    public:

        //! @brief A constructor that calculates the fast fourier transform of the auto-correlation of the preamble with pre-defined sample difference (k).
        Innerp_ctxcrx(std::vector<T> tx,size_t preamble_len,size_t k,size_t frame_len){

            std::vector<T> ctx_vector;
            for (size_t m=k;m<preamble_len;m++)
                ctx_vector.push_back(std::conj(tx[m-k])*tx[m]); // autocorrelation of tx with sample difference k.
            
            std::vector<T> zeros(frame_len-ctx_vector.size()); 
            std::reverse(ctx_vector.begin(),ctx_vector.end());
            ctx_vector.insert(ctx_vector.end(),zeros.begin(),zeros.end()); // zero padding for making ctx_vector the same length as crx_vector.
            _fft_ctx = fft(ctx_vector,false); // fft of ctx_vector in constructor
        }; 

    //! @brief A functor computes inner-product between auto-correlation of received data and of the preamble with pre-defined sample difference (k). 
    //!
    //! @param frame_ptr includes the auto-correlation of received data with sample difference k.
    //! @return The same shared pointer pointing to the frame that stores a vector of the inner-product result in size of frame length.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        std::vector<T> fft_crx = fft(frame_ptr->crx_vector,false); // fft of crx_vector in size of frame length.

        for (size_t i=0;i<fft_crx.size();i++)
            fft_crx[i]=fft_crx[i]*_fft_ctx[i]; // time domain convolution transformed to frequency domain multiplication.

        frame_ptr->y = fft(fft_crx,true); // ifft of above results (transform into time domain) and store in frame.

        return frame_ptr;

    }; // functor
}; // class Corr_ctxcrx

#endif // __Innerp_ctxcrx_H 