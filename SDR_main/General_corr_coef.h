#ifndef __General_corr_coef_H
#define __General_corr_coef_H

#include <vector>
#include "Frame.h"

//! @brief A sample class that computes the general correlation coefficient for later detection.
template<typename T,typename U> 
class Rho{

    private:

        //! @brief a state stores norm of the preamble.
        T _norm_tx;

    public:

        //! @brief A constructor computes norm of the preamble.
        Rho(std::vector<T> tx){

            for (size_t i=0;i<tx.size();i++)
                _norm_tx+=tx[i]*std::conj(tx[i]); // norm of tx.
        }; 

    //! @brief A functor computes the general correlation coefficient (rho).
    //!
    //! @param frame_ptr includes the approximate numerator of phasor in size of frame length.
    //! @return The same shared pointer pointing to the frame that stores a vector of the general correlation coefficient result.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        for (size_t i=0;i<frame_ptr->S.size();i++)
            frame_ptr->rho.push_back((abs(frame_ptr->S[i])/(std::sqrt(frame_ptr->norm_rx[i])*std::sqrt(_norm_tx))).real()); // rho is simplified as |S|/(||tx||||rx||). 
        
        return frame_ptr;

    }; // functor
}; // class Rho

#endif // __General_corr_coef_H 