#ifndef __Ctxrx_vector_H
#define __Ctxrx_vector_H

#include <vector>
#include "Frame.h"

//! @brief Compute cross-correlation between received data in frame and the preamble. 
//!
//! This class can increase the throughput of pipeline by computing sub cross-correlation with part of the preamble.
template<typename T,typename U> 
class Ctxrx_vector{

    private:

        //! @brief shift register for shifting received data in frame.
        std::vector<T> _rx_shift_reg;

        //! @brief a state stores the number of sub computation of cross-correlation.
        size_t _nth_sub;

        //! @brief a buffer stores received data in different size determined by the number of sub computation.
        std::vector<T> rx_buffer;

        //! @brief a state stores the preamble.
        std::vector<T> _tx;

        //! @brief a state stores the frame length.
        size_t frame_len;
                    
    public:

        //! @brief A constructor that initializes some variables for sub computation.
        Ctxrx_vector(size_t n_sub,size_t nth_sub,std::vector<T> tx,size_t frame_length):frame_len(frame_length),_nth_sub(nth_sub){

            _rx_shift_reg=std::vector<T>(tx.size()/n_sub); // determine size of rx shift register that is equal to the length of subvector of tx.

            std::copy(tx.begin()+(size_t)((float)(nth_sub-1)/n_sub*tx.size()),tx.begin()+(size_t)((float)nth_sub/n_sub*tx.size()),back_inserter(_tx)); // extract corresponding part of tx

            rx_buffer=std::vector<T>(size_t((1-(float)nth_sub/n_sub)*tx.size())); // determine size of rx buffer that is equal to (1-nth node)*tx_size, e.g., for the second node, (1-2/16)*tx_size.
        }

    //! @brief A functor computes cross-correlation between received data in frame and (part of) the preamble. 
    //!
    //! @param frame_ptr includes the received data in size of frame length.
    //! @return The same shared pointer pointing to the frame that stores a vector of the (sub) cross-correlation result in size of frame length.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        // adjust data in rx by concatenate buffer data ahead and overwrite extra data (more than frame length) in buffer    
        std::vector<T> rx=frame_ptr->rx;
        rx.insert(rx.begin(),rx_buffer.begin(),rx_buffer.end());
        for (size_t i=0;i<rx_buffer.size();i++)
            rx_buffer[i]=rx[i+frame_len];
            
        for (size_t i=0;i<frame_len;i++){

            memmove(&_rx_shift_reg.front(),&_rx_shift_reg.front()+1,(_tx.size()-1)*sizeof(T));  // shift register for rx in size of subvector of tx
            _rx_shift_reg.back()=rx[i];

            T ctxrx;
            for (size_t j=0;j<_tx.size();j++)
                ctxrx+=_rx_shift_reg[j]*std::conj(_tx[j]); // correlation of r_ns*_n in subvector tx.

            frame_ptr->sub_ctxrx[_nth_sub-1].push_back(ctxrx); // store result of current subvector tx in each row of matrix correlation r_ns*_n
        };
        
        return frame_ptr;
        
    }; // functor
}; // class Ctxrx_vector

#endif // __Ctxrx_vector_H 