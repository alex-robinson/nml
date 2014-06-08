

program test

    use nml 

    implicit none 



    character(len=512) :: filename, group, name, comment 
    character(len=512) :: value_str 
    real(8)   :: value_double

    filename = "namelist.nml" 
    name     = "double1"

    call nml_read(filename,"group2",name,value_double,comment)
    call nml_print(name,value_double,comment)

    return 

end program test 

