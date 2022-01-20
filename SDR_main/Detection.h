/* 
Detect the position of preamble and store the corresponding rx in frame.
*/

#ifndef __Detection_H
#define __Detection_H

#include "Frame.h"

//! @brief Detect the position of preamble in frame.
template<typename T,typename U> 
class Dect{

    private:

        //! @brief a state stores the general correlation coefficient for comparing.
        U _rho;

        //! @brief a flag controls the mode of detection
        //!
        //! _pre_dec is true if the first rho is greater than threshold in a period (it doesn't mean the position of preamble).
        bool _pre_dec=false;

        //! @brief oversampling factor.
        size_t os_factor;

        //! @brief a state stores the position of preamble that is detected.
        int _p_preamble=-100; // this initial position of preamble can be arbitrary less than negative one oversampling factor.

        //! @brief threshold.
        float thres;

        //! @brief a variable stores the received data.
        std::vector<T> _rec;

        //! @brief length of preamble
        size_t pream_len;

    public:

        //! @brief A constructor that initializes some variables for detection.
        Dect(float threshold,size_t oversampling_factor,size_t preamble_len):thres(threshold),os_factor(oversampling_factor),pream_len(preamble_len){};

    //! @brief A functor detects the position of preamble.
    //!
    //! @param frame_ptr includes general correlation coefficients in size of frame (one index maps to one coefficient).
    //! @return The same shared pointer pointing to the frame that stores a vector of position of the preamble and a matrix of corresponding received data vector.
    inline std::shared_ptr<Frame<T,U>> operator()(std::shared_ptr<Frame<T,U>> frame_ptr){

        // detection
        for (size_t i=0;i<frame_ptr->rho.size();i++){

            if ((frame_ptr->rho[i]>=thres)&&(_pre_dec==false)){ // pre-detection. The flag named _pre_dec becomes true when first rho is greater than threshold.

                _rho=frame_ptr->rho[i]; // store current rho into state _rho
                _pre_dec=true; 
            }

            if (_pre_dec==true){ // further judgement. Only happens when pre-detection is on.

                if (frame_ptr->rho[i]>=_rho) // condition 1: if current rho is greater than or equal to state _rho
                    _rho=frame_ptr->rho[i]; // overwrite state _rho by current rho
                else if (i-1-_p_preamble<os_factor) // condition 2: distance between two detections less than or equal to one oversampling factor.
                    _pre_dec=false; // pre-detection should turn off.
                else{ // real detection
                    frame_ptr->p_preamble.push_back(i-1); // store position of preamble in frame
                    _p_preamble=i-1; // overwrite position of preamble in state _p_preamble
                    _pre_dec=false;
                }
            }

        } // for loop
        _p_preamble-=frame_ptr->rho.size(); // re-initialize the state.

        // store the corresponding rx in frame.
        size_t count=0;
        for (size_t i:frame_ptr->p_preamble){
            
            if (i<pream_len){ // if index is less than the length of preamble, it means the preamble is cut off.

                _rec.insert( _rec.end(),frame_ptr->rx.begin(),frame_ptr->rx.end()); // concatenate state(previous) _rec and current rec for copying an entire detected preamble in frame. 
                std::copy(_rec.begin()+i+frame_ptr->rx.size()-pream_len+1,_rec.begin()+i+frame_ptr->rx.size()+1,back_inserter(frame_ptr->rx_dect[count])); // copy every preamble into one row of matrix rx_dect in frame (no limit to only one detection)
                _rec.clear(); 
            }else
                std::copy(frame_ptr->rx.begin()+i-pream_len+1,frame_ptr->rx.begin()+i+1,back_inserter(frame_ptr->rx_dect[count])); // directly copy if no cut off on preamble.
            count++;

        } // for loop
        _rec=frame_ptr->rx; // store current frame in state _rec at the end of functor for detection of next frame.

        return frame_ptr;

    }; // functor
}; // class Dect

#endif // __Detection_H 