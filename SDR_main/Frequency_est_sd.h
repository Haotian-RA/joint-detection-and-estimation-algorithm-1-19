#ifndef __Frequency_est_sd_H
#define __Frequency_est_sd_H

#include <cmath>
#include "Frame.h"

//! @brief A sample class that computes the SD estimator for frequency estimate.
template<typename T,typename U> 
class Delta_sd{

    private:

        //! @brief a state stores the pre-defined sample difference.
        const size_t k;
        
    public:

        //! @brief A constructor that initializes the pre-defined sample difference.
        Delta_sd(size_t factor_k):k(factor_k){};

    //! @brief A functor computes the SD estimator for frequency estimate.
    //!
    //! @param frame_ptr includes the cross-correlation result between received data and the preamble.
    //! @return The same shared pointer pointing to the frame that stores a vector of the SD estimator in size of frame length.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        static const float pi = std::acos(-1.0);

        for (size_t i=0;i<frame_ptr->y.size();i++)
            frame_ptr->delta_sd.push_back(-std::arg(frame_ptr->y[i])/(2*pi*k)); // delta_sd=arg{y}/(2*pi*k).

        return frame_ptr;

    }; // functor
}; // class Delta_sd

#endif // __Frequency_est_sd_H 