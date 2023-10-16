#include "nusystematics/systproviders/zexpansion_weighter.hh"

#include "systematicstools/utility/FHiCLSystParamHeaderUtility.hh"

#include "RwFramework/GSyst.h"
#include "Eigen/Dense"


#include <stdlib.h>
#include <iostream>
#include <vector>
#include <numeric>
#include <string>
#include <functional>
#include <vector>
#include "TRandom3.h"
#include <iostream>
#include <fstream>
#include <vector>
#include <Eigen/Dense>

#define private public
#define protected public
using Eigen::MatrixXd;
using Eigen::VectorXd;
using namespace std;
using namespace genie;
using namespace genie::rew;
fstream file;


using namespace nusyst;
using namespace systtools;
using namespace std;

//Somewhere near the top of the main function, before we do any file reading
  
  
//global variables
namespace PRD_93_113015 {
Eigen::Vector4d a_14_cv{2.3,-0.6, -3.8, 2.3,};
Eigen::Vector4d a_14_errors{0.13, 1, 2.5, 2.7};
Eigen::MatrixXd Covariance_Matrix {{0.0169, 0.0455, -0.22035, 0.214461},
  {0.0455, 1. ,-2.245, 0.9909},
  {-0.22035, -2.245, 6.25, -4.62375},
  {0.214461, 0.9909, -4.62375, 7.29}};
Eigen::Array4d central_values_a_from_genie = {2.30 ,-0.60 ,-3.80 ,2.30};
Eigen::Array4d central_values_afrom_errors_genie_code = {0.14,0.67,1,0.75};//-----in genie
Eigen::Array4d central_values_afrom_errors_genie = {0.13,1,2.5,2.7};
}



Eigen::MatrixXd GetPCAFromCovarianceMatrix(Eigen::MatrixXd const &Covariance_Matrix){
      Eigen::MatrixXd Eigenvalues;
      Eigen::MatrixXd eigenvector_colmatrix;
      Eigen::MatrixXd eigenvalue_sqrt_matrix;
      Eigen::VectorXd eigenvalues_sqrt; 
      Eigen::SelfAdjointEigenSolver<Eigen::MatrixXd> eigensolver(PRD_93_113015::Covariance_Matrix);
        if (eigensolver.info() != Eigen::Success) abort();
        Eigenvalues = (eigensolver.eigenvalues()).asDiagonal();
        eigenvector_colmatrix = eigensolver.eigenvectors();
        eigenvalue_sqrt_matrix = eigenvalues_sqrt.asDiagonal();    
      Eigen::MatrixXd PCA = eigenvalue_sqrt_matrix * eigenvector_colmatrix; 
    return PCA;
    }

  //Function that takes uncorellated b values, and transforms them into a values using PCA
  Eigen::VectorXd GetAValuesFromBValues(std::vector<double> const &BVals, Eigen::MatrixXd const &PCA){
    Eigen::VectorXd avals = Eigen::VectorXd::Zero(4);
    for(size_t i = 0; i < 4; ++i){
      avals += PCA.col(i) * BVals[i]; 
    }
    return avals;
  }
  
  //Function to rescale the a parameters for GENIE ReWeight
  Eigen::Array4d ScaleAparamsforGenie(Eigen::VectorXd &avals)
    //Eigen::VectorXd &avals)
  //, Eigen::Array4d &central_values_from_genie, Eigen::Array4d &central_values_errors_from_genie,Eigen::Vector4d &a_14_cv)
  {
    Eigen::VectorXd avalues_for_genie =
        (((PRD_93_113015::a_14_cv + avals).array() /PRD_93_113015::central_values_a_from_genie.array()) -1.0) 
        /PRD_93_113015::central_values_afrom_errors_genie .array();
    return avalues_for_genie;
  }
  
  /*
  void SetSystematicInTermsOfB(Eigen::Array4d avalues_for_genie, GReWeightNuXSecCCQE &grw){
  std::vector<GSyst_t> syst_dials = {kXSecTwkDial_ZExpA1CCQE, kXSecTwkDial_ZExpA2CCQE,kXSecTwkDial_ZExpA3CCQE, kXSecTwkDial_ZExpA4CCQE};
  for(size_t i = 0; i < 4; ++i){
    grw.SetMode(GReWeightNuXSecCCQE::kModeZExp);
    grw.SetSystematic(syst_dials[i], avalues_for_genie[i]);
  }
}
*/

std::array<std::string, 4> a_params_for_zexp_names = {"b1", "b2", "b3", "b4"}; //the parameters for z expansion

// constructor passes up configuration object to base class for generic tool
// initialization and initialises our local copies of paramIds to unconfigured
//  flag values
ReWeighter::ReWeighter(fhicl::ParameterSet const &params)
    : IGENIESystProvider_tool(params),     //IGENIESystProvider_tool takes parameters and sets tune  and event records etc. in GENIE
      pidx_Params{kParamUnhandled<size_t>, kParamUnhandled<size_t>,
                  kParamUnhandled<size_t>, kParamUnhandled<size_t>} {} // The ParamHeaders id of the four free parameters provided by thissystprovider

SystMetaData ReWeighter::BuildSystMetaData(fhicl::ParameterSet const &ps,
                                              paramId_t firstId) {
  SystMetaData smd;
  SystParamHeader responseParam;

  // loop through the four named parameters that this tool provides
  for (std::string const &pname : a_params_for_zexp_names) {
    SystParamHeader phdr;

    // Set up parameter definition with a standard tool configuration form
    // using helper function.
    if (ParseFhiclToolConfigurationParameter(ps, pname, phdr, firstId)) {
      phdr.systParamId = firstId++;

      // set any parameter-specific ParamHeader metadata here
      phdr.isSplineable = true;

      // add it to the metadata list to pass back.
      smd.push_back(phdr);
    }

    
  genie::RunOpt *grunopt = genie::RunOpt::Instance();
  grunopt->EnableBareXSecPreCalc(true);

  //We need to work out what the EventGeneratorList actually is
  std::string EventGeneratorList_name = "Default";
  grunopt->SetEventGeneratorList(EventGeneratorList_name);

  //We need to work out what the TUNE name actually is
 // std::string Tune_name = "G18_02a_00_000"; //find Tune_name using echo $GENIE_XSEC_TUNE
  std::string Tune_name = "G18_10i_02_11a"; //Different TUNE that does work with z-expansion = G18_10i_02_11a
  grunopt->SetTuneName(Tune_name);
  grunopt->BuildTune();


  }

  // Put any options that you want to propagate to the ParamHeaders options
  tool_options.put("verbosity_level", ps.get<int>("verbosity_level", 0));

  return smd;
}

bool ReWeighter::SetupResponseCalculator(
    fhicl::ParameterSet const &tool_options) {
  verbosity_level = tool_options.get<int>("verbosity_level", 0);

  // grab the pre-parsed param headers object
  SystMetaData const &md = GetSystMetaData();

  // loop through the named parameters that this tool provides, check that they
  // are configured, and grab their id in the current systmetadata and set up
  // and pre-calculations/configurations required.
  for (size_t i = 0; i < a_params_for_zexp_names.size(); ++i) { 

    if (!HasParam(md, a_params_for_zexp_names[i])) {
      if (verbosity_level > 1) {
        std::cout << "[INFO]: Don't have parameter " << a_params_for_zexp_names[i]
                  << " in SystMetaData. Skipping configuration." << std::endl;
      }
      continue;
    }
    pidx_Params[i] = GetParamIndex(md, a_params_for_zexp_names[i]);

    if (verbosity_level > 1) {
      std::cout << "[INFO]: Have parameter " << a_params_for_zexp_names[i]
                << " in SystMetaData with ParamId: " << pidx_Params[i]
                << ". Configuring." << std::endl;
    }

    auto param_md = md[pidx_Params[i]];
    CVs[i] = param_md.centralParamValue;
    Variations[i] = param_md.paramVariations;

    std::vector<std::unique_ptr<GReWeightNuXSecCCQE>> rand_b_reweight_engines; // vector of reweighters
    // in the concrete version of this example we're going to configure a
    // GENIE GReWeightNuXSecCCQE instance for each configured variation.
    for (auto v : Variations[i]) {
      static std::array<genie::rew::GSyst_t, 4> const zexp_dials{
          genie::rew::kXSecTwkDial_ZExpA1CCQE,
          genie::rew::kXSecTwkDial_ZExpA2CCQE,
          genie::rew::kXSecTwkDial_ZExpA3CCQE,
          genie::rew::kXSecTwkDial_ZExpA4CCQE};
        //
    
    /*
      // instantiate a new weight engine instance for this variation
      ReWeightEngines[i].emplace_back();
      ReWeightEngines[i].back().SetMode(genie::rew::GReWeightNuXSecCCQE::kModeZExp); // set its systematic
      ReWeightEngines[i].back().SetSystematic(zexp_dials[i], v);
      // configure it to weight events -- add b to a translations here:
      //global variables
    */
     
    //ScaleAParams(CV[i])

      //Rotate b parameters countained in the config file
      ReWeightEngines_new[i].push_back(std::make_unique <genie::rew::GReWeightNuXSecCCQE>());
      //ReWeightEngines_new[i].push_back(std::make_unique <genie::rew::GReWeightNuXSecCCQE>());
      ReWeightEngines_new[i].back()->SetMode(GReWeightNuXSecCCQE::kModeZExp);
      
      ReWeightEngines[i].emplace_back();

      //------------ReWeightEngines[i].back().SetMode(genie::rew::GReWeightNuXSecCCQE::kModeZExp); // set its systematic

      Eigen::VectorXd aval_vec = Eigen::VectorXd::Zero(4);
    for(size_t i = 0; i < 4; ++i) { 
        aval_vec[i] = CVs[i]; }
        //----ReWeightEngines[i].back().SetSystematic(zexp_dials[i], ScaleAparamsforGenie(aval_vec)[i]);
        ReWeightEngines_new[i].back()->SetSystematic(zexp_dials[i], ScaleAparamsforGenie(aval_vec)[i]);
        ReWeightEngines_new[i].back()->Reconfigure();
    //---------ReWeightEngines[i].back().Reconfigure();
    if (verbosity_level > 2) {
    std::cout << "[LOUD]: Configured GReWeightNuXSecCCQE instance for "
                  "GENIE dial: "
              << genie::rew::GSyst::AsString(zexp_dials[i])
              << " at variation: " << v << std::endl;
    }
    }
  }
  // returning cleanly
  return true;
}

event_unit_response_t
ReWeighter::GetEventResponse(genie::EventRecord const &ev) {

  event_unit_response_t resp;
  SystMetaData const &md = GetSystMetaData();

  // return early if this event isn't one we provide responses for
  if (!ev.Summary()->ProcInfo().IsQuasiElastic() ||
      !ev.Summary()->ProcInfo().IsWeakCC() ||
      ev.Summary()->ExclTag().IsCharmEvent()) {
    return resp;
  }

  // loop through and calculate weights
  for (size_t i = 0; i < a_params_for_zexp_names.size(); ++i) {
    // this parameter wasn't configured, nothing to do
    if (pidx_Params[i] == kParamUnhandled<size_t>) {
      continue;
    }

    // initialize the response array with this paramId
    resp.push_back({md[pidx_Params[i]].systParamId, {}});

    // loop through variations for this parameter
    for (size_t v_it = 0; v_it < Variations[i].size(); ++v_it) {

      // put the response weight for this variation of this parameter into the
      // response object
      resp.back().responses.push_back(ReWeightEngines[i][v_it].CalcWeight(ev));
      if (verbosity_level > 3) {
        std::cout << "[DEBG]: For parameter " << md[pidx_Params[i]].prettyName
                  << " at variation[" << v_it << "] = " << Variations[i][v_it]
                  << " calculated weight: " << resp.back().responses.back()
                  << std::endl;
      }
    }
  }

  return resp;
}
