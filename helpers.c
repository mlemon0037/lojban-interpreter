#include "helpers.h"
#include <stdio.h>
#include <string.h>

int convert(const char* s) {
	// https://en.wikibooks.org/wiki/Lojban/Numbers

	// if we get here, the string is valid lojban #, so no checking
	// string must also be even length

	// lojban numbers follow
	// 0=no
    // 1=pa
    // 2=re
    // 3=ci
    // 4=vo
    // 5=mu
    // 6=xa
    // 7=ze
    // 8=bi
    // 9=so

	// lojban numbers get larger by just adding more

	float sum = 0;
	int len = strlen(s);
	const char *ptr = s+len-2;
	int place_value = 0;

	while (s <= ptr) {
		switch (*ptr) {
			case 'n': {
				sum += 0*pow(10, place_value++); //add 
				break;
			}
			case 'p': {
				sum += 1*pow(10, place_value++); //add 
				break;
			}
			case 'r': {
				sum += 2*pow(10, place_value++); //add 
				break;
			}
			case 'c': {
				sum += 3*pow(10, place_value++); //add 
				break;
			}
			case 'v': {
				sum += 4*pow(10, place_value++); //add 
				break;
			}
			case 'm': {
				sum += 5*pow(10, place_value++); //add 
				break;
			}
			case 'x': {
				sum += 6*pow(10, place_value++); //add 
				break;
			}
			case 'z': {
				sum += 7*pow(10, place_value++); //add 
				break;
			}
			case 'b': {
				sum += 8*pow(10, place_value++); //add 
				break;
			}
			case 's': {
				sum += 9*pow(10, place_value++); //add 
				break;
			}	
		}
		ptr -= 2*sizeof(char);
	}
	return sum;
}