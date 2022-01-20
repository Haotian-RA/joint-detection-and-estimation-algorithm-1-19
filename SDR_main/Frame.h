#ifndef __Frame_H
#define __Frame_H

#include <complex>
#include <vector>
#include <memory>

static const size_t frame_len=8192; // power of 2 is required and achieves better performance.

static const size_t num_of_sub_S=16; 
static const size_t max_dect=10; 
static const size_t num_of_sub_F_and_Ft=4; 

static const size_t size_of_symbol=64;
static const size_t oversampling_factor=4; 
static const size_t half_pulse_len=4;
static const size_t preamble_len=size_of_symbol*oversampling_factor+oversampling_factor*2*half_pulse_len; // size of preamble (tx)

static const size_t k=floor(preamble_len*2/3); // the freq offset is small thus optimal k (2*preamble_len/3) can be picked (may change if the freq offset is large)
static const float threshold=0.9; // pre-defined by looking at graph of rho in terms of received data 

//! @brief A struct type frame includes all the data flow that needs to be stored.
template<typename T,typename U>
struct Frame{

    //! @brief A state in vector stores received data.
    std::vector<T> rx;

    //! @brief A state stores frame's tag.
    size_t tag;

    //! @brief A state in vector stores norm of received data.
    //!
    //! Norm is calculated by shift register in the size of preamble length (preamble_len).
    //! 
    //! Zeros are added in the shift register at the beginning for calculating the norm of first (preamble_len-1) received data.
    std::vector<T> norm_rx;

    //! @brief A state in vector stores auto-correlation for each sample in rx with sample difference k.
    //!
    //! Shift register is included in the size of preamble length.
    //!
    //! Zeros are added in the shift register at the beginning for calculating the auto-correlation of first (preamble_len-1) received data with sample difference k.
    std::vector<T> crx_vector;

    //! @brief A state in vector stores some intermediate result for later calculation.
    std::vector<T> y;

    //! @brief A state in vector stores result of the SD estimator for frequency in size of frame length.
    //!
    //! One SD estimate correponds to one received data.
    //! 
    //! Note: the SD estimator should be calculated by vector in the size of preamble length. That is why zero padding is added for calculating the first (preamble_len-1) data.
    std::vector<U> delta_sd;

    //! @brief A state in matrix stores some intermediate result for later calculation.
    std::vector<std::vector<T>> sub_ctxrx=std::vector<std::vector<T>>(num_of_sub_S);
    
    //! @brief A state in vector stores the result of the numerator of phasor for the SD estimator in size of frame length. 
    //!
    //! one SD estimate correponds to one received data.
    std::vector<T> S=std::vector<T>(frame_len);

    //! @brief A state in vector stores the result of general correlation coefficient (rho) for comparing with the threshold to make decision of detection.
    //!
    //! one rho correponds to one received data.
    std::vector<U> rho;

    //! @brief A state in vector stores the result of detection (the position of preamble) in each frame.
    std::vector<size_t> p_preamble;

    //! @brief A state in matrix stores the preamble in the frame in each row by the detected position.
    //!
    //! Note: assume the maximum number of detections in each frame is known (and pre-defined by max_dect).  
    std::vector<std::vector<T>> rx_dect=std::vector<std::vector<T>>(max_dect);
    
    //! @brief A state in vector stores some intermediate result for later calculation.
    std::vector<std::vector<T>> sub_F=std::vector<std::vector<T>>(num_of_sub_F_and_Ft);

    //! @brief A state in vector stores some intermediate result for later calculation.
    std::vector<std::vector<T>> sub_Ft=std::vector<std::vector<T>>(num_of_sub_F_and_Ft);
};

#endif // __Frame_H 