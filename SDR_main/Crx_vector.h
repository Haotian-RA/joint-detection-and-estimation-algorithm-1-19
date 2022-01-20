#ifndef __Crx_vector_H
#define __Crx_vector_H

#include <vector>
#include "Frame.h"

//! @brief Compute auto-correlation of received data in frame. 
template<typename T,typename U> 
class Crx_vector{

    private:

        //! @brief shift register for shifting received data in frame.
        std::vector<T> _rx_shift_reg;

    public:

        //! @brief A constructor that initializes the size of shift register for received data.
        Crx_vector(size_t k){

            _rx_shift_reg=std::vector<T>(k+1);
        }; 

    //! @brief A functor computes auto-correlation for received data in frame with defined sample difference (k) via shift register.
    //!
    //! @param frame_ptr includes received data in size of frame length.
    //! @return The same shared pointer pointing to the frame that stores an auto-correlation vector of each sliding received data.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        for (size_t i=0;i<frame_ptr->rx.size();i++){

            memmove(&_rx_shift_reg.front(),&_rx_shift_reg.front()+1,(_rx_shift_reg.size()-1)*sizeof(T));  // shift register for received data
            _rx_shift_reg.back()=frame_ptr->rx[i];

            frame_ptr->crx_vector.push_back(_rx_shift_reg.front()*std::conj(_rx_shift_reg.back())); // r_{m-k}r*_m

        } // for loop

        return frame_ptr;

    }; // functor
}; // class Crx_vector

#endif // __Crx_vector_H 