

module nml 


    implicit none 



    interface nml_read 
        module procedure nml_read_string, nml_read_double, nml_read_float 
    end interface 

    interface nml_write
        module procedure nml_write_string 
    end interface 

    interface nml_print 
        module procedure nml_print_string, nml_print_double, nml_print_float  
    end interface 

    private 
    public :: nml_read, nml_write 
    public :: nml_print 


contains

    ! =============================================================
    !
    ! nml parameter reading functions
    !
    ! =============================================================

    ! This is the basic nml reading subroutine
    ! All interfaces use this to read the parameter, then it
    ! is converted to the correct type
    subroutine nml_read_string(filename,group,name,value,comment)

        implicit none 

        character(len=*), intent(INOUT) :: value 
        character(len=*), intent(IN)    :: filename, group, name 
        character(len=*), intent(INOUT), optional :: comment   

        integer, parameter :: io = 188
        integer :: iostat, l, ltype 
        character(len=1000) :: line, name1, value1, comment1 

        logical :: ingroup 

        ! Open the nml filename to be read 
        open(io,file=filename,status="old",iostat=iostat)
        if (iostat /= 0) then 
            write(*,*) "nml:: namelist file could not be opened: "//trim(filename)
            stop 
        end if 

        ingroup = .FALSE. 

        do l = 1, 5000
            read(io,"(a1000)",iostat=iostat) line 
            if (iostat /= 0) exit 
            call parse_line(line, ltype, name1, value1, comment1 )

            ! Check if the parameter has been found
            if (ingroup .and. ltype == 3) then 
                if (trim(name1) == trim(name)) then 
                    value   = trim(value1)
                    comment = trim(comment1)
                    exit 
                end if 
            end if 

            ! Open and close group as necessary
            if (ltype == 1 .and. trim(name1) == trim(group)) ingroup = .TRUE. 
            if (ltype == 2)                                  ingroup = .FALSE. 

        end do 

        return 

    end subroutine nml_read_string

    subroutine nml_read_double(filename,group,name,value,comment)

        implicit none 

        double precision, intent(INOUT) :: value 
        character(len=*), intent(IN)    :: filename, group, name 
        character(len=*), intent(INOUT), optional :: comment   
        character(len=256) :: value_str 

        ! First find parameter value as a string 
        value_str = ""
        call nml_read_string(filename,group,name,value_str,comment)

        if (value_str /= "") then 
            value = string_to_double(value_str)
        end if 

        return 

    end subroutine nml_read_double 

    subroutine nml_read_float(filename,group,name,value,comment)

        implicit none 

        real(4), intent(INOUT) :: value 
        character(len=*), intent(IN)    :: filename, group, name 
        character(len=*), intent(INOUT), optional :: comment   
        character(len=256) :: value_str 

        ! First find parameter value as a string 
        value_str = ""
        call nml_read_string(filename,group,name,value_str,comment)

        if (value_str /= "") then 
            value = real(string_to_double(value_str))
        end if 

        return 

    end subroutine nml_read_float 

    ! =============================================================
    !
    ! nml parameter writing functions
    !
    ! =============================================================

    ! This is the basic nml writing subroutine
    ! All interfaces use this to write the parameter to file, after
    ! converting the parameter to a string
    subroutine nml_write_string(filename,group,name,value,comment)

        implicit none 

        character(len=*), intent(IN) :: filename, group, name, value 
        character(len=*), intent(IN), optional :: comment  


        return 

    end subroutine nml_write_string 

    ! =============================================================
    !
    ! nml line printing functions
    !
    ! =============================================================

    ! This is the basic routine for printing a parameter to a formatted line
    ! All other interfaces use this routine after converting to a string.
    subroutine nml_print_string(name,value,comment,io)

        implicit none 
        character(len=*) :: name, value 
        character(len=*), optional :: comment 
        integer, optional :: io 
        integer :: io_val 
        character(len=1000) :: line
        character(len=500)  :: comment1 

        io_val = 6 
        if (present(io)) io_val = io 

        comment1 = "" 
        if (present(comment)) comment1 = "   "//trim(comment)

        write(line,"(a)") "    "//trim(name)//" = "//trim(value)//trim(comment1)
        write(io_val,*) trim(line)

        return 

    end subroutine nml_print_string 

    subroutine nml_print_double(name,value,comment,io)

        implicit none 
        double precision :: value
        character(len=*) :: name 
        character(len=*), optional :: comment
        integer, optional :: io 
        character(len=500) :: value_str  

        write(value_str,"(g15.3)") value 
        call nml_print_string(name,value_str,comment,io)

        return 

    end subroutine nml_print_double
    
    subroutine nml_print_float(name,value,comment,io)

        implicit none 
        real(4) :: value
        character(len=*) :: name 
        character(len=*), optional :: comment
        integer, optional :: io 
        character(len=500) :: value_str  

        write(value_str,"(g15.3)") value 
        call nml_print_string(name,value_str,comment,io)

        return 

    end subroutine nml_print_float
    


    ! =============================================================
    !
    ! Type conversion functions
    !
    ! =============================================================

    function string_to_double(string) result(value)

        implicit none 

        character(len=*), intent(IN) :: string 
        double precision :: value 

        character(len=100) :: tmpstr 
        integer :: stat, n
        double precision :: x 

        tmpstr = trim(adjustl(string))
        n      = len_trim(tmpstr)

        read(tmpstr(1:n),*,IOSTAT=stat) x

        value = 0
        if (stat .eq. 0) then 
            value = x 
        else
            n = len_trim(tmpstr)-1
            READ(tmpstr(1:n),*,IOSTAT=stat) x
            if (stat .ne. 0) then 
                write(*,*) "nml:: ","Error converting string to number!"
                write(*,*) "|",trim(tmpstr),"|",n,stat,x
            else
                value = x 
            end if 
        end if 

        return 

    end function string_to_double

    ! =============================================================
    !
    ! Helper functions
    !
    ! =============================================================

    ! This function parses a namelist line into pieces, determining
    ! whether it is a blank line (-2), comment (-1), group name (1)
    ! end-of-group (2), or a parameter line (3)
    subroutine parse_line(line,linetype,name,value,comment)

        implicit none 
        character(len=*), intent(IN)    :: line
        character(len=*), intent(INOUT) :: name, value, comment 
        integer :: linetype

        character(len=1000) :: line1 
        integer :: q, q1, q2

        name     = ""
        value    = ""
        comment  = "" 

        line1 = trim(adjustl(line))

        if (trim(line1) == "") then         ! Blank line
            linetype = -2 
            
        else if (line1(1:1) == "!") then    ! Comment line 
            linetype = -1 
            comment = trim(line1)

        else if (line1(1:1) == "&") then    ! Group name 
            linetype = 1 
            q = len_trim(line1)
            name     = line1(2:q)

        else if (line1(1:1) == "/") then    ! End of group 
            linetype = 2 

        else   ! Line must contain parameter to read
            linetype = 3

            q = index(line1,"=")
            if (q == 0) then 
                write(*,*) "nml:: Error reading namelist file."
                write(*,*) "No '=' found on parameter line."
                stop 
            end if 

            name = trim(adjustl(line1(1:q-1)))

            q1 = index(line1,"!")
            q2 = len_trim(line1)

            if (q1 > 0) then 
                comment = trim(adjustl(line1(q1:q2)))
                value   = trim(adjustl(line1(q+1:q1-1)))
            else
                value   = trim(adjustl(line1(q+1:q2)))
            end if 

        end if 

        return 

    end subroutine parse_line 

end module nml 
