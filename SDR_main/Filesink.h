#ifndef __Filesink_H
#define __Filesink_H

#include <cstdio>
#include <vector>

//! @brief write a stream of samples to file.
template<typename T>
class FileSink{

    private:

        //! @brief a variable stores the name of file that will be written in.
        const char* _fn;

        //! @brief the corresponding file variable. 
        std::FILE* _fp;

    public:

        //! @brief a constructor copies the name of file that will be written in
        FileSink(const char* filename) : _fn{filename}{

            _fp = std::fopen(_fn, "wb");
            if(!_fp){
                throw std::invalid_argument( "unable to open file" );
            }
        };

        //! @brief a destructor closes the file.
        ~FileSink(){
            std::fclose(_fp);
        }

    //! @brief a functor writes vector to file; return number of elements written.
    std::size_t operator()(const std::vector<T> v){

        return std::fwrite(v.data(),sizeof(v[0]),v.size(),_fp);
    }

};

#endif // __Filesink_H 