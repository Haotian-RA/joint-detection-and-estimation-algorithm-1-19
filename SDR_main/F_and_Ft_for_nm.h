#ifndef __F_and_Ft_for_nm_H
#define __F_and_Ft_for_nm_H

#include <vector>
#include <cmath>
#include <complex>
#include "Frame.h"

//! @brief Compute two important elements (F and Ft) for building the NM estimator.
//!
//! This class can increase the throughput of pipeline by computing sub F and Ft.
template<typename T,typename U> 
class F_and_Ft{

    private:

        //! @brief two states record which part of detected preamble and pre-defined preamble should be computed.
        size_t n_start,n_end;

        //! @brief a variable of matrix stores the auto-correlation between samples in the preamble with all sample differences.
        std::vector<std::vector<T>> _ctx_vector_all;

        //! @brief a variable stores the preamble.
        std::vector<T> _tx;

        //! @brief a state stores the number of sub computation of F and Ft.
        size_t _nth_sub;

    public:

        //! @brief A constructor that initializes some variables for calculating sub F and Ft.
        F_and_Ft(size_t n_sub,size_t nth_sub,size_t preamble_len,std::vector<T> tx):_tx(tx),_nth_sub(nth_sub){

            _ctx_vector_all=std::vector<std::vector<T>>(preamble_len);

            // duration of detected preamble and tx (ctx_vector_all) that will be processed.
            n_start=(size_t)(((float)(nth_sub-1)/n_sub)*preamble_len);
            n_end=(size_t)((float)nth_sub/n_sub*preamble_len);

            for (size_t k=0;k<preamble_len;k++){

                for (size_t m=k;m<preamble_len;m++)
                    _ctx_vector_all[k].push_back(std::conj(tx[m-k])*tx[m]); // autocorrelation of tx with all sample differences.
            }

        };

    //! @brief A functor computes (sub) two important elements (F and Ft) for building the NM estimator.
    //!
    //! @param frame_ptr includes a matrix of detected preamble vector.
    //! @return The same shared pointer pointing to the frame that stores two vectors of (sub) F and Ft in size of number of sub-computation.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        static const float pi = std::acos(-1.0);
        static const std::complex<float> J(0,1);
        size_t count=0;

        for (size_t i:frame_ptr->p_preamble){

            std::vector<T> rx=frame_ptr->rx_dect[count];
            count++;

            T F=0,Ft=0;
            for (size_t k=n_start;k<n_end;k++){

                T v;
                for (size_t m=k;m<rx.size();m++)
                    v+=rx[m-k]*std::conj(rx[m])*_ctx_vector_all[k][m-k]; 

                v=v*(U)k*std::exp(J*(2*pi*frame_ptr->delta_sd[i]*k));
                F+=v; // F is calculate directly from definition: F=sum_{k=n_start}{n_end}sum_{m=k}{N-1}(kr_{m-k}r*_ms*_{m-k}s_me^{j2*pi*delta_sd*k})
                Ft+=J*(2*pi*k*v); // Ft is similar to F but with multiplier J*2*pi*k^2
            }

            frame_ptr->sub_F[_nth_sub-1].push_back(F);
            frame_ptr->sub_Ft[_nth_sub-1].push_back(Ft);

        } // for loop
        return frame_ptr;

    }; // functor
}; // class Sub_nm

#endif // __F_and_Ft_for_nm_H 