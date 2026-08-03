program main
    implicit none
    call greet("shork")

contains

    subroutine greet(name)
        character(len=*), intent(in) :: name
        print '(A)', "Hello, " // name // "! :3"
    end subroutine greet

end program main
