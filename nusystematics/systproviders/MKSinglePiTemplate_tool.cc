#include "nusystematics/systproviders/MKSinglePiTemplate_tool.hh"

#include "nusystematics/utility/GENIEUtils.hh"
#include "nusystematics/utility/exceptions.hh"

#ifndef NO_ART
#include "art/Utilities/ToolMacros.h"
#endif

#include "GHEP/GHepParticle.h"

#include "Messenger/Messenger.h"

using namespace systtools;
using namespace nusyst;
using namespace fhicl;

// #define DEBUG_MKSINGLEPI

MKSinglePiTemplate::MKSinglePiTemplate(ParameterSet const &params)
    : IGENIESystProvider_tool(params), valid_file(nullptr),
      valid_tree(nullptr) {}

namespace {
struct channel_id {
  std::string name;
  genie::SppChannel_t channel;
};
} // namespace

#ifndef NO_ART
DEFINE_ART_CLASS_TOOL(MKSinglePiTemplate)
#endif

SystMetaData MKSinglePiTemplate::BuildSystMetaData(ParameterSet const &cfg,
                                                   paramId_t firstId) {

  SystMetaData smd;

  SystParamHeader resp;
  resp.prettyName = "MKSPP_Template_response";
  resp.systParamId = firstId++;

  resp.centralParamValue = 1;
  resp.isCorrection = true;
  smd.push_back(resp);

  if (!cfg.has_key("MKSPP_Template_input_manifest") ||
      !cfg.is_key_to_table("MKSPP_Template_input_manifest")) {
    throw invalid_ToolConfigurationFHiCL()
        << "[ERROR]: When configuring calculated variations for "
           "MKSPP_Template, expected to find a FHiCL table keyed by "
           "MKSPP_Template_input_manifest describing the location of the "
           "histogram inputs. See "
           "nusystematics/responsecalculators/"
           "TemplateResponseCalculatorBase.hh "
           "for the layout.";
  }
  fhicl::ParameterSet templateManifest =
      cfg.get<fhicl::ParameterSet>("MKSPP_Template_input_manifest");
  tool_options.put("MKSPP_Template_input_manifest", templateManifest);

  size_t NChannels = 0;
  for (std::string const &ch :
       {"NumuPPiPlus", "NumuPPi0", "NumuNPiPlus", "NumuBNPiMinus", "NumuBNPi0",
        "NumuBPPiMinus"}) {

    if (!templateManifest.has_key(ch)) {
      continue;
    }

    SystParamHeader channel;
    channel.prettyName = std::string("MKSPP_Template_") + ch;
    channel.systParamId = firstId++;

    channel.centralParamValue = 1;
    channel.isCorrection = true;

    channel.isResponselessParam = true;
    channel.responseParamId = resp.systParamId;
    smd.push_back(channel);
    NChannels++;
  }

  if (!NChannels) {
    throw invalid_ToolConfigurationFHiCL()
        << "[ERROR]: When configuring a MKSPP_Template reweighting instance, "
           "failed to find any configured channels. Input templates must be "
           "described by in a table keyed MKSPP_Template_input_manifest with "
           "the layout follows that consumed by "
           "nusystematics/responsecalculators/"
           "TemplateResponseCalculatorBase.hh";
  }

  fill_valid_tree = cfg.get<bool>("fill_valid_tree", false);
  tool_options.put("fill_valid_tree", fill_valid_tree);

  use_Q2W_templates = cfg.get<bool>("use_Q2W_templates", true);
  tool_options.put("use_Q2W_templates", use_Q2W_templates);

  Q2_or_q0_is_x = cfg.get<bool>("Q2_or_q0_is_x", false);
  tool_options.put("Q2_or_q0_is_x", Q2_or_q0_is_x);

  weightGENIENonRes = cfg.get<bool>("weightGENIENonRes", true);
  tool_options.put("weightGENIENonRes", weightGENIENonRes);

  return smd;
}

bool MKSinglePiTemplate::SetupResponseCalculator(
    fhicl::ParameterSet const &tool_options) {

  genie::Messenger::Instance()->SetPrioritiesFromXmlFile(
      "Messenger_whisper.xml");

  if (!HasParam(GetSystMetaData(), "MKSPP_Template_response")) {
    throw incorrectly_configured()
        << "[ERROR]: Expected to find parameter named "
        << std::quoted("MKSPP_Template_response");
  }

  if (!tool_options.has_key("MKSPP_Template_input_manifest")) {
    throw systtools::invalid_ToolOptions()
        << "[ERROR]: MKSPP_Template_response parameter exists in the "
           "SystMetaData, "
           "but no MKSPP_Template_input_manifest key can be found on the "
           "tool_options table. This reweighting requires input histograms "
           "that must be specified. This should have been caught by  "
           "MKSinglePiTemplate::BuildSystMetaData, but wasn't, this is a "
           "bug, please report to the maintiner.";
  }

  fhicl::ParameterSet const &templateManifest =
      tool_options.get<fhicl::ParameterSet>("MKSPP_Template_input_manifest");

  ResponseParameterId =
      GetParamId(GetSystMetaData(), "MKSPP_Template_response");

  SystParamHeader hdr = GetParam(GetSystMetaData(), ResponseParameterId);

  for (channel_id const &ch :
       std::vector<channel_id>{{{"NumuPPiPlus", genie::kSpp_vp_cc_10100},
                                {"NumuPPi0", genie::kSpp_vn_cc_10010},
                                {"NumuNPiPlus", genie::kSpp_vn_cc_01100},

                                {"NumuBNPiMinus", genie::kSpp_vbn_cc_01001},
                                {"NumuBNPi0", genie::kSpp_vbp_cc_01010},
                                {"NumuBPPiMinus", genie::kSpp_vbp_cc_10001}}}) {

    if (HasParam(GetSystMetaData(), std::string("MKSPP_Template_") + ch.name)) {
      systtools::paramId_t pid = GetParamId(
          GetSystMetaData(), std::string("MKSPP_Template_") + ch.name);
      ChannelParameterMapping.emplace(
          ch.channel,
          paramTemplateReweighter{
              pid, std::make_unique<MKSinglePiTemplate_ReWeight>(
                       templateManifest.get<fhicl::ParameterSet>(ch.name))});
    }
  }

  fill_valid_tree = tool_options.get("fill_valid_tree", false);
  use_Q2W_templates = tool_options.get("use_Q2W_templates", true);
  Q2_or_q0_is_x = tool_options.get("Q2_or_q0_is_x", true);
  weightGENIENonRes = tool_options.get("weightGENIENonRes", true);

  if (fill_valid_tree) {
    InitValidTree();
  }

  return true;
}

event_unit_response_t
MKSinglePiTemplate::GetEventResponse(genie::EventRecord const &ev) {

  event_unit_response_t resp;

  if (!ev.Summary()->ProcInfo().IsWeakCC()) {
    return resp;
  }
  if (!(ev.Summary()->ProcInfo().IsResonant() ||
        ev.Summary()->ProcInfo().IsDeepInelastic())) {
    return resp;
  }
  if (ev.Summary()->Kine().W(true) > 1.7) {
    return resp;
  }

  genie::SppChannel_t chan = genie::kSppNull;

  genie::Target const &tgt = ev.Summary()->InitState().Tgt();
  if (!tgt.HitNucIsSet()) {
    throw incorrectly_generated()
        << "[ERROR]: Failed to get hit nucleon kinematics as it was not "
           "included in this GHep event. This is a fatal error.";
  }

  TLorentzVector NucP4 = tgt.HitNucP4();

  genie::GHepParticle *FSLep = ev.FinalStatePrimaryLepton();
  genie::GHepParticle *ISLep = ev.Probe();

  if (!FSLep || !ISLep) {
    throw incorrectly_generated()
        << "[ERROR]: Failed to find IS and FS lepton in event: "
        << ev.Summary()->AsString();
  }

  TLorentzVector FSLepP4 = *FSLep->P4();
  TLorentzVector ISLepP4 = *ISLep->P4();

  FSLepP4.Boost(-NucP4.BoostVector());
  ISLepP4.Boost(-NucP4.BoostVector());
  NucP4.Boost(-NucP4.BoostVector());

  TLorentzVector emTransfer = (ISLepP4 - FSLepP4);

  double wght = 1;

  chan = SPPChannelFromGHep(ev);
  if (ev.Summary()->ProcInfo().IsResonant() || weightGENIENonRes) {

    if ((chan == genie::kSppNull) ||
        (ChannelParameterMapping.find(chan) == ChannelParameterMapping.end())) {
      return resp;
    }

#ifdef DEBUG_MKSINGLEPI
    int NEUTCh = genie::utils::ghep::NeutReactionCode(&ev);

    int NPi0 = 0, NPip = 0, NP = 0, NN = 0;

    bool nuclear_target = ev.Summary()->InitState().Tgt().IsNucleus();

    TIter event_iter(&ev);
    genie::GHepParticle *p = 0;

    while ((p = dynamic_cast<genie::GHepParticle *>(event_iter.Next()))) {
      genie::GHepStatus_t ghep_ist = (genie::GHepStatus_t)p->Status();
      int ghep_pdgc = p->Pdg();
      int ghep_fm = p->FirstMother();
      int ghep_fmpdgc = (ghep_fm == -1) ? 0 : ev.Particle(ghep_fm)->Pdg();

      // For nuclear targets use hadrons marked as 'hadron in the nucleus'
      // which are the ones passed in the intranuclear rescattering
      // For free nucleon targets use particles marked as 'final state'
      // but make an exception for decayed pi0's,eta's (count them and not their
      // daughters)

      bool decayed =
          (ghep_ist == genie::kIStDecayedState &&
           (ghep_pdgc == genie::kPdgPi0 || ghep_pdgc == genie::kPdgEta));
      bool parent_included =
          (ghep_fmpdgc == genie::kPdgPi0 || ghep_fmpdgc == genie::kPdgEta);

      bool count_it =
          (nuclear_target && ghep_ist == genie::kIStHadronInTheNucleus) ||
          (!nuclear_target && decayed) ||
          (!nuclear_target && ghep_ist == genie::kIStStableFinalState &&
           !parent_included);

      if (!count_it)
        continue;
      if (ghep_pdgc == genie::kPdgPiP) {
        NPip++; // pi+
      } else if (ghep_pdgc == genie::kPdgPi0) {
        NPi0++; // pi0NPim = 0
      } else if (ghep_pdgc == genie::kPdgProton) {
        NP++; // pi0NPim = 0
      } else if (ghep_pdgc == genie::kPdgNeutron) {
        NN++; // pi0NPim = 0
      }
    }

    std::cout << "[INFO]: Event, NEUTChannel: " << NEUTCh
              << ", GENIE SPPChannel: " << chan
              << ", W = " << ev.Summary()->Kine().W(true)
              << ", PID: " << ChannelParameterMapping[chan].pid
              << ", NPi0 = " << NPi0 << ", NPip = " << NPip << ", NP = " << NP
              << ", NN = " << NN << std::endl;
#endif

#ifdef DEBUG_MKSINGLEPI
    std::cout << "[INFO]: Lab frame ENu: " << ISLepP4.E()
              << ", q0: " << (ISLepP4 - FSLepP4).E()
              << ", q3: " << (ISLepP4 - FSLepP4).Vect().Mag()
              << ", Target Nucleon: [ " << NucP4[0] << ", " << NucP4[1] << ", "
              << NucP4[2] << ", M: " << NucP4.M() << "]" << std::endl;
#endif

#ifdef DEBUG_MKSINGLEPI
    std::cout << "[INFO]: Post-boost: Target Nucleon: [ " << NucP4[0] << ", "
              << NucP4[1] << ", " << NucP4[2] << ", M: " << NucP4.M() << "]"
              << std::endl;
#endif

    std::array<double, 2> kinematics;
    kinematics[0] = use_Q2W_templates ? -emTransfer.Mag2() : emTransfer.E();
    kinematics[1] = use_Q2W_templates ? ev.Summary()->Kine().W(true)
                                      : emTransfer.Vect().Mag();

    if (Q2_or_q0_is_x) {
      std::swap(kinematics[0], kinematics[1]);
    }

    wght = ChannelParameterMapping[chan].reweighter->GetVariation(
        1, ISLepP4.E(), kinematics);

  } else { // GENIE non-resonant gets weighted to 0.
    wght = 0;
  }

  resp.push_back({ResponseParameterId, std::vector<double>{wght}});

  if (fill_valid_tree) {

    q0_nuc_rest_frame = emTransfer.E();
    q3_nuc_rest_frame = emTransfer.Vect().Mag();
    Enu_nuc_rest_frame = ISLepP4.E();

    ISLepP4 = *ISLep->P4();
    FSLepP4 = *FSLep->P4();
    emTransfer = (ISLepP4 - FSLepP4);

    pdgfslep = ev.FinalStatePrimaryLepton()->Pdg();
    momfslep = FSLepP4.Vect().Mag();
    cthetafslep = FSLepP4.Vect().CosTheta();

    Pdgnu = ISLep->Pdg();
    NEUTMode = 0;
    if (ev.Summary()->ProcInfo().IsMEC() &&
        ev.Summary()->ProcInfo().IsWeakCC()) {
      NEUTMode = (Pdgnu > 0) ? 2 : -2;
    } else {
      NEUTMode = genie::utils::ghep::NeutReactionCode(&ev);
    }
    IsDIS = ev.Summary()->ProcInfo().IsDeepInelastic();

    SppChannel = chan;

    momhmfspi = 0;
    size_t NParts = ev.GetEntries();
    for (size_t it = 0; it < NParts; ++it) {
      genie::GHepParticle *part = ev.Particle(it);
      if (part->Status() != genie::kIStStableFinalState) {
        continue;
      }
      if ((part->Pdg() != 211) && (part->Pdg() != 111)) {
        continue;
      }
      if (momhmfspi < part->P4()->Vect().Mag()) {
        pdghmfspi = part->Pdg();
        momhmfspi = part->P4()->Vect().Mag();
        cthetahmfspi = part->P4()->Vect().CosTheta();
      }
    }

    weight = wght;

    Enu = ISLepP4.E();
    Q2 = -emTransfer.Mag2();
    W = ev.Summary()->Kine().W(true);
    q0 = emTransfer.E();
    q3 = emTransfer.Vect().Mag();

    std::array<double, 2> kinematics;
    kinematics[0] = use_Q2W_templates ? -emTransfer.Mag2() : emTransfer.E();
    kinematics[1] = use_Q2W_templates ? ev.Summary()->Kine().W(true)
                                      : emTransfer.Vect().Mag();

    if (Q2_or_q0_is_x) {
      std::swap(kinematics[0], kinematics[1]);
    }

    if (chan == genie::kSppNull) {
      OutOfReWeightPS = -1;
    } else {
      OutOfReWeightPS = (ChannelParameterMapping[chan]
                             .reweighter->GetBin(ISLepP4.E(), kinematics)
                             .second == TemplateResponseQ0Q3::kBinOutsideRange);
    }

    valid_tree->Fill();
  }

  return resp;
}

std::string MKSinglePiTemplate::AsString() { return ""; }

void MKSinglePiTemplate::InitValidTree() {
  valid_file = new TFile("MKSinglePiTemplate_valid.root", "RECREATE");
  valid_tree = new TTree("valid_tree", "");

  valid_tree->Branch("NEUTMode", &NEUTMode);
  valid_tree->Branch("SppChannel", &SppChannel);
  valid_tree->Branch("Enu", &Enu);
  valid_tree->Branch("Pdg_nu", &Pdgnu);
  valid_tree->Branch("Pdg_FSLep", &pdgfslep);
  valid_tree->Branch("P_FSLep", &momfslep);
  valid_tree->Branch("CosTheta_FSLep", &cthetafslep);
  valid_tree->Branch("Pdg_HMFSPi", &pdghmfspi);
  valid_tree->Branch("P_HMFSPi", &momhmfspi);
  valid_tree->Branch("CosTheta_HMFSPi", &cthetahmfspi);
  valid_tree->Branch("Q2", &Q2);
  valid_tree->Branch("W", &W);
  valid_tree->Branch("q0", &q0);
  valid_tree->Branch("q3", &q3);
  valid_tree->Branch("Enu_nuc_rest_frame", &Enu_nuc_rest_frame);
  valid_tree->Branch("q0_nuc_rest_frame", &q0_nuc_rest_frame);
  valid_tree->Branch("q3_nuc_rest_frame", &q3_nuc_rest_frame);
  valid_tree->Branch("weight", &weight);
  valid_tree->Branch("OutOfReWeightPS", &OutOfReWeightPS);
  valid_tree->Branch("IsDIS", &IsDIS);
}

MKSinglePiTemplate::~MKSinglePiTemplate() {
  if (valid_file) {
    valid_tree->SetDirectory(valid_file);
    valid_file->Write();
    valid_file->Close();
    delete valid_file;
  }
}
