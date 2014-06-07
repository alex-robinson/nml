

module nml 


    implicit none 





    private 
    public :: nml_read, nml_write 


contains


    subroutine nml_read(filename,group)

        implicit none 

        character(len=*) :: filename, group 


        return 

    end subroutine nml_read

    subroutine nml_write(filename,group)

        implicit none 

        character(len=*) :: filename, group 


        return 

    end subroutine nml_write






end module nml 

