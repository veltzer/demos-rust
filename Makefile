##############
# parameters #
##############
# do you want dependency on the Makefile itself ?
DO_ALLDEP:=1
# do you want to show the commands executed ?
DO_MKDBG?=0
# do you compile rust files?
DO_EXECS:=1

########
# code #
########
ALL:=

# dependency on the makefile itself
ifeq ($(DO_ALLDEP),1)
.EXTRA_PREREQS+=$(foreach mk, ${MAKEFILE_LIST},$(abspath ${mk}))
endif # DO_ALLDEP

# silent stuff
ifeq ($(DO_MKDBG),1)
Q:=
# we are not silent in this branch
else # DO_MKDBG
Q:=@
#.SILENT:
endif # DO_MKDBG

SRC:=src
SOURCES:=$(shell find $(SRC) -name "*.rs" -and -type f)
EXES:=$(addsuffix .elf, $(basename $(SOURCES)))
FLAGS:=-O -C debuginfo=0
# FLAGS:=-O -g
# FLAGS:=

ifeq ($(DO_EXECS),1)
ALL+=$(EXES)
endif # DO_EXECS

#########
# rules #
#########
.PHONY: all
all: $(EXES)
	@true
.PHONY: clean
clean:
	$(info doing [$@])
	$(Q)rm -f $(EXES)
.PHONY: clean_hard
clean_hard:
	$(info doing [$@])
	$(Q)git clean -qffxd
.PHONY: debug
debug:
	$(info SOURCES is $(SOURCES))
	$(info EXES is $(EXES))
	@true
############
# patterns #
############
$(EXES): %.elf: %.rs
	$(info doing [$@])
	$(Q)rustc $(FLAGS) $< -o $@
	$(Q)strip $@
