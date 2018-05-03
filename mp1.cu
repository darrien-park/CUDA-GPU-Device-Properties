//Darrien Park

#include "cuda_runtime.h"
#include <string.h>
#include <stdio.h>

//no field in cudaDeviceProperties for number of cores. Therefore need to determine based on compute capability
int getCores(cudaDeviceProp dev_prop)
{
	int cores = 0;
	int sm = dev_prop.multiProcessorCount;

	//start switch case based on major compute capability
	switch (dev_prop.major){
		//Fermi
		case 2:
			if (dev_prop.minor == 1)
				cores = sm * 48;
			else cores = sm * 32;
				break;
		//Kepler
		case 3:
			cores = sm * 192;
				break;
		//Maxwell
		case 5:
			cores = sm * 128;
				break;
		//Pascal
		case 6:
			if (dev_prop.minor == 1)
				cores = sm * 128;
			else if (dev_prop.minor == 0)
				cores = sm * 64;
			else printf("Unknown device type \n");
				break;
		//Volta
		case 7:
			if (dev_prop.minor == 0)
				cores = sm * 64;
			else printf("Unknown device type \n");
				break;
		//base case: can't be detected
		default:
			printf("Unknown device type \n");
				break;
	}
	return cores;
}

int main(int argc, char * argv[])
{

	int dev_count;
	cudaGetDeviceCount(& dev_count);
	printf("Number of CUDA devices is [%d]\n\n",dev_count);

	for(int i = 0; i < dev_count; i++){
		int k = i+1;
		printf("Device [%d]\n", k);

		cudaDeviceProp dev_props;

		cudaGetDeviceProperties(&dev_props, 0);						//cudaGetDeviceProperties(cudaDeviceProp* prop, int device#)
		printf("	Device Name: %s\n",dev_props.name);
		printf("	Memory Clock Rate (KHz): %d\n",dev_props.memoryClockRate);
		printf("	Number of Streaming Multiprocessors: %d\n",dev_props.multiProcessorCount);
		printf("	Number of cores: %d\n",getCores(dev_props));
		printf("	Warp Size: %d\n",dev_props.warpSize);
		printf("	Total Global Memory: %d\n",dev_props.totalGlobalMem);
		printf("	Total Constant Memory: %d\n",dev_props.totalConstMem);
		printf("	Shared Memory/Block: %d\n",dev_props.sharedMemPerBlock);
		printf("	Number of Registers/Block: %d\n",dev_props.regsPerBlock);
		printf("	Number of Threads/Block: %d\n",dev_props.maxThreadsPerBlock);
		printf("	Max Block Dimension: %d\n",dev_props.maxThreadsDim);
		printf("	Max Grid Dimension: %d\n",dev_props.maxGridSize);
	}
	return 0;
}
