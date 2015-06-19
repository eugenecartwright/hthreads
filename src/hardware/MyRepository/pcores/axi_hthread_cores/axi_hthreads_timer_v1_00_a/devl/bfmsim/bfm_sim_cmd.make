##############################################################################
## Filename:          /home/jagron/uark_research/plb_cores/edk_user_repository/MyProcessorIPLib/pcores/plb_hthreads_timer_v1_00_a/devl/bfmsim/bfm_sim_cmd.make
## Description:       Makefile for BFM Simulation through command line
## Date:              Mon Jun 29 12:13:24 2009 (by Create and Import Peripheral Wizard)
##############################################################################


SYSTEM = bfm_system

MHSFILE = bfm_system.mhs

FPGA_ARCH = virtex5

LANGUAGE = vhdl

SEARCHPATHOPT = -lp ../../../../../

SIMULATOR_OPT = -s mti

ISELIB_OPT = 

EDKLIB_OPT = 

SIMGEN_OPTIONS = \
	-p $(FPGA_ARCH) \
	-lang $(LANGUAGE) \
	$(SEARCHPATHOPT) \
	$(SIMULATOR_OPT) \
	$(ISELIB_OPT) \
	$(EDKLIB_OPT)

SIM_CMD = vsim

BFC_CMD = xilbfc -plbv46

BFL_SCRIPTS = \
	sample.bfl

BFM_SCRIPTS = \
	scripts/sample.do

DO_SCRIPT = scripts/run.do

BEHAVIORAL_SIM_SCRIPT = simulation/behavioral/$(SYSTEM).do

############################################################
# EXTERNAL TARGETS
############################################################

bfl: $(BFM_SCRIPTS)

sim: $(BEHAVIORAL_SIM_SCRIPT) $(BFM_SCRIPTS)
	@echo "*********************************************"
	@echo "Start BFM simulation ..."
	@echo "*********************************************"
	bash -c "cd simulation/behavioral; $(SIM_CMD) -do ../../$(DO_SCRIPT) -gui &"

simmodel: $(BEHAVIORAL_SIM_SCRIPT)

clean: simclean
	rm -rf $(BFM_SCRIPTS)

simclean:
	rm -rf simulation/behavioral

############################################################
# BEHAVIORAL SIMULATION GENERATION FLOW
############################################################

$(BEHAVIORAL_SIM_SCRIPT): $(MHSFILE)
	@echo "*********************************************"
	@echo "Create behavioral simulation models ..."
	@echo "*********************************************"
	simgen $(MHSFILE) $(SIMGEN_OPTIONS) -m behavioral

$(BFM_SCRIPTS): scripts/$(BFL_SCRIPTS)
	@echo "*********************************************"
	@echo "Compile bfl script(s) for BFM simulation ..."
	@echo "*********************************************"
	bash -c "cd scripts; $(BFC_CMD) $(BFL_SCRIPTS)"


