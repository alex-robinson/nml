

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
        double precision :: dblarr1(6)
        logical :: logarr1(5)
    end type 

    type(pars_group1) :: group1 
    type(pars_group2) :: group2 
    character(len=256) :: filename 

    integer :: io 

    filename = "namelist.nml" 

    ! Open the file first to make sure this works
    io = 16 
    open(io,file=trim(filename),status="old")

    ! Read parameters from file
    call nml_set_verbose(.TRUE.)
    write(*,*) "group1 ==========="
    call nml_read(filename,"group1","string1",group1%string1)
    call nml_read(filename,"group1","string2",group1%string2)
    call nml_read(filename,"group1","stringarr1",group1%stringarr1)
    call nml_read(filename,"group1","logical1",group1%logical1)
    call nml_read(filename,"group1","integer1",group1%integer1)
    call nml_read(filename,"group1","integer2",group1%integer2)
    
    call nml_set_verbose(.FALSE.)
    write(*,*) "group2 ==========="
    call nml_read(filename,"group2","string1",group2%string1)
    call nml_read(filename,"group2","string2",group2%string2)
    call nml_read(filename,"group2","stringarr1",group2%stringarr1)
    call nml_read(filename,"group2","logical1",group2%logical1)
    call nml_read(filename,"group2","integer1",group2%integer1)
    call nml_read(filename,"group2","integer2",group2%integer2)
    call nml_read(filename,"group2","intarr1",group2%intarr1,init=.TRUE.)
    call nml_read(filename,"group2","double1",group2%double1)
    call nml_read(filename,"group2","dblarr1",group2%dblarr1)
    call nml_read(filename,"group2","logarr1",group2%logarr1)
    


    return 

end program test 

