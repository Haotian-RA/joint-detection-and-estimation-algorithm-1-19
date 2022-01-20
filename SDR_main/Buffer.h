#ifndef __Buffer_H
#define __Buffer_H

#include <vector>
#include "Frame.h"

//! @brief Transform received data into frame of data.
template<typename T,typename U> 
class Buffer{

    private:

        //! @brief two states in vector that transform data
        std::vector<T> _in_buffer,_ou_buffer;

        //! @brief a state stores the length of frame.
        size_t frame_len;

    public:

        //! @brief A constructor that initializes a state storing the length of frame.
        Buffer(size_t frame_length):frame_len(frame_length){};

    //! @brief A functor buffers the received data into _in_buffer and stream data from _in_buffer to _ou_buffer.
    //!
    //! @param frame_num tag of frame that will be sent out.
    //! @param rec received data in vector.
    //! @return Frame that includes a state storing data from _ou_buffer. 
    //!
    //! Note: If _ou_buffer is not full size (size of pre-defined frame length), frame will be still returned but not sent out for processing. 
    inline Frame<T,U> operator()(size_t frame_num,std::vector<T> rec){

        _in_buffer.insert(_in_buffer.end(),rec.begin(),rec.end()); // buffer received data into _in_buffer
        
        Frame<T,U> frame;
        frame.tag=frame_num;

        while (!_in_buffer.empty()){ // stream data from _in_buffer to _ou_buffer unless condition 1: no data in _in_buffer

            _ou_buffer.push_back(_in_buffer.front()); 
            _in_buffer.erase(_in_buffer.begin());
            
            if (_ou_buffer.size()==frame_len){ // condition 2: size of _ou_buffer achieves pre-defined frame length. 
                frame.rx=_ou_buffer; // copy data from _ou_buffer into (rx of) frame for sending out 
                _ou_buffer.clear(); // empty _ou_buffer
                break;
            }

        } // while loop

        return frame;

    }; // functor
}; // class Buffer

#endif // __Buffer_H 