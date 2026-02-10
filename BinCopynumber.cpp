#include <unistd.h>
#include <ios>

#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <bitset>
#include <time.h>
#include <sys/resource.h>
#include <stack>
#include <ctime>
#include "/home/afarrell/bin/fastahack/Fasta.h"
#include <fcntl.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <errno.h>

const vector<string> Split(const string& line, const char delim) {
    vector<string> tokens;
    stringstream lineStream(line);
    string token;
    while ( getline(lineStream, token, delim) )
        tokens.push_back(token);
    return tokens;
}

int main(int argc, char *argv[])
{
        int BinSize = atoi(argv[1]);

        string chro = "STArT";
        int counter = 0;
        int sum = 0;
        int localC = 0;
        string line;
        ifstream SamFile;

        SamFile.open ("/dev/stdin");
        while (getline(SamFile, line))
        {
                vector <string> temp = Split(line, '\t');
                if (chro != temp[0])
                {
                        int pos = atoi(temp[1].c_str());
                        if (chro != "STArT")
                        {
                                if (localC ==0)
                                        cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<0 << "\t" << 0 << endl;
                                else
                                        cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<sum/localC << "\t" << localC << endl;
                        }

                        chro = temp[0];
                        counter = 0;
                        while(pos > counter +BinSize)
                        {
                                cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<0 << "\t" << 0 << endl;
                                counter+=BinSize;
                        }
                        sum=atoi(temp[5].c_str());
                        localC = 1;
                }
                else
                {
                        int pos = atoi(temp[1].c_str());
                        if (pos < counter+BinSize)
                        {
                                sum+= atoi(temp[5].c_str());
                                localC++;
                        }
                        else
                        {
                                if (localC ==0)
                                        cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<0 << "\t" << 0 << endl;
                                else
                                        cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<(double)sum/(double) localC  << "\t" << localC << endl;

                                sum = atoi(temp[5].c_str());
                                localC = 1;
                                counter+=BinSize;
                                while(pos > counter +BinSize)
                                {
                                        cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<0 << "\t" << 0 << endl;
                                        counter+=BinSize;
                                }
                        }
                }


        }
        if (localC ==0)
                cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<0 << "\t" << 0 << endl;
        else
                cout << chro << "\t" << counter << "\t" << counter+BinSize << "\t" <<sum/localC << "\t" << localC << endl;
        return 0;
}

