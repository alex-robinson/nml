

program test

    use nml 

    implicit none 

    type pars_group1 
        character(len=256) :: string1, string2, stringarr1(3)
        logical :: logical1 
        integer :: integer1, integer2 
    end type 

    type pars_group2 
        character(len=256) :: string1, string2, stringarr1(3)
        logical :: logical1 
        integer :: integer1, integer2, intarr1(10)
        double precision :: double1 
    end type 

    type(pars_group1) :: group1 
    type(pars_group2) :: group2 
    character(len=256) :: filename 

    filename = "namelist.nml" 

    ! Read parameters from file
    write(*,*) "group1 ==========="
    call nml_read(filename,"group1","string1",group1%string1)
    call nml_read(filename,"group1","string2",group1%string2)
!     call nml_read(filename,"group1","stringarr1",group1%stringarr1)
    call nml_read(filename,"group1","logical1",group1%logical1)
    call nml_read(filename,"group1","integer1",group1%integer1)
    call nml_read(filename,"group1","integer2",group1%integer2)
    
    write(*,*) "group2 ==========="
    call nml_read(filename,"group2","string1",group2%string1)
    call nml_read(filename,"group2","string2",group2%string2)
!     call nml_read(filename,"group2","stringarr1",group2%stringarr1)
    call nml_read(filename,"group2","logical1",group2%logical1)
    call nml_read(filename,"group2","integer1",group2%integer1)
    call nml_read(filename,"group2","integer2",group2%integer2)
!     call nml_read(filename,"group2","intarr1",group2%intarr1)
    call nml_read(filename,"group2","double1",group2%double1)
    

    return 

end program test 

