#ifndef __Norm_rx_H
#define __Norm_rx_H

#include <vector>
#include "Frame.h"

//! @brief Compute norm of received data in frame. 
template<typename T,typename U> 
class Norm_rx{

    private:

        //! @brief shift register for shifting norm of received data.
        std::vector<T> _norm_rx_shift_reg;

        //! @brief a state stores current norm of received data.
        T _norm_rx;

    public:

        //! @brief A constructor that initializes the size of shift register for norm of received data.
        Norm_rx(size_t preamble_len){

            _norm_rx_shift_reg=std::vector<T>(preamble_len);
        };

    //! @brief A functor computes norm of each sliding received data in frame by the window size of preamble via shift register. 
    //!
    //! @param frame_ptr includes received data in size of frame length.
    //! @return The same shared pointer pointing to the frame that stores a norm vector of each sliding received data.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        std::vector<T> norm_rx;

        for (size_t i=0;i<frame_ptr->rx.size();i++){

            T v_norm_rx=frame_ptr->rx[i]*std::conj(frame_ptr->rx[i]); // calculate mag square of current index of sample in rx

            _norm_rx=_norm_rx+v_norm_rx-_norm_rx_shift_reg.front(); // norm of rx is equal to adding the newest mag square of sample of rx and minus the oldest (leftmost) in norm_rx shift register. 

            frame_ptr->norm_rx.push_back(_norm_rx); // store norm of rx in frame (frame_ptr)

            memmove(&_norm_rx_shift_reg.front(),&_norm_rx_shift_reg.front()+1,(_norm_rx_shift_reg.size()-1)*sizeof(T));  // shift register for norm_rx
            _norm_rx_shift_reg.back()=v_norm_rx;

        } // for loop

        return frame_ptr;

    }; // functor
}; // class Norm_rx

#endif // __Norm_rx_H 