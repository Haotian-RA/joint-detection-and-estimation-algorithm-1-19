#ifndef __FFT_H
#define __FFT_H

#include <fftw3.h>
#include <vector>
#include <complex>

//! @brief a function calculates fast fourier transform. See details in https://www.fftw.org.
template<typename T> 
std::vector<T> fft(std::vector<T> sig,bool invert){

    size_t L = sig.size();
    static const std::complex<float> J(0,1);
    fftw_complex in[L],out[L];

    for (size_t i=0;i<L;i++){
        in[i][0] = sig[i].real();
        in[i][1] = sig[i].imag();
    }

    fftw_plan p;
    if (invert==false){
        p = fftw_plan_dft_1d(L,in,out,FFTW_FORWARD,FFTW_ESTIMATE);
        fftw_execute(p);
    }else{
        p = fftw_plan_dft_1d(L,in,out,FFTW_BACKWARD,FFTW_ESTIMATE);
        fftw_execute(p);
        /* normalize */
        for (size_t i=0;i<L;i++){
            out[i][0] *= 1./L;
            out[i][1] *= 1./L;
        }
      }
        
    std::vector<T> fft_sig(L);
    for (size_t i=0;i<L;i++)
        fft_sig[i]=(float)out[i][0]+(float)out[i][1]*J;
        
    fftw_destroy_plan(p);
    fftw_cleanup();

    return fft_sig;
}

#endif // __FFT_H 