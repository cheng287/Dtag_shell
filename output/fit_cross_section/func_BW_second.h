#include "TMath.h"
#include <math.h>
#include <complex>

using namespace std;
const double PI = 3.1415926;
//const double units = 389379.6623;
const double units 	= 0.389379;
const double mpi 	= 0.139570;
const double mhc 	= 3.52593;
const double mjpsi	= 3.0969;
double mDss			= 1.864;     //2.1122;

const double m4160 = 4.191;
const double w4160 = 0.070;
const double m4415 = 4.421;
const double w4415 = 0.062;

complex <double> BW(double x, double mass, double width, double Gee)
{
	complex <double> I(0,1);
	if(TMath::IsNaN(mass)) mass = 4.25;
	if(TMath::IsNaN(width)) width = 0.05;
	if(TMath::IsNaN(Gee))  Gee = 5e-06;

    complex <double> val = sqrt(12*PI*Gee*width)/(x*x-mass*mass+I*mass*width);

    return val;
}

double ps(double x)
{
    double  m    = x ;
    double phsp1 = 0.;

    if(m > 2.*mDss)
    	phsp1 = sqrt(pow((m*m-2.0*mDss*mDss),2)/4.0-pow(mDss,4))/m/m;
    
	return sqrt(phsp1*phsp1*phsp1);
}

double ps_poly2(double x, double a, double b, double c)
{
	double m = x;
	double phsp1 = 0.;
	if( m > 2.*mDss)
		phsp1 = a*m*m+b*m+c;
	
	return	sqrt(abs(phsp1));
}

double ps_poly1(double x, double a, double b)
{
	double m = x;
	double phsp1 = 0.;
	if( m>2.*mDss)
		phsp1 = a*m+b;

	return  sqrt(abs(phsp1));
}


double ps_poly0(double x, double a)
{
	double m = x;
	double phsp1 = 0.;
	if( m >2.*mDss)           
		phsp1=a;
	return  sqrt(abs(phsp1));               
}



double phsp2(double *x, double *par)
{
	complex <double> tmp_phsp2 = par[0]*ps(x[0])/pow(x[0],par[1]);
    
	return norm(tmp_phsp2)*units;
}


double phsp2_poly2(double *x, double *par)
{
	complex <double> tmp_phsp2 = ps_poly2(x[0],par[0],par[1],par[2]);

	return norm(tmp_phsp2)*units;
}


double phsp2_poly1(double *x, double *par)
{
	complex <double> tmp_phsp2 = ps_poly1(x[0],par[0],par[1]);

	return norm(tmp_phsp2)*units;
}


double phsp2_poly0(double *x, double *par)
{
	complex <double> tmp_phsp2 = ps_poly0(x[0],par[0]);
	return norm(tmp_phsp2)*units;
}




double BW2(double *x, double *par)
{
	complex <double> bw = BW(x[0], par[0], par[1], par[2]);
	double ps1 = ps(x[0])/ps(par[0]);
	complex <double> val = (par[0]/x[0])*ps1*bw;

    return norm(val)*units;
}

double BW21(double *x, double *par)
{
    complex <double> bw = BW(x[0], par[0], par[1], par[2]);
    double ps1 = ps(x[0]);
    complex <double> val = (par[0]/x[0])*ps1*bw;

    return norm(val)*units;
}

//- - -  - - - - -我注释--有干涉

double FF_fit(double *x, double *par)
{
    double M3     = par[0];
    double G3     = par[1];
    double Gee3   = par[2];
	double a0     = par[3];
	double a1     = par[4];
	double p_phsp = par[5];  


    if(TMath::IsNaN(M3)) M3 = 4.7;
    if(TMath::IsNaN(G3)) G3 = 0.13;
    if(TMath::IsNaN(Gee3)) Gee3 = 10.0e-06;
    //if(TMath::IsNaN(p3)) p3 = 2.0;

	//if(TMath::IsNaN(Gee_phsp)) Gee_phsp = 13.0e-06;
	if(TMath::IsNaN(p_phsp)) p_phsp = 2.;

	
	//if(TMath::IsNaN(a3)) a3 = 100.;
	//if(TMath::IsNaN(a2)) a2 = 50.;
    if(TMath::IsNaN(a1)) a1 = 10.;
	if(TMath::IsNaN(a0)) a0 = 10.;

	complex <double> I(0,1);
	complex <double> beta_phsp = exp(I*p_phsp);

	double ps3    = ps(x[0])/ps(M3);
	double psphsp = ps_poly1(x[0],a0,a1);

	complex <double> val = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 + psphsp*beta_phsp;

	double normVal = norm(val)*units;
	return normVal;
}

//-------------------------------以下为我添加
//- - - - 我更改，无干涉 - - - -  - - -- - - - - -
double FF_fit_nointer(double *x, double *par)
{

	double M3     = par[0];
    double G3     = par[1];
    double Gee3   = par[2];
	double a1     = par[3];
	double a0     = par[4];
	double p_phsp = par[5];  


    if(TMath::IsNaN(M3)) M3 = 4.7;
    if(TMath::IsNaN(G3)) G3 = 0.13;
    if(TMath::IsNaN(Gee3)) Gee3 = 10.0e-06;
    //if(TMath::IsNaN(p3)) p3 = 2.0;

	//if(TMath::IsNaN(Gee_phsp)) Gee_phsp = 13.0e-06;
	if(TMath::IsNaN(p_phsp)) p_phsp = 2.;

	
	//if(TMath::IsNaN(a3)) a3 = 100.;
	//if(TMath::IsNaN(a2)) a2 = 50.;
    if(TMath::IsNaN(a1)) a1 = 10.;
	if(TMath::IsNaN(a1)) a0 = 10.;

	complex <double> I(0,1);
	complex <double> beta_phsp = exp(I*p_phsp);

	double ps3    = ps(x[0])/ps(M3);
	// double psphsp = ps_poly1(x[0],a1,a0);
	double psphsp = ps_poly1(x[0],a0,a1);

	// complex <double> val = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 + psphsp*beta_phsp;
	// double normVal = norm(val)*units;

	complex <double> val_bw = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 ;
	complex <double> val_con = psphsp*beta_phsp;
	double normVal = norm(val_bw)*units + norm(val_con)*units;;
	return normVal;

}


//////////---------------------2阶本底------------2024/3/20 add
double FF_fit_2_order(double *x, double *par)
{
    double M3     = par[0];
    double G3     = par[1];
    double Gee3   = par[2];
	double a0     = par[3];
	double a1     = par[4];
	double a2     = par[5];       //   ps_poly2  ax^2 +bx +c
	double p_phsp = par[6];

    if(TMath::IsNaN(M3)) M3 = 4.7;
    if(TMath::IsNaN(G3)) G3 = 0.13;
    if(TMath::IsNaN(Gee3)) Gee3 = 10.0e-06;
    //if(TMath::IsNaN(p3)) p3 = 2.0;

	//if(TMath::IsNaN(Gee_phsp)) Gee_phsp = 13.0e-06;
	if(TMath::IsNaN(p_phsp)) p_phsp = 2.;

	
	//if(TMath::IsNaN(a3)) a3 = 100.;
	if(TMath::IsNaN(a2)) a2 = 50.;
    if(TMath::IsNaN(a1)) a1 = 10.;
	if(TMath::IsNaN(a0)) a0 = 10.;

	complex <double> I(0,1);
	complex <double> beta_phsp = exp(I*p_phsp);

	double ps3    = ps(x[0])/ps(M3);
	// double psphsp = ps_poly1(x[0],a1,a0);
	double psphsp = ps_poly2(x[0],a0,a1,a2);    // a1*x^2 +a0*x +a2

	complex <double> val = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 + psphsp*beta_phsp;

	double normVal = norm(val)*units;
	return normVal;
}




///////////////-------------a*1/(m^2) +b 本底----------------

double ps_poly_1_s(double x, double a, double b)
{
	double m = x;
	double phsp1 = 0.;
	if( m>2.*mDss)
		phsp1 = a/(m*m)+b;

	return  sqrt(abs(phsp1));
}

double phsp2_poly1_s(double *x, double *par)
{
	complex <double> tmp_phsp2 = ps_poly_1_s(x[0],par[0],par[1]);

	return norm(tmp_phsp2)*units;
}

double FF_fit_1_s(double *x, double *par)
{
    double M3     = par[0];
    double G3     = par[1];
    double Gee3   = par[2];
	double a0     = par[3];
	double a1     = par[4];
	double p_phsp = par[5];  


    if(TMath::IsNaN(M3)) M3 = 4.7;
    if(TMath::IsNaN(G3)) G3 = 0.13;
    if(TMath::IsNaN(Gee3)) Gee3 = 10.0e-06;
    //if(TMath::IsNaN(p3)) p3 = 2.0;

	//if(TMath::IsNaN(Gee_phsp)) Gee_phsp = 13.0e-06;
	if(TMath::IsNaN(p_phsp)) p_phsp = 2.;

	
	//if(TMath::IsNaN(a3)) a3 = 100.;
	//if(TMath::IsNaN(a2)) a2 = 50.;
    if(TMath::IsNaN(a1)) a1 = 10.;
	if(TMath::IsNaN(a0)) a0 = 10.;

	complex <double> I(0,1);
	complex <double> beta_phsp = exp(I*p_phsp);

	double ps3    = ps(x[0])/ps(M3);
	double psphsp = ps_poly_1_s(x[0],a0,a1);

	complex <double> val = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 + psphsp*beta_phsp;

	double normVal = norm(val)*units;
	return normVal;
}



double FF_fit_1_s_nointer(double *x, double *par)
{
    double M3     = par[0];
    double G3     = par[1];
    double Gee3   = par[2];
	double a0     = par[3];
	double a1     = par[4];
	double p_phsp = par[5];  


    if(TMath::IsNaN(M3)) M3 = 4.7;
    if(TMath::IsNaN(G3)) G3 = 0.13;
    if(TMath::IsNaN(Gee3)) Gee3 = 10.0e-06;
    //if(TMath::IsNaN(p3)) p3 = 2.0;

	//if(TMath::IsNaN(Gee_phsp)) Gee_phsp = 13.0e-06;
	if(TMath::IsNaN(p_phsp)) p_phsp = 2.;

	
	//if(TMath::IsNaN(a3)) a3 = 100.;
	//if(TMath::IsNaN(a2)) a2 = 50.;
    if(TMath::IsNaN(a1)) a1 = 10.;
	if(TMath::IsNaN(a0)) a0 = 10.;

	complex <double> I(0,1);
	complex <double> beta_phsp = exp(I*p_phsp);

	double ps3    = ps(x[0])/ps(M3);
	double psphsp = ps_poly_1_s(x[0],a0,a1);

	// complex <double> val = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 + psphsp*beta_phsp;

	// double normVal = norm(val)*units;
	// return normVal;

	complex <double> val_bw = (M3/x[0])*BW(x[0],M3,G3,Gee3)*ps3 ;
	complex <double> val_con = psphsp*beta_phsp;
	double normVal = norm(val_bw)*units + norm(val_con)*units;;
	return normVal;
}

///////////////-----------------------------