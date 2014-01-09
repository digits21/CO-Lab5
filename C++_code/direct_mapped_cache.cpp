#include <iostream>
#include <stdio.h>
#include <math.h>

struct cache_content{
    bool v;
    unsigned int  tag;
    //unsigned int    data[16];
};


double log2( double n )
{  
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}

/*
int log2 (int n) {
    int m = 0;
    while (n >>= 1) ++m;
    return m;
}
*/


void simulate(int cache_size, int block_size){
    unsigned int tag,index,x;

    int offset_bit = (int) log2(block_size);
    int index_bit  = (int) log2(cache_size / block_size);
    int line       = cache_size >> (offset_bit);

    int n_of_access = 0, n_of_miss = 0;

    cache_content *cache = new cache_content[line];
    std::cout << "cache line:" << line << std::endl;
    std::cout << "cache size:" << cache_size << std::endl;
    std::cout << "block size:" << block_size << std::endl;

    for(int j=0;j<line;j++)
        cache[j].v=false;

    //FILE * fp = std::fopen("ICACHE.txt","r");
    FILE * fp = std::fopen("DCACHE.txt","r");
    
    if (!fp) {
        std::cerr << "test file open error!" << std::endl;
    }

    while(std::fscanf(fp, "%x", &x) != EOF){
        n_of_access++;
        //std::cout << std::hex << x << " ";
        
        index = (x >> offset_bit) & (line-1);
        tag   = x >> (index_bit+offset_bit);

        if(cache[index].v && cache[index].tag == tag){
            cache[index].v = true;             //hit
        }
        else{                        
            n_of_miss++;
            cache[index].v = true;            //miss
            cache[index].tag = tag;
        }
    }
    std::fclose(fp);

    delete [] cache;

    std::cout << "miss rate:" << (n_of_miss/(double)n_of_access) << std::endl;
    std::cout << "===========" << std::endl;
}

int main(){

    simulate( 64, 4);
    simulate(128, 4);
    simulate(256, 4);
    simulate(512, 4);

    simulate( 64, 8);
    simulate(128, 8);
    simulate(256, 8);
    simulate(512, 8);

    simulate( 64, 16);
    simulate(128, 16);
    simulate(256, 16);
    simulate(512, 16);

    simulate( 64, 32);
    simulate(128, 32);
    simulate(256, 32);
    simulate(512, 32);

    return 0;
}
