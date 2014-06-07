.SUFFIXES: .f .F .F90 .f90 .o .mod
.SHELL: /bin/sh

.PHONY : usage
usage:
	@echo ""
	@echo "    * USAGE * "
	@echo ""
	@echo " make insol      : compiles the main program test_insol.x"
	@echo " make clean      : cleans object files"
	@echo ""

# PATH options
objdir = .obj
libdir = ..

# netcdf_inc = /usr/include
# netcdf_lib = /usr/lib
netcdf_inc = /opt/local/include
netcdf_lib = /opt/local/lib
netcdf_inc_ifort = /home/robinson/apps/netcdf/netcdf/include
netcdf_lib_ifort = /home/robinson/apps/netcdf/netcdf/lib

# Command-line options at make call
ifort ?= 0
debug ?= 0 

ifeq ($(ifort),1)
    FC = ifort 
else
    FC = gfortran
endif 

ifeq ($(ifort),1)
	## IFORT OPTIONS ##
	FLAGS        = -module $(objdir) -L$(objdir) -I$(netcdf_inc_ifort)
	LFLAGS		 = -L$(netcdf_lib_ifort) -lnetcdf

	ifeq ($(debug), 1)
	    DFLAGS   = -C -traceback -ftrapuv -fpe0 -check all -vec-report0
	    # -w 
	else
	    DFLAGS   = -vec-report0 -O3
	endif
else
	## GFORTRAN OPTIONS ##
	FLAGS        = -I$(objdir) -J$(objdir) -I$(netcdf_inc)
	LFLAGS		 = -L$(netcdf_lib) -lnetcdff -lnetcdf

	ifeq ($(debug), 1)
	    DFLAGS   = -w -p -ggdb -ffpe-trap=invalid,zero,overflow,underflow \
	               -fbacktrace -fcheck=all -fbackslash
	else
	    DFLAGS   = -O3 -fbackslash
	endif
endif

## Individual libraries or modules ##
$(objdir)/nml.o: nml.f90
	$(FC) $(DFLAGS) $(FLAGS) -c -o $@ $<

## Complete programs

nml: $(objdir)/nml.o
	$(FC) $(DFLAGS) $(FLAGS) -o test_nml.x $^ test_nml.f90 $(LFLAGS)
	@echo " "
	@echo "    test_nml.x is ready."
	@echo " "

clean:
	rm -f test_nml.x $(objdir)/*.o $(objdir)/*.mod

