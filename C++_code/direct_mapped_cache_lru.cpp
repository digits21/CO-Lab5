#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#define n_way 8

using namespace std;

struct cache_content{
	bool v;
	unsigned int  tag[n_way];
	unsigned int    a[n_way];
//	unsigned int	data[16];
};

const int K=1024;

double log2( double n )
{
    // log(n)/log(2) is log2.
    return log( n ) / log(double(2));
}


void simulate(int cache_size, int block_size){
	unsigned int tag,index,x;

	int miss=0,all=0;
	int flag=0,min=0,now=0,count=0;
	int offset_bit = (int) log2(block_size);
	int index_bit = (int) log2(cache_size/(block_size*n_way));
	int line= (cache_size>>(offset_bit))/n_way;     //

	cache_content *cache =new cache_content[line];


	for(int j=0;j<line;j++)
		cache[j].v=false;

    for(int i=0;i<line;i++)
    {
        for(int j=0;j<n_way;j++)cache[i].a[j]=0;
    }

    FILE * fp=fopen("RADIX.txt","r");					//read file
    //FILE * fp=fopen("LU.txt","r");					//read file

	while(fscanf(fp,"%x",&x)!=EOF){
	    count++;
	    flag=0; //hit or not
		//cout<<hex<<x<<" ";
		index=(x>>offset_bit)&(line-1);
		tag=x>>(index_bit+offset_bit);


		//if(cache[index].v && cache[index].tag==tag)
		if(cache[index].v)  //hit
		{
			for(int i=0;i<n_way;i++)
			{
			    if(cache[index].tag[i]==tag)
			    {
			        //cout<<"hit"<<endl;
			        //system("PAUSE");
			        //cache[index].v=true;
			        cache[index].a[i]=count;
			        all=all+1;
                    flag = 1;
                    break;
			    }
			}
		}

		/*else{
			cache[index].v=true;			//miss
			cache[index].tag=tag;
		}*/
		if(flag==0)
		{
		    //cout<<"miss"<<endl;
            //system("PAUSE");
		    min=count;
		    now=0;
		    for(int i=0; i<n_way; i++)
		    {
		        if(cache[index].a[i]<min)
		        {
		            min=cache[index].a[i];
		            now = i;
		        }
            }
            cache[index].tag[now] = tag;
            cache[index].a[now] = count;
            cache[index].v=true;
            all++;
			miss++;
		}

	}
	fclose(fp);
	//cout<<"cache size = "<<cache_size<<endl;
	//cout<<"block size = "<<block_size<<endl;
	//cout<<"miss"<<miss<<endl;
    //cout<<"total"<<all<<endl;
    cout<<"miss rate="<<(float)miss*100/all<<"%"<<endl;
    //system("PAUSE");
	delete [] cache;
}

int main(){
	// Let us simulate 4KB cache with 16B blocks
	cout<<n_way<<"way"<<endl;
	cout<<"cache size=1K"<<endl;
	simulate(1*K, 32);
	cout<<"cache size=2K"<<endl;
	simulate(2*K, 32);
	cout<<"cache size=4K"<<endl;
	simulate(4*K, 32);
	cout<<"cache size=8K"<<endl;
	simulate(8*K, 32);
	cout<<"cache size=16K"<<endl;
	simulate(16*K, 32);
	cout<<"cache size=32K"<<endl;
	simulate(32*K, 32);

}
