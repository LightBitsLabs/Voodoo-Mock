ifeq ($(V),1)
  Q =
else
  Q = @
endif

clean_unittest:
	rm -fr build_unittest coverage

# build and run all unit-tests
test_all: test_build_all test_run_all
	$(Q)echo "Building and running all tests"

# build all unit-tests
test_build_all:
	$(Q)echo "Building all tests"
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/1_generate.Makefile
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/2_build.Makefile

# run all unit-tests
test_run_all:
	$(Q)echo "Running all tests"
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/3_run.Makefile
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/4_optional_enforce_cpp_coverage.Makefile

test_allPython:
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/3_run.Makefile

__SINGLE_TEST_SUITE_PYTHON = $(filter-out %.py,$(SINGLE_TEST_SUITE))

# build and run a single test suite (SINGLE_TEST_SUITE must be defined)
test_singletestsuite: test_build_singletestsuite test_run_singletestsuite
	$(Q)echo "Building and running single test suite $(SINGLE_TEST_SUITE)"

# build a single test suite (SINGLE_TEST_SUITE must be defined)
test_build_singletestsuite:
	$(Q)echo "Building single test suite $(SINGLE_TEST_SUITE)"
	$(Q)[ "$(SINGLE_TEST_SUITE)" ] || echo 'You must specify "SINGLE_TEST_SUITE=<filename>"'
	$(Q)[ "$(SINGLE_TEST_SUITE)" ]
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/1_generate.Makefile
	test -z '$(__SINGLE_TEST_SUITE_PYTHON)' || $(MAKE) -f $(VOODOO_ROOT_DIR)/make/2_build.Makefile CXXTEST_FIND_PATTERN=$(SINGLE_TEST_SUITE)

# run a single test suite (SINGLE_TEST_SUITE must be defined)
test_run_singletestsuite:
	$(Q)echo "Running single test suite $(SINGLE_TEST_SUITE)"
	$(Q)$(VOODOO_ROOT_DIR)/make/runsingletestsuite.sh $(SINGLE_TEST_SUITE)

# build a test suite and run a single test from that test-suite (SINGLE_TEST_SUITE must be defined, regex or line number must be given to filter out the test)
test_singletest:
	$(Q)echo "Building single test suite and running a single test $(SINGLE_TEST_SUITE) Line/Name $(REGEX_OR_LINE_NUMBER)"
	$(Q)[ "$(SINGLE_TEST_SUITE)" ] || echo 'You must specify "SINGLE_TEST_SUITE=<filename>"'
	$(Q)[ "$(SINGLE_TEST_SUITE)" ]
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/1_generate.Makefile
	test -z '$(__SINGLE_TEST_SUITE_PYTHON)' || $(MAKE) -f $(VOODOO_ROOT_DIR)/make/2_build.Makefile CXXTEST_FIND_PATTERN=$(SINGLE_TEST_SUITE)
	$(Q)$(VOODOO_ROOT_DIR)/make/runsingletest.sh $(SINGLE_TEST_SUITE) $(REGEX_OR_LINE_NUMBER)

# run a single test from a test-suite (SINGLE_TEST_SUITE must be defined, regex or line number must be given to filter out the test)
test_run_singletest:
	$(Q)echo "Running single test $(SINGLE_TEST_SUITE) Line/Name $(REGEX_OR_LINE_NUMBER)"
	$(Q)$(VOODOO_ROOT_DIR)/make/runsingletest.sh $(SINGLE_TEST_SUITE) $(REGEX_OR_LINE_NUMBER)

voodoo_compileSingleHeader:
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/1_generate.Makefile generateSingleVoodoo

voodoo_forceGenerateAll:
	$(MAKE) -f $(VOODOO_ROOT_DIR)/make/1_generate.Makefile generateVoodooForce
