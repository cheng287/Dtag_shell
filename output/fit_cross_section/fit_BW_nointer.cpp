#include <iostream>
#include <fstream>
#include <iomanip>
#include "TCanvas.h"
#include "TFile.h"
#include "TTree.h"
#include "TAxis.h"
#include "TMath.h"
#include "TH1.h"
#include "TH2.h"
#include "TGraphErrors.h"
#include "TMinuit.h"
#include "TRandom.h"
#include "TLegend.h"
#include "/scratchfs/bes/liucheng/cross_section/work_Rc/new_data/4612to4700/radiation_correction/fit/func_BW_second.h"
#include "/besfs5/users/liucheng/analysis/bes3plotstyle.C"
#include "/besfs5/groups/psip/psipgroup/user/liucheng/myplotstyle.C"

double x0[12], yy0[12], ex0[12] = {0}, eyy0[12];
int n_fit = 12;

void fcn(Int_t &npar, Double_t *gin, Double_t &f, Double_t *par, Int_t iflag)
{
	f=0;
	double nn[1], f0;
	for(int i=0;i<n_fit;i++)
	{
		nn[0] = x0[i];
		f0 = pow((yy0[i]-FF_fit_nointer(nn, par))/eyy0[i],2);
		// f0 = pow((yy0[i]-FF_fit(nn, par))/eyy0[i],2);
		f += f0;
	}

}

void fit_BW_nointer()
{
	double Xmin = 3.7;
	// double Xmin = 4.5;//2.1122*2;
	double Xmax = 5.;

	// ifstream in1("/scratchfs/bes/liucheng/cross_section/work_Rc/new_data/4612to4700/radiation_correction/isr_Rc/obs_all.txt");
	// ifstream in1("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/fit_cross_section/add_obs_cross_section.txt");
    ifstream in1("/besfs5/groups/psip/psipgroup/user/liucheng/cross_section/Rc_new_run/4612to4946/output/isr_fit/fit_cross_section/isr_dressed.txt");
	double x1[12],  y1[12],  ex1[12]={0},  ey1[12];
	// double x2[100], y2[100], ex2[100]={0}, ey2[100];

	for(int i=0;i<12;i++)
	{ 
		// total points
		in1>>x1[i]>>y1[i]>>ey1[i];
	}
        
	for(int i=0;i<n_fit;i++)
	{ 
		// points used in fit
        x0[i]   = x1[i];
        yy0[i]  = y1[i];
        eyy0[i] = ey1[i];
    }

	TGraphErrors * g1 = new TGraphErrors(12, x1,y1,ex1,ey1);
	g1->SetTitle("");
	g1->SetMarkerStyle(8);
	g1->SetMarkerSize(1.);


    TMinuit *gMinuit = new TMinuit(20);
    gMinuit->SetFCN(fcn);

    double arglist[12];
    int ierflg = 0;

	//gRandom->SetSeed(WHICH_ITER);
	double rdm_param[20], rdm0;

	rdm_param[0] = 4.71;
	rdm_param[1] = 1.46044e-01;
	rdm_param[2] = 3.67157;

	rdm_param[3] = 2000.;
	rdm_param[4] = 3000.;
	rdm_param[5] = 20.;  

	cout<<setprecision(12);
	cout<<endl<<endl;
	cout<<"AAAAA ini ";
	for(int i=0;i<20;i++)
	{
		cout<<rdm_param[i]<<"    ";
	}
	cout<<endl;
	cout<<endl<<endl;

	double step[20] = {0.001, 0.001, 0.1, 1, 0.1, 0.000001, 0.005, 0.0001, 0.005, 0.001, 0.01, 0.01};
	
	gMinuit->mnparm(0,"Mass"  ,      rdm_param[0],  step[0],   4.69   ,      4.72  ,   	ierflg);
	gMinuit->mnparm(1,"Width" ,      rdm_param[1],  step[1],   0.0005 ,      0.25  , 	ierflg);
	gMinuit->mnparm(2,"GammaEE",     rdm_param[2],  step[2],   0.     ,      50.   ,   	ierflg);
	gMinuit->mnparm(3,"a1",      	 rdm_param[3],  step[3],   -1.e2  ,      1.5e4  ,    ierflg);
    gMinuit->mnparm(4,"a0",          rdm_param[4],  step[4],   -1.e2  ,      1.5e4 ,    ierflg);	
	gMinuit->mnparm(5,"Phi",     	 rdm_param[5],  step[5],   -30  ,      30.   ,	ierflg);  



    arglist[0] = 1;
    gMinuit->mnexcm("SET ERR", arglist, 1, ierflg);
    arglist[0] = 1.0e-15;
    gMinuit->mnexcm("SET EPS", arglist, 1, ierflg);
    arglist[0] = 2;
    gMinuit->mnexcm("SET STRATEGY",arglist, 1, ierflg );

    arglist[0] = 9000;
    arglist[1] = 1.0;
    gMinuit->mnexcm("MIGRAD",arglist,2,ierflg);

    // arglist[0] = 2000;
    // gMinuit->mnexcm("MINOS",arglist,1,ierflg);

    double amin, edm, errdef;
    int nvpar, nparx, icstat;
    gMinuit->mnstat(amin,edm,errdef,nvpar,nparx,icstat);     //- - - -  - -  用于获取拟合的状态和统计信息  amin 就是chi2
    cout<<endl;
	cout<<endl;
	cout<<" amin,  edm,    errdef    = "<<amin<<"      "<<edm<<"  "<<errdef<<endl;
    cout<<"nvpar,  nparx,  icstat    = "<<nvpar<<"     "<<nparx<<"  "<<icstat<<endl;
	cout<<endl<<endl;

	// amin: 拟合的最小化函数的最小值（Chi-square值）
	// edm: 拟合的估计的距离度量（Estimated Distance to Minimum）
	// errdef: 定义参数误差的标准值
	// nvpar: 有效参数的数量，即被拟合的参数的数量
	// nparx: 总参数的数量，包括被拟合的参数以及任何固定的参数
	// icstat: 拟合的状态码




    double par1[20]={0}, epar1[20]={0};
    gMinuit->GetParameter(0,par1[0], epar1[0]);    //- - - - 获取拟合得到的参数值和误差的方法
    gMinuit->GetParameter(1,par1[1], epar1[1]);
    gMinuit->GetParameter(2,par1[2], epar1[2]);
    gMinuit->GetParameter(3,par1[3], epar1[3]);
    gMinuit->GetParameter(4,par1[4], epar1[4]);
    gMinuit->GetParameter(5,par1[5], epar1[5]);  





	cout<<"------- AAAAA ini - -- - -  - - - - - -"<<endl;
	for(int i=0;i<20;i++)
	{
		cout<<par1[i]<<"  ";
	}
	cout<<endl;
	cout<<endl<<endl;

	//TF1* bw1=new TF1("bw1",BW21,Xmin,Xmax,3);
	//TF1* bw2=new TF1("bw2",BW2,Xmin,Xmax,3);
	//TF1* bg =new TF1("bg",phsp2,Xmin,Xmax,1);
	//bw1->SetParameters(par1);
	//bw2->SetParameters(&par1[3]);
	//bg->SetParameters(&par1[7]);

	int Nbin = 2000;
	// TH2F * h_mode = new TH2F("h_mode","", Nbin, Xmin, Xmax, 200,2000,6000);
	TH2F * h_mode = new TH2F("h_mode","", Nbin, 4.6, Xmax, 200,2000,6000);
	TH1D * htot = new TH1D("htot","", Nbin, Xmin, Xmax);
	TH1D * hbw1 = new TH1D("hbw1","", Nbin, Xmin, Xmax);
	// TH1D * hbw2 = new TH1D("hbw2","", Nbin, Xmin, Xmax);
	TH1D * hbg  = new TH1D("hbg" ,"", Nbin, Xmin, Xmax);

	
	// htot->SetMinimum(1.);
	// hbw1->SetMinimum(1.);
	// // hbw2->SetMinimum(1.);
	// hbg ->SetMinimum(1.);

	double par2[3] = {par1[3], par1[4],par1[5]};  //- --  - -我注释 
	// double par2[2] = {par1[3], par1[4]};  //- - - -i add
	// double par3[3] = {par1[0], par1[1],par1[2]};   //- - - - i add


	double bc[1], bh;   
	double min = 500;
	for(int i = 1;i <= Nbin; i++)
	{
		bc[0] = htot->GetBinCenter(i);
		
		bh = FF_fit_nointer(bc, par1);
		htot->SetBinContent(i,bh);

		bh = BW2(bc, par1);
		hbw1->SetBinContent(i,bh);

		// bh = phsp2(bc, par2);
		bh = phsp2_poly1(bc, par2);
		hbg->SetBinContent(i,bh);
	}

	
	cout<<"My need min=  " <<min<<endl;
	htot->SetLineColor(kRed);
	hbw1->SetLineColor(kBlue);
	//hbw2->SetLineColor(kBlue);
	hbg->SetLineColor(6);
	htot->SetLineWidth(2);
	hbg->SetLineWidth(2);

	TCanvas* c1=new TCanvas("c1","",1000,800);

	// c1->SetLogy(true);
	//- - - - - - -  - - - - - - - - -

	TPad* pad_main = new TPad("pad_main", " ", 0, 0., 1, 1);
	pad_main->SetBottomMargin(0.15);
	pad_main->SetLeftMargin(0.15);
	// pad_main->SetLogy(true);
    pad_main->Draw();

	// TPad* pad_sub = new TPad("pad_sub", " ", 0.57, 0.44, 0.90, 0.75);
	// TPad* pad_sub = new TPad("pad_sub", " ", 0.4, 0.15, 0.8, 0.6);
	TPad* pad_sub = new TPad("pad_sub", " ", 0.4, 0.17, 0.8, 0.6);
    // pad_sub->SetTopMargin(0.15);
    pad_sub->SetBottomMargin(0.15);
	pad_sub->SetLeftMargin(0.15);
	// pad_sub->SetLogy(true);
    pad_sub->Draw();


	pad_main->cd();


    //- - - - - -  - - - - - --
	// g1->GetXaxis()->SetTitle("E_{CM} (GeV)");
	// g1->GetYaxis()->SetTitle("#sigma_{D^{0}} + #sigma_{D^{+}} + #sigma_{D^{+}_{s}} (pb)");
	// g1->Draw("ap");
		
	// NameAxes(g1, (char*)" energy point (GeV) ",(char*)" #sigma_{D^{0}} + #sigma_{D^{+}} + #sigma_{D^{+}_{s}} (pb)");
    
	// htot->SetStats(0);
	
	// g1->SetMinimum(1.);
	// g1->SetMaximum(2.e12);
	// g1->SetMinimum(0.);
	// g1->SetMaximum(7000.);

	// SetStyle();
	// NameAxes(g1, (char*)"#sqrt{#font[12]{s}} (GeV) ",(char*)" #sigma(e^{+}e^{-}#rightarrow D^{0}X + D^{+}X + D^{+}_{s}X) (pb)");

	NameAxes(h_mode, (char*)"#sqrt{#font[12]{s}} (GeV) ",(char*)" #sigma(e^{+}e^{-}#rightarrow D^{0}X + D^{+}X + D^{+}_{s}X) (pb)");
 	// NameAxes(g1, (char*)"#sqrt{#font[12]{s}} (GeV) ",(char*)" #sigma(e^{+}e^{-}#rightarrow D^{0}X + D^{+}X + D^{+}_{s}X) (pb)");
   
	
	// g1->SetMinimum(1.);
	// g1->SetMaximum(2.e12);
	SetStyle();
    h_mode->GetYaxis()->SetNdivisions(505);
    // h_mode->GetXaxis()->SetNdivisions(505);
    h_mode->GetYaxis()->SetTitleOffset(1.3);
    h_mode->GetXaxis()->SetTitleOffset(1.2);
    h_mode->GetXaxis()->SetTitleSize(0.05);
    h_mode->GetYaxis()->SetTitleSize(0.05);
    h_mode->GetYaxis()->SetLabelSize(0.04);
    h_mode->GetXaxis()->SetLabelSize(0.04);	
	h_mode->Draw();


	// g1->Draw("ap same");
	g1->Draw("p same");
	

	
	// g1->Draw("ap");
	htot->Draw("same");
	hbw1->Draw("same");	
	hbg->Draw("same");


	
	//g2->Draw("psame");

	TLegend *leg=new TLegend(0.75,0.75,0.88,0.88,NULL,"brNDC");
	Set_TLegend(leg);
	// leg->SetFillColor(10);
	leg->SetFillColorAlpha(0, 0.5);

	leg->AddEntry(htot,"fit","pl");
	leg->AddEntry(hbw1,"BW","pl");
	leg->AddEntry(hbg,"Bkg","pl");
	leg->SetBorderSize(0);
	leg->Draw();

	// TLegend *leg = new TLegend(0.75,0.75,0.85,0.85,NULL,"brNDC");
	// leg->SetFillColorAlpha(0, 0.5);
	// Set_TLegend(leg);
	// TLegendEntry *entry1 = leg->AddEntry("","total","L");
	// TLegendEntry *entry2 = leg->AddEntry("","BW","L");
	// TLegendEntry *entry3 = leg->AddEntry("","Bkg","L");
	// Set_TLegendEntry_marker(entry1, 2,1);
	// Set_TLegendEntry_marker(entry2, 4,3);
	// Set_TLegendEntry_marker(entry3, 6,2);
	// leg->Draw();





	//-  - - - -  - - - - - - - - -- 
	pad_sub->cd();
	NameAxes(hbw1, (char*)"#sqrt{#font[12]{s}} (GeV) ",(char*)" #sigma(e^{+}e^{-}#rightarrow D^{0}X + D^{+}X + D^{+}_{s}X) (pb)");
	SetStyle();

	// hbw1->GetXaxis()->SetTitleSize(0.055);
    // hbw1->GetYaxis()->SetTitleSize(0.055);
	hbw1->SetStats(0);
	hbw1->GetYaxis()->SetNdivisions(505);
    hbw1->GetXaxis()->SetNdivisions(505);
    hbw1->GetYaxis()->SetTitleOffset(1.3);
    hbw1->GetXaxis()->SetTitleOffset(1.5);
    hbw1->GetXaxis()->SetTitleSize(0.05);
    hbw1->GetYaxis()->SetTitleSize(0.05);
    hbw1->GetYaxis()->SetLabelSize(0.05);
    hbw1->GetXaxis()->SetLabelSize(0.05);
	hbw1->Draw();


	c1->SetLeftMargin(0.15);
    c1->SetBottomMargin(0.15);
    //c1->SetRightMargin(0.05);
    // c1->SetTopMargin(0.15);
	c1->Update();
    c1->Modified();

	// c1->SaveAs("fit_bw_nointer.png");
	c1->SaveAs("xx2_nointer.png");
	// c1->SaveAs("xx2_nointer.eps");
}
