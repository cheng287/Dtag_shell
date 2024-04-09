#include "TMath.h"
#include <string>
#include <iostream>
#include <fstream>
#include <cstdio>
#include <sstream>
#include "/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/class_new_isr.h"


using namespace std;


int coutline(char *filename)
{
    int line = 0;
    ifstream infile;
    infile.open(filename); 
    
    if(!infile.is_open())
        return 0;
    
    std::string strLine;
    while(getline(infile,strLine))
    {
        if(strLine.empty())
            continue;
        line++;

    }

    infile.close();  
    return line;

}

double class_new_isr::Cross(double S)
{
	if(IfBW)
    {
        return 12.*PI*GAM_ee*GAM_tot*CC/((S-MV*MV)*(S-MV*MV) + MV*MV*GAM_tot*GAM_tot);
	}
	else
    {		      
		ifstream input_file;		
        // TString FileName("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/add_obs_cross_section.txt"); 		
		TString FileName("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/test_cross_section.txt");		
		// TString FileName("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/high_obs_cross_section.txt");   
		
		double X[500];
		double Y[500];
		double temp3;
	
		double m = sqrt(S);
		double xsec = 0.;

		input_file.open(FileName);
		double temp1,temp2,temp4;
		// int num_evt=-1;
		int num_evt = 20;
		while(1){
			if(!input_file.good())
				break;
			input_file>>temp1>>temp2>>temp4;
			num_evt++;
			//cout<<temp1<<" "<<temp2<<" "<<temp4<<endl;
		}

		//cout<<"total line "<<num_evt<<endl;
		input_file.close();

		// cout<< "m = "<<m<<endl;

		input_file.open(FileName);
		for(int i=1;i<num_evt;i++)
		// for(int i= 1;i<117;i++)
        {
			input_file>>X[i]>>Y[i]>>temp3;
			// cout<<i<<" "<<X[i]<<" "<<Y[i]<<"- - - "<<endl;
			// if(i<1)
			// 	continue;			
			
			if(m>X[i-1] && m<=X[i])
            {
				// cout<<"  m = "<<m <<"   "<<X[i-1]<<"    "<<X[i]  <<endl;
				//cout<<i<<endl;
				xsec = Y[i-1]+(Y[i]-Y[i-1])/(X[i]-X[i-1])*(m-X[i-1]);		
			}

		}
		input_file.close();
		return xsec;
	}

}



double class_new_isr::GEX_tf(double *x,double *par)
{	
    double X = pow(x[0],1.0/BETA);
	return Cross(ECM2*(1.0-X));   
}


double class_new_isr::HARD_tf( double *x,double *par)
{
	double X     = x[0];
	double HARD1 = 1.0-0.5*X;
    double HARD2 = 4.0*(2-X)*log(1/X)+(1.0+3.0*(1.0-X)*(1.0-X))/X*log(1.0/(1.0-X))-6+X;

	return (-BETA*HARD1 + BETA*BETA/8*HARD2)*Cross(ECM2*(1.0-X));    
}  




double class_new_isr::sigma(double EL, double EU)   //-- - - EU = ECM
{
    double SMU = EU*EU;
	double SML = EL*EL;
	double UPU = 1.0 - SML/ECM2;
	double UPL = 1.0 - SMU/ECM2;

    double YUPL = pow(UPL,BETA );
	double YUPU = pow(UPU,BETA );

	// class_new_isr myObject;


	// TF1* func_gex  = new TF1("func_gex",  GEX_tf,  YUPL, YUPU,0);
	// TF1* func_hard = new TF1("func_hard", HARD_tf, UPL, UPU,0);


	TF1* func_gex = new TF1("func_gex", this, &class_new_isr::GEX_tf, YUPL, YUPU,0);
	TF1* func_hard = new TF1("func_hard", this, &class_new_isr::HARD_tf, UPL, UPU,0);
	
	gROOT->ProcessLine( "gErrorIgnoreLevel = 6001;");
	gROOT->ProcessLine( "gPrintViaErrorHandler = kTRUE;");
	double GEX  = func_gex->Integral(YUPL,YUPU);

	gROOT->ProcessLine( "gErrorIgnoreLevel = 6001;");
	gROOT->ProcessLine( "gPrintViaErrorHandler = kTRUE;");
	double HARD = func_hard->Integral(UPL,UPU);

	
	//---------------------------------------
	// constant of soft photon part of F(X,S)
	//---------------------------------------
	//double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA - BETA**2/24.*(L/3.+2*PI*PI-37./4.);
	// double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA + BETA**2*(9./32.-PI*PI/12); // considering production of the real e^+e^- pairs
    
	double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA + BETA*BETA*(9./32.-PI*PI/12); // considering production of the real e^+e^- pairs

	//cout<<GEX<<" "<<DELTA<<" "<<HARD<<endl;
	
	delete func_gex;
	delete func_hard;
	
	return GEX*DELTA + HARD;



}



void class_vector_new_like_ISR_rc()
{
	
	

	
	// char filename[200] = "/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/high_obs_cross_section.txt";
	char filename[200] = "/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/add_obs_cross_section.txt";
    int row = coutline(filename);
    cout<< "row = "<< row <<endl;

	double energy_point[row];
    double cross_section[row];
    double cross_section_error;
	
	// ifstream input_file1("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/high_obs_cross_section.txt");
	ifstream input_file1("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/add_obs_cross_section.txt");
    for(int j = 0; j <row ; j++)
    {
        if(!input_file1.good())
            continue;
        input_file1>>energy_point[j]>>cross_section[j]>>cross_section_error;
        // cout<<energy_point[j]<<"  "<<cross_section<<"  "<<cross_section_error<<endl;
    }
    input_file1.close();

	
	for(int j = 0; j <row ; j++)
	{
		
		class_new_isr hello_isr;

		hello_isr.ECM = energy_point[j];
		hello_isr.updateECMValues();

		
		// ECM = energy_point[j];
		// MV   = ECM;       // Mass
		// ECM2 = ECM*ECM;     // Ecm*Ecm
		// L    = log(ECM2/M_e/M_e);
		// BETA = 2.*Alpha/PI*(L-1);

		cout<<"ECM = "<<hello_isr.ECM<<"    "<<hello_isr.MV<<"      "<< hello_isr.ECM2<<"   "<<hello_isr.L<<"   "<<  hello_isr.BETA<<endl;


		double xtot1 = hello_isr.Cross((hello_isr.ECM)*(hello_isr.ECM));
		cout << "Total cross section without ISR is : " << xtot1 << " pb." << endl;

		// double xtot2= hello_isr.sigma(3.773, hello_isr.ECM);
		double xtot2= hello_isr.sigma();
		double factor=xtot2/xtot1;
		cout << "Total cross section with ISR is : " << xtot2 << " pb." << endl;
		cout << "Radiation correction factor (1+delta) : " << factor << endl;




		// std::ofstream outputFile("xxx.txt", std::ios::app);
		std::ofstream outputFile("all_xxx.txt", std::ios::app);

    	if (outputFile.is_open()) 
		{ 
        	// outputFile << "ECM = "<<ECM<<"    "<<MV<<"      "<< ECM2<<"   "<<L<<"   "<<  BETA<<endl;
			outputFile<<hello_isr.ECM <<"                "<<cross_section[j]<<"                   "<<factor<<"                    "<<cross_section[j]/factor<<endl;

        	outputFile.close();
        	std::cout << "Content appended to file." << std::endl;
    	}
		else 
		{
        	std::cerr << "Unable to open the file." << std::endl;
    	}





	}

	


	return 0;
}



















// //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
// //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// const double ECM_threshold = 3.773; 
// // const double ECM_threshold = 4.61186  ; 


// const double GAM_ee  = 0.31e-6;    // e^+e^- Width(GeV)
// const double GAM_tot = 95.e-3;     // Total Width (GeV)
// const double M_e     = 0.0005110034;
// const double PI      = 3.14159265;
// const double Alpha   = 1./137.035982;
// const double CC      = 0.389379338E9; // Converion Constant (hbar*c)**2 GeV^2pbarn 

// bool IfBW = 0;


// // const double ECM =  4.6 ;
// // const double MV   = ECM; // Mass
// // const double ECM2 = ECM*ECM;  // Ecm*Ecm
// // const double L    = log(ECM2/M_e/M_e);
// // const double BETA = 2.*Alpha/PI*(L-1);

// double ECM =  4.6 ;
// double MV   = ECM; // Mass
// double ECM2 = ECM*ECM;  // Ecm*Ecm
// double L    = log(ECM2/M_e/M_e);
// double BETA = 2.*Alpha/PI*(L-1);




// //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

// int coutline(char *filename)
// {
//     int line = 0;
//     ifstream infile;
//     infile.open(filename); 
    
//     if(!infile.is_open())
//         return 0;
    
//     std::string strLine;
//     while(getline(infile,strLine))
//     {
//         if(strLine.empty())
//             continue;
//         line++;

//     }

//     infile.close();  
//     return line;

// }




// // double Cross(double S , double ECM)
// double Cross(double S)
// {	
// 	if(IfBW)
//     {
//         return 12.*PI*GAM_ee*GAM_tot*CC/((S-MV*MV)*(S-MV*MV) + MV*MV*GAM_tot*GAM_tot);
// 	}
// 	else
//     {
		      
//         ifstream input_file;		
// 		// TString FileName("xs_user.txt");
//         // TString FileName("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/add_obs_cross_section.txt"); 
		
// 		TString FileName("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/test_cross_section.txt");
		
// 		// TString FileName("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/high_obs_cross_section.txt");   
		

// 		double X[500];
// 		double Y[500];
// 		double temp3;
// 		// double X[117];
// 		// double Y[117];
// 		// double temp3[117];

// 		// memset(X, 0, sizeof(X));
// 		// memset(Y, 0, sizeof(Y));
// 		// memset(temp3, 0, sizeof(temp3));

// 		double m = sqrt(S);
// 		double xsec = 0.;

// 		input_file.open(FileName);
// 		double temp1,temp2,temp4;
// 		// int num_evt=-1;
// 		int num_evt = 20;
// 		while(1){
// 			if(!input_file.good())
// 				break;
// 			input_file>>temp1>>temp2>>temp4;
// 			num_evt++;
// 			//cout<<temp1<<" "<<temp2<<" "<<temp4<<endl;
// 		}

// 		//cout<<"total line "<<num_evt<<endl;
// 		input_file.close();


// 		// cout<< "m = "<<m<<endl;

// 		input_file.open(FileName);
// 		for(int i=1;i<num_evt;i++)
// 		// for(int i= 1;i<117;i++)
//         {
// 			input_file>>X[i]>>Y[i]>>temp3;
// 			// cout<<i<<" "<<X[i]<<" "<<Y[i]<<"- - - "<<endl;
// 			// if(i<1)
// 			// 	continue;
			
			
// 			if(m>X[i-1] && m<=X[i])
//             {
// 				// cout<<"  m = "<<m <<"   "<<X[i-1]<<"    "<<X[i]  <<endl;
// 				//cout<<i<<endl;
// 				xsec = Y[i-1]+(Y[i]-Y[i-1])/(X[i]-X[i-1])*(m-X[i-1]);

// 				// cout<<"ECM = "<<ECM<<"    "<<MV<<"      "<< ECM2<<"   "<<L<<"   "<<  BETA<<endl;
		
// 			}

	

// 		}
// 		input_file.close();
// 		return xsec;
// 	}
// }

// double GEX_tf(double *x,double *par)
// {	
//     double X = pow(x[0],1.0/BETA);
// 	return Cross(ECM2*(1.0-X));   
// }


// double HARD_tf( double *x,double *par)
// {
// 	double X     = x[0];
// 	double HARD1 = 1.0-0.5*X;
//     double HARD2 = 4.0*(2-X)*log(1/X)+(1.0+3.0*(1.0-X)*(1.0-X))/X*log(1.0/(1.0-X))-6+X;

// 	return (-BETA*HARD1 + BETA*BETA/8*HARD2)*Cross(ECM2*(1.0-X));    
// }  


// double sigma(double EL, double EU)   //-- - - EU = ECM
// {
//     double SMU = EU*EU;
// 	double SML = EL*EL;
// 	double UPU = 1.0 - SML/ECM2;
// 	double UPL = 1.0 - SMU/ECM2;

//     double YUPL = pow(UPL,BETA );
// 	double YUPU = pow(UPU,BETA );


// 	TF1* func_gex  = new TF1("func_gex",  GEX_tf,  YUPL, YUPU,0);
// 	TF1* func_hard = new TF1("func_hard", HARD_tf, UPL, UPU,0);


// 	// TF1* func_gex  = new TF1("func_gex",  GEX_tf ,YUPL,YUPU,1);
// 	// func_gex->SetParameter(0, EU);
	
// 	// TF1* func_hard = new TF1("func_hard", HARD_tf ,UPL,UPU,1);
// 	// func_hard->SetParameter(0, EU);

// 	// ROOT::Math::IntegratorOneDimOptions::SetDefaultRelTolerance(1.E-7);


// 	double GEX  = func_gex->Integral(YUPL,YUPU);
// 	// gROOT->ProcessLine( "gErrorIgnoreLevel = 6001;");
// 	// gROOT->ProcessLine( "gPrintViaErrorHandler = kTRUE;");
// 	double HARD = func_hard->Integral(UPL,UPU);

	
// 	//---------------------------------------
// 	// constant of soft photon part of F(X,S)
// 	//---------------------------------------
// 	//double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA - BETA**2/24.*(L/3.+2*PI*PI-37./4.);
// 	// double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA + BETA**2*(9./32.-PI*PI/12); // considering production of the real e^+e^- pairs
    
// 	double DELTA = 1 + Alpha/PI*(PI*PI/3.-0.5) + 3./4.*BETA + BETA*BETA*(9./32.-PI*PI/12); // considering production of the real e^+e^- pairs

// 	//cout<<GEX<<" "<<DELTA<<" "<<HARD<<endl;
// 	return GEX*DELTA + HARD;

// }


// void class_vector_new_like_ISR_rc()
// {
	
// 	// double xtot1 = Cross(ECM*ECM);
// 	// cout << "Total cross section without ISR is : " << xtot1 << " pb." << endl;

// 	// double xtot2= sigma(ECM_threshold, ECM);
// 	// double factor=xtot2/xtot1;
// 	// cout << "Total cross section with ISR is : " << xtot2 << " pb." << endl;
// 	// cout << "Radiation correction factor (1+delta) : " << factor << endl;

	
// 	char filename[200] = "/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/high_obs_cross_section.txt";
//     int row = coutline(filename);
//     cout<< "row = "<< row <<endl;

// 	double energy_point[row];
//     double cross_section[row];
//     double cross_section_error;
	
// 	ifstream input_file1("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/isr_Rc/high_obs_cross_section.txt");
//     for(int j = 0; j <row ; j++)
//     {
//         if(!input_file1.good())
//             continue;
//         input_file1>>energy_point[j]>>cross_section[j]>>cross_section_error;
//         // cout<<energy_point[j]<<"  "<<cross_section<<"  "<<cross_section_error<<endl;
//     }
//     input_file1.close();
	
// 	for(int j = 0; j <row ; j++)
// 	{
// 		ECM = energy_point[j];
// 		MV   = ECM;       // Mass
// 		ECM2 = ECM*ECM;     // Ecm*Ecm
// 		L    = log(ECM2/M_e/M_e);
// 		BETA = 2.*Alpha/PI*(L-1);

// 		// cout<<"ECM = "<<ECM<<"    "<<MV<<"      "<< ECM2<<"   "<<L<<"   "<<  BETA<<endl;


// 		double xtot1 = Cross(ECM*ECM);
// 		cout << "Total cross section without ISR is : " << xtot1 << " pb." << endl;

// 		double xtot2= sigma(ECM_threshold, ECM);
// 		double factor=xtot2/xtot1;
// 		cout << "Total cross section with ISR is : " << xtot2 << " pb." << endl;
// 		cout << "Radiation correction factor (1+delta) : " << factor << endl;




// 		std::ofstream outputFile("hello_i.txt", std::ios::app);

//     	if (outputFile.is_open()) 
// 		{ 
//         	// outputFile << "ECM = "<<ECM<<"    "<<MV<<"      "<< ECM2<<"   "<<L<<"   "<<  BETA<<endl;
// 			outputFile<<ECM <<"       "<<cross_section[j]<<"       "<<factor<<"       "<<cross_section[j]/factor<<endl;

//         	outputFile.close();
//         	std::cout << "Content appended to file." << std::endl;
//     	}
// 		else 
// 		{
//         	std::cerr << "Unable to open the file." << std::endl;
//     	}





// 	}

	


// 	return 0;
// }

// #include <iostream>
// #include <TF1.h>

// // Define your function to integrate
// double MyFunction(double* x, double* params) {
//     // Example: f(x) = x^2
//     return x[0] * x[0];
// }

// int main() {
//     // Create a TF1 object
//     TF1* myFunc = new TF1("myFunc", MyFunction, 0, 10, 0);

//     // Set the range for integration
//     double lowerLimit = 2.0;
//     double upperLimit = 8.0;

//     // Calculate the integral
//     double integral = myFunc->Integral(lowerLimit, upperLimit);

//     std::cout << "Integral of f(x) from " << lowerLimit << " to " << upperLimit << " = " << integral << std::endl;

//     delete myFunc;
//     return 0;
// }
