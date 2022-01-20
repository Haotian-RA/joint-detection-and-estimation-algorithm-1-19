#ifndef __Joint_estimator_nm_H
#define __Joint_estimator_nm_H

#include <vector>
#include <cmath>
#include <complex>
#include "Frame.h"
#include <memory>

//! @brief a class records the joint estimate of NM estimator, the position of preamble and corresponding tag of frame.
template<typename T,typename U>
struct Result{

    //! @brief a variable stores the frequency estimate of the NM estimator.
    std::vector<U> _delta_nm;

    //! @brief a variable stores the phase estimate (phasor) of the NM estimator.
    std::vector<T> _phasor_nm;

    //! @brief a variable stores the position of detected preamble.
    std::vector<size_t> _p_preamble;

    //! @brief a variable stores the tag of current frame.
    size_t tag;

}; 

//! @brief a sample class computes the joint estimate of the NM estimator.
template<typename T,typename U> 
class Nm_est{

    private:

        //! @brief a state stores the preamble.
        std::vector<T> _tx;

        // a variable stores norm of the preamble.
        T _norm_tx;

    public:

        //! @brief A constructor computes norm of the preamble.
        Nm_est(std::vector<T> tx):_tx(tx){

            for (size_t i=0;i<tx.size();i++)
                _norm_tx+=tx[i]*std::conj(tx[i]); // norm of tx.
        };

    //! @brief A functor computes the joint estimate of the NM estimator by two important factors (F and Ft).
    //!
    //! @param frame_ptr includes two vectors of two important factors F and Ft.
    //! @return A shared pointer pointing to a result (struct) that stores the joint estimate of NM estimator, the position of preamble and corresponding tag of frame.
    inline std::shared_ptr<Result<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        Result<T,U> result;
        result.tag=frame_ptr->tag;

        static const float pi = std::acos(-1.0);
        static const std::complex<float> J(0,1);
        size_t count=0;

        for (size_t i:frame_ptr->p_preamble){

            std::vector<T> rx=frame_ptr->rx_dect[count];

            T F,Ft;
            for (size_t i=0;i<frame_ptr->sub_F.size();i++){

                F+=frame_ptr->sub_F[i][count];
                Ft+=frame_ptr->sub_Ft[i][count];
            }

            U delta_nm=frame_ptr->delta_sd[i]-std::imag(F)/std::imag(Ft); // delta_nm = delta_sd-F/Ft

            T S;
            for (size_t n=0;n<rx.size();n++)
                S+=rx[n]*std::conj(_tx[n])*std::exp(J*(-2*pi*delta_nm*n)); // phasor_nm is calculated directly from definition: phasor_nm = sum_{n=0}{N-1}(r_ns*_n)e^{-j2*pi*delta_nm*n}

            count++;

            result._delta_nm.push_back(delta_nm);
            result._phasor_nm.push_back(S/_norm_tx);
            result._p_preamble.push_back(i);    

        } // for loop
        std::shared_ptr<Result<T,U>> result_ptr=std::make_shared<Result<T,U>>(result);

        return result_ptr;

    }; // functor
}; // class Nm_est

#endif // __Joint_estimator_nm_H 