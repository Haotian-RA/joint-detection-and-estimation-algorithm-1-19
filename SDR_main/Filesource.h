#ifndef __Filesource_H
#define __Filesource_H

#include <cstdio>
#include <vector>

//! @brief read a stream of samples from a file
template<typename T>
class FileSource{

    private:

        //! @brief a variable stores the name of file that samples will be read from.
            const char* _fn;

        //! @brief the corresponding file variable. 
        std::FILE* _fp;

    public:

        //! @brief a constructor copies the name of file that samples will be read from.
        FileSource(const char* filename) : _fn{filename}{
            
            _fp = std::fopen(_fn, "rb");

            if(!_fp){
                throw std::invalid_argument( "unable to open file" );
            }
        };

        //! @brief a destructor closes the file.
        ~FileSource(){
            std::fclose(_fp);
        }

    //! @brief a operator reads 'count' data from file into a vector; return actual number of elements read.
    std::vector<T> operator()(const std::size_t count){

        std::vector<T> v(count);
        std::size_t n_read = std::fread(v.data(),sizeof(v[0]),count,_fp);
        v.resize(n_read);

        return v;
    }

};

#endif // __Filesource_H 