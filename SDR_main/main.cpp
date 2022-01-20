#include "Burst_mode_transmission_impl.h" // include all header files.

using T_preamble=std::complex<float>; // type of received data: complex float 32.
using T_sync=float; // type of synchronization result: float 32.

using Frame_ptr=std::shared_ptr<Frame<T_preamble,T_sync>>;
using Result_ptr=std::shared_ptr<Result<T_preamble,T_sync>>;

static const float pi = std::acos(-1.0);

/* compile:
   g++ -std=c++17 main.cpp -I$TBB_INCLUDE -Wl,-rpath,$TBB_LIBRARY_RELEASE -L$TBB_LIBRARY_RELEASE -ltbb -I$HOME/fftw3/include -L$HOME/fftw3/lib -lfftw3 -I$HOME/libzmq/include -lzmq -O3 -o main
*/

int main(){

    // read preamble 
    auto tx_data = FileSource<T_preamble>("tx_samples64_M4_L4.dat");
    std::vector<T_preamble> tx = tx_data(preamble_len);

    // TBB initialization
    size_t frame_num=0;
    Buffer<T_preamble,T_sync> buffer{frame_len};
    tbb::flow::graph g;
    // std::vector<size_t> p_preamble_con;

    // *** zmq: construct a pull socket and connect to interface ***
    // zmq::context_t context{1};
    // zmq::socket_t socket{context, zmq::socket_type::pull};
    // socket.connect("tcp://127.0.0.1:20001"); // local network, gateway is 20001.
    // zmq::message_t pul{};   

    // *** TBB blocks. Received frame should be processed in order thus all concurrency policy is serial. ***
    // tbb::flow::source_node<Frame_ptr> my_src(g, // source node receives data from local network via zmq and outputs pointer of frame
    // [&](Frame_ptr &frame_ptr)->bool{

    //     while (true){ // source node run forever
    //         socket.recv(pul,zmq::recv_flags::none); // receive data from socket
    //         std::vector<T_preamble> rec((T_preamble*)pul.data(),(T_preamble*)pul.data()+pul.size()/sizeof(T_preamble)); // store received data in vector. Note: received data is not size-fixed.
    //         Frame<T_preamble,T_sync> frame = buffer(frame_num,rec); // stream received data into buffer and output frame (struct) including received data.
    //         if (frame.rx.size()==frame_len){ // frame will be send out to next function node only if the received data in frame is 8192.
    //             frame_ptr=std::make_shared<Frame<T_preamble,T_sync>>(frame); // make output frame be a pointer for reducing the huge copy assignment of each function node in TBB.
    //             frame_num++; // frame number will increase by 1 if it sends out.
    //             return true;
    //         }
    //     }},false);

    // *** an alternative source node if you want to read test (received) data from file. ***
    // read received data from file for testing throughput.
    size_t n_frame_max=2000;
    std::chrono::time_point<std::chrono::system_clock> m_StartTime,m_EndTime;
    auto rx_data = FileSource<T_preamble>("usrp_samples64_M4_L4.dat");
    std::vector<T_preamble> rx = rx_data(frame_len*n_frame_max);
    std::vector<T_preamble> rec;
    m_StartTime = std::chrono::system_clock::now();

    tbb::flow::source_node<Frame_ptr> my_src(g,
    [&](Frame_ptr &frame_ptr)->bool{
        if (frame_num<n_frame_max){
            Frame<T_preamble,T_sync> frame;
            frame.tag=frame_num;
            std::copy(rx.begin()+frame_num*frame_len,rx.begin()+(frame_num+1)*frame_len,back_inserter(frame.rx));
            frame_ptr=std::make_shared<Frame<T_preamble,T_sync>>(frame); // make output frame be a pointer for reducing the huge copy assignment of each function node in TBB.
            frame_num++;
        return true;}else{return false;}},false);

    // the SD estimator for frequency
    tbb::flow::function_node<Frame_ptr,Frame_ptr> norm_rx(g,tbb::flow::serial,Norm_rx<T_preamble,T_sync>{preamble_len}); // norm of rx. 
    tbb::flow::function_node<Frame_ptr,Frame_ptr> crx_vector(g,tbb::flow::serial,Crx_vector<T_preamble,T_sync>{k}); // r_{m-k}r*_m. 
    tbb::flow::function_node<Frame_ptr,Frame_ptr> innerp_ctxcrx(g,tbb::flow::serial,Innerp_ctxcrx<T_preamble,T_sync>{tx,preamble_len,k,frame_len}); // sum_{m=k}{N-1}(r_{m-k}r*_ms*_{m-k}s_m). 
    tbb::flow::function_node<Frame_ptr,Frame_ptr> delta_sd(g,tbb::flow::serial,Delta_sd<T_preamble,T_sync>{k}); // delta_sd=arg{sum_{m=k}{N-1}(r_{m-k}r*_ms*_{m-k}s_m)}/(2*pi*k).

    // the SD estimator for (numerator of) phasor (approximation). Step I: calculate the correlation between tx and rx by seperating tx into 16 subvector to reduce computation in each node and thus increasing throughput by pipeline.
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx1(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,1,tx,frame_len}); // sum_{n=0}{N/16-1}(r_ns*_n).
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx2(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,2,tx,frame_len}); // sum_{n=2N/16}{3N/16-1}(r_ns*_n).
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx3(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,3,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx4(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,4,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx5(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,5,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx6(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,6,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx7(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,7,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx8(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,8,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx9(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,9,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx10(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,10,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx11(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,11,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx12(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,12,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx13(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,13,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx14(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,14,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx15(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,15,tx,frame_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_ctxrx16(g,tbb::flow::serial,Ctxrx_vector<T_preamble,T_sync>{num_of_sub_S,16,tx,frame_len}); // ...

    // the SD estimator for (numerator of) phasor (approximation). Step II: add above every two summations instread of all for the same reason as above.
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum1(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{1,num_of_sub_S,preamble_len}); // sum_{n=0}{N/16-1}(r_ns*_n)e^{-j2*pi*delta_sd*N/32}+sum_{n=N/16}{2N/16-1}(r_ns*_n)e^{-j2*pi*delta_sd*2N/32}.
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum2(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{2,num_of_sub_S,preamble_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum3(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{3,num_of_sub_S,preamble_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum4(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{4,num_of_sub_S,preamble_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum5(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{5,num_of_sub_S,preamble_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum6(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{6,num_of_sub_S,preamble_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum7(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{7,num_of_sub_S,preamble_len}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_s_sum8(g,tbb::flow::serial,Phasor_sd<T_preamble,T_sync>{8,num_of_sub_S,preamble_len}); // numerator of phasor_sd (denoted as S) is approximately equal to the summation of the above 8 sub-summation. 
 
    // general correlation coefficient rho.
    tbb::flow::function_node<Frame_ptr,Frame_ptr> rho(g,tbb::flow::serial,Rho<T_preamble,T_sync>{tx}); // rho = numerator of phasor_sd/(norm(rx)norm(tx))
    tbb::flow::function_node<Frame_ptr,Frame_ptr> dect(g,tbb::flow::serial,Dect<T_preamble,T_sync>{threshold,oversampling_factor,preamble_len}); // detect the position of preamble in each frame if the peak of rho > threshold.

    // the NM estimator. Step I: calculate part of two factors F and Ft (delta_nm=delta_sd-F/Ft) by seperating detected preamble and tx to increase throughput.
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_f_and_ft1(g,tbb::flow::serial,F_and_Ft<T_preamble,T_sync>{num_of_sub_F_and_Ft,1,preamble_len,tx}); // F=sum_{k=0}{N/4-1}sum_{m=k}{N-1}(kr_{m-k}r*_ms*_{m-k}s_me^{j2*pi*delta_sd*k}),Ft is similar to F but with multiplier J*2*pi*k^2
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_f_and_ft2(g,tbb::flow::serial,F_and_Ft<T_preamble,T_sync>{num_of_sub_F_and_Ft,2,preamble_len,tx}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_f_and_ft3(g,tbb::flow::serial,F_and_Ft<T_preamble,T_sync>{num_of_sub_F_and_Ft,3,preamble_len,tx}); // ...
    tbb::flow::function_node<Frame_ptr,Frame_ptr> sub_f_and_ft4(g,tbb::flow::serial,F_and_Ft<T_preamble,T_sync>{num_of_sub_F_and_Ft,4,preamble_len,tx}); // ...

     // the NM estimator. Step II: add 4 above four summations for F and Ft. Calculate delta_nm and phasor_nm.
    tbb::flow::function_node<Frame_ptr,Result_ptr> nm_est(g,tbb::flow::serial,Nm_est<T_preamble,T_sync>{tx});

    // print out the results.
    tbb::flow::function_node<Result_ptr> print_node(g,tbb::flow::serial,[&](Result_ptr result_ptr){

        for (size_t i=0;i<result_ptr->_p_preamble.size();i++){

            // p_preamble_con.push_back((result_ptr->_p_preamble[i]+result_ptr->tag*frame_len));
            std::cout<<"frame number: "<<result_ptr->tag<<std::endl;
            std::cout<<"preamble is detected at index: "<<result_ptr->_p_preamble[i]<<std::endl;
            std::cout<<"freq offset: "<<result_ptr->_delta_nm[i]<<std::endl;
            std::cout<<"phase offset: "<<std::arg(result_ptr->_phasor_nm[i])*180/pi<<std::endl;
            std::cout<<"ampl offset: "<<std::abs(result_ptr->_phasor_nm[i])<<std::endl;
        }

        // char filename[] = "p_preamble_container.dat";
        // {
        //     auto Sink = FileSink<size_t>(filename);
        //     auto n = Sink(p_preamble_con);
        // }
    });
    
    // connect each node. There is only one path for all nodes (all nodes are serial).
    tbb::flow::make_edge(my_src,norm_rx);
    tbb::flow::make_edge(norm_rx,crx_vector);
    tbb::flow::make_edge(crx_vector,innerp_ctxcrx);
    tbb::flow::make_edge(innerp_ctxcrx,delta_sd);

    tbb::flow::make_edge(delta_sd,sub_ctxrx1);
    tbb::flow::make_edge(sub_ctxrx1,sub_ctxrx2);
    tbb::flow::make_edge(sub_ctxrx2,sub_ctxrx3);
    tbb::flow::make_edge(sub_ctxrx3,sub_ctxrx4);
    tbb::flow::make_edge(sub_ctxrx4,sub_ctxrx5);
    tbb::flow::make_edge(sub_ctxrx5,sub_ctxrx6);
    tbb::flow::make_edge(sub_ctxrx6,sub_ctxrx7);
    tbb::flow::make_edge(sub_ctxrx7,sub_ctxrx8);
    tbb::flow::make_edge(sub_ctxrx8,sub_ctxrx9);
    tbb::flow::make_edge(sub_ctxrx9,sub_ctxrx10);
    tbb::flow::make_edge(sub_ctxrx10,sub_ctxrx11);
    tbb::flow::make_edge(sub_ctxrx11,sub_ctxrx12);
    tbb::flow::make_edge(sub_ctxrx12,sub_ctxrx13);
    tbb::flow::make_edge(sub_ctxrx13,sub_ctxrx14);
    tbb::flow::make_edge(sub_ctxrx14,sub_ctxrx15);
    tbb::flow::make_edge(sub_ctxrx15,sub_ctxrx16);

    tbb::flow::make_edge(sub_ctxrx16,sub_s_sum1);
    tbb::flow::make_edge(sub_s_sum1,sub_s_sum2);
    tbb::flow::make_edge(sub_s_sum2,sub_s_sum3);
    tbb::flow::make_edge(sub_s_sum3,sub_s_sum4);
    tbb::flow::make_edge(sub_s_sum4,sub_s_sum5);
    tbb::flow::make_edge(sub_s_sum5,sub_s_sum6);
    tbb::flow::make_edge(sub_s_sum6,sub_s_sum7);
    tbb::flow::make_edge(sub_s_sum7,sub_s_sum8);

    tbb::flow::make_edge(sub_s_sum8,rho);
    tbb::flow::make_edge(rho,dect);

    tbb::flow::make_edge(dect,sub_f_and_ft1);
    tbb::flow::make_edge(sub_f_and_ft1,sub_f_and_ft2);
    tbb::flow::make_edge(sub_f_and_ft2,sub_f_and_ft3);
    tbb::flow::make_edge(sub_f_and_ft3,sub_f_and_ft4);
    tbb::flow::make_edge(sub_f_and_ft4,nm_est);

    tbb::flow::make_edge(nm_est,print_node);

    my_src.activate();
    g.wait_for_all();

    m_EndTime = std::chrono::system_clock::now();
    std::cout<<std::chrono::duration_cast<std::chrono::milliseconds>(m_EndTime-m_StartTime).count()<<std::endl;
    std::cout<<std::chrono::duration_cast<std::chrono::seconds>(m_EndTime-m_StartTime).count()<<std::endl;

    return 0;
}
